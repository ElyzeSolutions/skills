#!/usr/bin/env bash
set -euo pipefail

profile="standard"
force=0
fallback_enabled="${CLAUDE_REVIEW_FALLBACK:-1}"

usage() {
  cat <<'EOF'
Usage: review.sh [--fast|--deep|--frontier] [--force] [--no-fallback] [base-ref] [focus]

Profiles:
  --fast      Sonnet 5/low only for explicitly requested easy, small, low-risk reviews
  default     Opus 5/medium for most production changes
  --deep      Opus 5/high for security, auth, payments, migrations, concurrency, or data-loss risk
  --frontier  Fable 5/high only for genuinely exceptional cross-system complexity
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fast|--deep|--frontier)
      profile="${1#--}"
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    --no-fallback)
      fallback_enabled=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

base_ref="${1:-origin/main}"
shift || true
focus="${*:-Review the complete final change for correctness, contract integrity, security, reliability, and test quality.}"

if ! command -v git >/dev/null 2>&1 || ! command -v sha256sum >/dev/null 2>&1; then
  echo "git and sha256sum are required." >&2
  exit 127
fi

repo_root="$(git rev-parse --show-toplevel)"
if ! git rev-parse --verify "${base_ref}^{commit}" >/dev/null 2>&1; then
  echo "Unknown base ref: ${base_ref}" >&2
  exit 2
fi

case "${profile}" in
  fast)
    model="${CLAUDE_REVIEW_MODEL:-claude-sonnet-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-low}"
    default_timeout=300
    ;;
  standard)
    model="${CLAUDE_REVIEW_MODEL:-claude-opus-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-medium}"
    default_timeout=600
    ;;
  deep)
    model="${CLAUDE_REVIEW_MODEL:-claude-opus-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-high}"
    default_timeout=900
    ;;
  frontier)
    model="${CLAUDE_REVIEW_MODEL:-claude-fable-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-high}"
    default_timeout=900
    ;;
esac

timeout_seconds="${CLAUDE_REVIEW_TIMEOUT_SECONDS:-$default_timeout}"
cooldown_seconds="${CLAUDE_REVIEW_COOLDOWN_SECONDS:-1800}"
cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/codex/claude-adversarial-review"
repo_key="$(printf '%s' "$repo_root" | sha256sum | cut -d' ' -f1)"
cache_dir="${cache_root}/${repo_key}"
mkdir -p "$cache_dir"
telemetry_file="${cache_root}/telemetry.jsonl"
last_review_file="${cache_dir}/last-review"

changed_paths="$({
  git diff --name-only "${base_ref}...HEAD"
  git diff --cached --name-only
  git diff --name-only
  git ls-files --others --exclude-standard
} | sort -u | sed -n '1,200p')"

fingerprint="$({
  printf 'base=%s\nprofile=%s\nmodel=%s\neffort=%s\nfocus=%s\n' \
    "$(git rev-parse "${base_ref}^{commit}")" "$profile" "$model" "$effort" "$focus"
  git diff --binary "${base_ref}...HEAD"
  git diff --binary --cached
  git diff --binary
  while IFS= read -r -d '' path; do
    printf 'untracked=%s\n' "$path"
    sha256sum -- "$repo_root/$path"
  done < <(git ls-files --others --exclude-standard -z)
} | sha256sum | cut -d' ' -f1)"

cache_output="${cache_dir}/${fingerprint}.txt"
cache_reviewer="${cache_dir}/${fingerprint}.reviewer"

json_escape() {
  printf '%s' "$1" | sed ':a;N;$!ba;s/\\/\\\\/g;s/"/\\"/g;s/\n/\\n/g'
}

record_telemetry() {
  local reviewer="$1" selected_model="$2" selected_effort="$3" duration="$4" status="$5" cache_state="$6"
  printf '{"timestamp":"%s","repository":"%s","fingerprint":"%s","profile":"%s","reviewer":"%s","model":"%s","effort":"%s","duration_seconds":%s,"exit_status":%s,"cache":"%s"}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(json_escape "$repo_root")" "$fingerprint" "$profile" \
    "$reviewer" "$selected_model" "$selected_effort" "$duration" "$status" "$cache_state" >> "$telemetry_file"
}

if [[ -s "$cache_output" && -s "$cache_reviewer" && $force -eq 0 ]]; then
  cached_reviewer="$(<"$cache_reviewer")"
  if [[ "$cached_reviewer" != "codex-auto-review" || ( "$profile" != "deep" && "$profile" != "frontier" ) ]]; then
    echo "REVIEW CACHE HIT: unchanged diff reviewed by ${cached_reviewer}." >&2
    cat "$cache_output"
    record_telemetry "$cached_reviewer" "$model" "$effort" 0 0 "hit"
    exit 0
  fi
fi

now_epoch="$(date +%s)"
if [[ -s "$last_review_file" && $force -eq 0 ]]; then
  read -r last_epoch last_fingerprint < "$last_review_file" || true
  elapsed=$((now_epoch - last_epoch))
  if (( elapsed < cooldown_seconds )) && [[ "$last_fingerprint" != "$fingerprint" ]]; then
    echo "Review cooldown active for another $((cooldown_seconds - elapsed)) seconds." >&2
    echo "Finish and validate the complete change before reviewing. Use --force only for a confirmed P0/P1 fix or material risk/interface change." >&2
    record_telemetry "none" "$model" "$effort" 0 75 "cooldown"
    exit 75
  fi
fi

prompt=$(printf '%s\n' \
  "Act as a hostile-but-precise senior reviewer. Work read-only." \
  "Repository: ${repo_root}" \
  "Comparison base: ${base_ref}" \
  "Review profile: ${profile}" \
  "Review focus: ${focus}" \
  "Changed paths (prioritize these; inspect nearby code only when needed):" \
  "${changed_paths:-<none detected>}" \
  "" \
  "Inspect the final live change yourself. Review the merge-base diff against ${base_ref}, staged and unstaged changes, and relevant untracked files. Read governing specs and nearby implementation only where needed to substantiate a concrete failure mode. Do not edit files. Do not invoke other models, agents, plugins, MCP tools, or network tools. Do not create commits." \
  "" \
  "Challenge correctness, interface invariants, status transitions, nullability, authorization identity separation, idempotency, concurrency, data loss, rollback, operational assumptions, and whether tests would catch realistic regressions, but spend effort in proportion to the selected profile and actual changed paths. Passed tests are evidence, not proof. Report only issues you can substantiate from the repository." \
  "" \
  "Output exactly these sections:" \
  "VERDICT: SHIP | SHIP-WITH-FIXES | FIX-FIRST" \
  "FINDINGS: severity ordered (P0-P3), each with exact file:line, trigger, impact, and smallest safe fix direction; write 'none' if empty" \
  "TEST GAPS: concrete missing or misleading cases; write 'none' if empty" \
  "CHALLENGED ASSUMPTIONS: hidden assumptions and whether they hold" \
  "CHECKED AND CLEAN: important areas inspected without a confirmed issue")

tmp_output="$(mktemp)"
fallback_output="$(mktemp)"
trap 'rm -f "$tmp_output" "$fallback_output"' EXIT

claude_status=127
start_epoch="$(date +%s)"
if command -v claude >/dev/null 2>&1; then
  set +e
  timeout --foreground "${timeout_seconds}" claude \
    --print \
    --safe-mode \
    --model "${model}" \
    --effort "${effort}" \
    --dangerously-skip-permissions \
    --tools "Read,Grep,Glob,Bash" \
    --no-session-persistence \
    --output-format text \
    --append-system-prompt "You are the independent review model. Never delegate to Codex or another model, and never modify repository or external state." \
    "${prompt}" 2>&1 | tee "$tmp_output"
  claude_status=${PIPESTATUS[0]}
  set -e
else
  printf '%s\n' "Claude Code CLI is not installed or not on PATH." | tee "$tmp_output" >&2
fi
duration=$(( $(date +%s) - start_epoch ))

if [[ $claude_status -eq 0 ]]; then
  cp "$tmp_output" "$cache_output"
  printf '%s\n' "claude" > "$cache_reviewer"
  printf '%s %s\n' "$(date +%s)" "$fingerprint" > "$last_review_file"
  record_telemetry "claude" "$model" "$effort" "$duration" 0 "miss"
  exit 0
fi

record_telemetry "claude" "$model" "$effort" "$duration" "$claude_status" "miss"

if [[ "$fallback_enabled" != "1" ]]; then
  exit "$claude_status"
fi

if ! grep -Eiq "usage limit|rate.?limit|quota|resets? at|overloaded|not available|not installed|not on PATH" "$tmp_output"; then
  echo "Claude review failed for a reason that does not qualify for automatic fallback." >&2
  exit "$claude_status"
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI is unavailable; cannot run the read-only fallback." >&2
  exit 127
fi

echo "Claude is unavailable or quota-limited; running one read-only Codex Auto Review fallback." >&2
fallback_model="${CODEX_REVIEW_MODEL:-codex-auto-review}"
fallback_prompt=$(printf '%s\n' \
  "REVIEWER: codex-auto-review (degraded provider independence)" \
  "Perform one read-only review using the requested output contract. Do not edit files, invoke Claude, invoke subagents, or change external state." \
  "${prompt}")

fallback_start="$(date +%s)"
set +e
codex exec review \
  --base "$base_ref" \
  --model "$fallback_model" \
  --ephemeral \
  --config 'sandbox_mode="read-only"' \
  --config 'approval_policy="never"' \
  --config project_doc_max_bytes=0 \
  --output-last-message "$fallback_output" \
  "$fallback_prompt"
fallback_status=$?
set -e
fallback_duration=$(( $(date +%s) - fallback_start ))

if [[ $fallback_status -ne 0 ]]; then
  record_telemetry "codex-auto-review" "$fallback_model" "n/a" "$fallback_duration" "$fallback_status" "miss"
  exit "$fallback_status"
fi

{
  echo "REVIEWER: codex-auto-review (degraded provider independence)"
  cat "$fallback_output"
} | tee "$cache_output"
printf '%s\n' "codex-auto-review" > "$cache_reviewer"
record_telemetry "codex-auto-review" "$fallback_model" "n/a" "$fallback_duration" 0 "miss"

if [[ "$profile" == "deep" || "$profile" == "frontier" ]]; then
  echo "High-risk review completed only by the same-provider fallback; independent release gate remains unresolved." >&2
  exit 3
fi

printf '%s %s\n' "$(date +%s)" "$fingerprint" > "$last_review_file"
exit 0
