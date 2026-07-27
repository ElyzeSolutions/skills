#!/usr/bin/env bash
set -euo pipefail

profile="standard"
force=0
fallback_enabled="${CLAUDE_REVIEW_FALLBACK:-1}"
wrapper_version="3"

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

if ! command -v git >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1 || ! command -v sha256sum >/dev/null 2>&1; then
  echo "git, jq, and sha256sum are required." >&2
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
    max_review_turns=8
    max_inspection_turns=5
    ;;
  standard)
    model="${CLAUDE_REVIEW_MODEL:-claude-opus-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-medium}"
    default_timeout=600
    max_review_turns=12
    max_inspection_turns=8
    ;;
  deep)
    model="${CLAUDE_REVIEW_MODEL:-claude-opus-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-high}"
    default_timeout=1800
    max_review_turns=18
    max_inspection_turns=14
    ;;
  frontier)
    model="${CLAUDE_REVIEW_MODEL:-claude-fable-5}"
    effort="${CLAUDE_REVIEW_EFFORT:-high}"
    default_timeout=900
    max_review_turns=18
    max_inspection_turns=14
    ;;
esac

timeout_seconds="${CLAUDE_REVIEW_TIMEOUT_SECONDS:-$default_timeout}"
if ! [[ "$timeout_seconds" =~ ^[1-9][0-9]*$ ]]; then
  echo "CLAUDE_REVIEW_TIMEOUT_SECONDS must be a positive integer." >&2
  exit 2
fi
deadline_minutes=$(( (timeout_seconds + 59) / 60 ))
cooldown_seconds="${CLAUDE_REVIEW_COOLDOWN_SECONDS:-1800}"
if ! [[ "$cooldown_seconds" =~ ^[0-9]+$ ]]; then
  echo "CLAUDE_REVIEW_COOLDOWN_SECONDS must be a non-negative integer." >&2
  exit 2
fi
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

fingerprint_untracked_directory() {
  local directory="$1" path="$2" nested_root nested_head nested_path nested_full_path file relative_file

  directory="${directory%/}"
  path="${path%/}"
  nested_root="$(git -C "$directory" rev-parse --show-toplevel 2>/dev/null || true)"
  if [[ "$nested_root" == "$directory" ]]; then
    if nested_head="$(git -C "$directory" rev-parse --verify HEAD 2>/dev/null)"; then
      printf 'untracked-nested-repository=%s\nhead=%s\n' "$path" "$nested_head"
      git -C "$directory" diff --binary HEAD
    else
      printf 'untracked-commitless-repository=%s\n' "$path"
    fi
    git -C "$directory" diff --binary --cached
    git -C "$directory" diff --binary
    while IFS= read -r -d '' nested_path; do
      nested_full_path="$directory/$nested_path"
      if [[ -L "$nested_full_path" ]]; then
        printf 'nested-untracked-symlink=%s/%s\ntarget=%s\n' \
          "$path" "${nested_path%/}" "$(readlink -- "$nested_full_path")"
      elif [[ -f "$nested_full_path" ]]; then
        printf 'nested-untracked-file=%s/%s\n' "$path" "$nested_path"
        sha256sum -- "$nested_full_path"
      elif [[ -d "$nested_full_path" ]]; then
        fingerprint_untracked_directory "$nested_full_path" "$path/$nested_path"
      else
        printf 'nested-untracked-other=%s/%s\n' "$path" "$nested_path"
      fi
    done < <(git -C "$directory" ls-files --others --exclude-standard -z)
    return
  fi

  printf 'untracked-directory=%s\n' "$path"
  while IFS= read -r -d '' file; do
    relative_file="${file#"$repo_root"/}"
    if [[ -L "$file" ]]; then
      printf 'untracked-directory-symlink=%s\ntarget=%s\n' "$relative_file" "$(readlink -- "$file")"
    else
      printf 'untracked-directory-file=%s\n' "$relative_file"
      sha256sum -- "$file"
    fi
  done < <(find -P "$directory" -name .git -prune -o \( -type f -o -type l \) -print0 | sort -z)
}

fingerprint="$({
  printf 'wrapper=%s\nbase=%s\nprofile=%s\nmodel=%s\neffort=%s\nfocus=%s\n' \
    "$wrapper_version" "$(git rev-parse "${base_ref}^{commit}")" "$profile" "$model" "$effort" "$focus"
  git diff --binary "${base_ref}...HEAD"
  git diff --binary --cached
  git diff --binary
  while IFS= read -r -d '' path; do
    if [[ -L "$repo_root/$path" ]]; then
      printf 'untracked-symlink=%s\ntarget=%s\n' "$path" "$(readlink -- "$repo_root/$path")"
    elif [[ -f "$repo_root/$path" ]]; then
      printf 'untracked-file=%s\n' "$path"
      sha256sum -- "$repo_root/$path"
    elif [[ -d "$repo_root/$path" ]]; then
      fingerprint_untracked_directory "$repo_root/$path" "$path"
    else
      printf 'untracked-other=%s\n' "$path"
    fi
  done < <(git ls-files --others --exclude-standard -z)
} | sha256sum | cut -d' ' -f1)"

cache_output="${cache_dir}/${fingerprint}.txt"

json_escape() {
  printf '%s' "$1" | sed ':a;N;$!ba;s/\\/\\\\/g;s/"/\\"/g;s/\n/\\n/g'
}

record_telemetry() {
  local reviewer="$1" selected_model="$2" selected_effort="$3" duration="$4" status="$5" cache_state="$6"
  local reason="${7:-unknown}" turns="${8:-0}" output_bytes="${9:-0}" last_event="${10:-none}"
  printf '{"timestamp":"%s","repository":"%s","fingerprint":"%s","wrapper_version":"%s","profile":"%s","reviewer":"%s","model":"%s","effort":"%s","timeout_seconds":%s,"duration_seconds":%s,"exit_status":%s,"reason":"%s","turns":%s,"output_bytes":%s,"last_event":"%s","cache":"%s"}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(json_escape "$repo_root")" "$fingerprint" "$wrapper_version" \
    "$profile" "$reviewer" "$selected_model" "$selected_effort" "$timeout_seconds" "$duration" "$status" \
    "$(json_escape "$reason")" "$turns" "$output_bytes" "$(json_escape "$last_event")" "$cache_state" >> "$telemetry_file"
}

validate_review_output() {
  local output_file="$1"
  [[ -s "$output_file" ]] &&
    grep -Eq '^[[:space:]#*_>-]*VERDICT:[[:space:]*_]*(SHIP-WITH-FIXES|FIX-FIRST|SHIP)([[:space:]*_]*([.,;]|--|-|—|\().*)?[[:space:]*_]*$' "$output_file" &&
    grep -Eiq '^[[:space:]#*_>-]*FINDINGS([[:space:]*_]*:|[[:space:]*_]*$)' "$output_file" &&
    grep -Eiq '^[[:space:]#*_>-]*TEST GAPS([[:space:]*_]*:|[[:space:]*_]*$)' "$output_file" &&
    grep -Eiq '^[[:space:]#*_>-]*CHALLENGED ASSUMPTIONS([[:space:]*_]*:|[[:space:]*_]*$)' "$output_file" &&
    grep -Eiq '^[[:space:]#*_>-]*CHECKED AND CLEAN([[:space:]*_]*:|[[:space:]*_]*$)' "$output_file"
}

write_cache() {
  local source_file="$1" reviewer="$2" output_tmp
  if ! output_tmp="$(mktemp "${cache_output}.tmp.XXXXXX")"; then
    return 1
  fi

  if {
    printf 'REVIEWER: %s\n' "$reviewer"
    sed '/^REVIEWER:/d' "$source_file"
  } > "$output_tmp" &&
    mv -- "$output_tmp" "$cache_output"; then
    return 0
  fi

  rm -f -- "$output_tmp"
  return 1
}

write_last_review() {
  local last_review_tmp
  if ! last_review_tmp="$(mktemp "${last_review_file}.tmp.XXXXXX")"; then
    return 1
  fi
  if printf '%s %s\n' "$(date +%s)" "$fingerprint" > "$last_review_tmp" &&
    mv -- "$last_review_tmp" "$last_review_file"; then
    return 0
  fi
  rm -f -- "$last_review_tmp"
  return 1
}

if [[ -s "$cache_output" && $force -eq 0 ]] && validate_review_output "$cache_output"; then
  cached_reviewer="$(sed -n 's/^REVIEWER:[[:space:]]*//p' "$cache_output" | head -n 1)"
  cached_reviewer="${cached_reviewer%% *}"
  if [[ "$cached_reviewer" == "claude" ]] ||
    [[ "$cached_reviewer" == "codex-auto-review" && "$profile" != "deep" && "$profile" != "frontier" ]]; then
    echo "REVIEW CACHE HIT: unchanged diff reviewed by ${cached_reviewer}." >&2
    cat "$cache_output"
    cached_bytes="$(stat -c %s "$cache_output")"
    record_telemetry "$cached_reviewer" "$model" "$effort" 0 0 "hit" "cache_hit" 0 "$cached_bytes" "cache"
    exit 0
  fi
fi

now_epoch="$(date +%s)"
if [[ -s "$last_review_file" && $force -eq 0 ]]; then
  last_epoch=""
  last_fingerprint=""
  if read -r last_epoch last_fingerprint < "$last_review_file" &&
    [[ "$last_epoch" =~ ^[0-9]+$ ]] &&
    [[ -n "$last_fingerprint" ]] &&
    (( last_epoch <= now_epoch )); then
    elapsed=$((now_epoch - last_epoch))
    if (( elapsed < cooldown_seconds )) && [[ "$last_fingerprint" != "$fingerprint" ]]; then
      echo "Review cooldown active for another $((cooldown_seconds - elapsed)) seconds." >&2
      echo "Finish and validate the complete change before reviewing. Use --force only for a confirmed P0/P1 fix or material risk/interface change." >&2
      record_telemetry "none" "$model" "$effort" 0 75 "cooldown" "cooldown"
      exit 75
    fi
  else
    echo "Ignoring malformed review cooldown state." >&2
  fi
fi

prompt=$(printf '%s\n' \
  "Act as a hostile-but-precise senior reviewer. Work read-only." \
  "Repository: ${repo_root}" \
  "Comparison base: ${base_ref}" \
  "Review profile: ${profile}" \
  "Review focus: ${focus}" \
  "Execution budget: finish within ${deadline_minutes} minutes and at most ${max_review_turns} assistant turns. Use no more than ${max_inspection_turns} turns for repository inspection. Once that inspection budget is reached, stop using tools and immediately produce the required final contract. Reserve the remaining turns for synthesis and the final answer." \
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

tmp_events="$(mktemp)"
tmp_stderr="$(mktemp)"
tmp_output="$(mktemp)"
tmp_unvalidated="$(mktemp)"
tmp_diagnostics="$(mktemp)"
fallback_output="$(mktemp)"
normalized_fallback="$(mktemp)"
trap 'rm -f "$tmp_events" "$tmp_stderr" "$tmp_output" "$tmp_unvalidated" "$tmp_diagnostics" "$fallback_output" "$normalized_fallback"' EXIT

claude_status=127
start_epoch="$(date +%s)"
if command -v claude >/dev/null 2>&1; then
  set +e
  timeout --kill-after=10 "${timeout_seconds}" claude \
    --print \
    --safe-mode \
    --model "${model}" \
    --effort "${effort}" \
    --dangerously-skip-permissions \
    --tools "Read,Grep,Glob,Bash" \
    --no-session-persistence \
    --output-format stream-json \
    --verbose \
    --append-system-prompt "You are the independent review model. Never delegate to Codex or another model, and never modify repository or external state." \
    "${prompt}" 2> >(tee "$tmp_stderr" >&2) |
    tee "$tmp_events" |
    jq -R --unbuffered -r '
      fromjson? | objects |
      if .type == "assistant" then
        ([.message.content[]? | select(.type == "tool_use") | .name] | unique) as $tools |
        "Claude review progress: assistant turn completed" +
        (if ($tools | length) > 0 then " (tools: " + ($tools | join(",")) + ")" else "" end)
      elif .type == "result" then
        "Claude review progress: final result event received"
      else empty end
    ' >&2
  claude_status=${PIPESTATUS[0]}
  set -e
else
  printf '%s\n' "Claude Code CLI is not installed or not on PATH." | tee "$tmp_stderr" >&2
fi
duration=$(( $(date +%s) - start_epoch ))

claude_turns="$(jq -Rs '[splits("\n") | fromjson? | objects | select(.type == "assistant")] | length' "$tmp_events" 2>/dev/null || printf '0')"
last_event="$(jq -Rsr '[splits("\n") | fromjson? | objects | .type // empty] | last // "none"' "$tmp_events" 2>/dev/null || printf 'none')"
jq -Rsr '
  [splits("\n") | fromjson? | objects |
    select(.type == "result" and .subtype == "success" and (.is_error != true)) |
    .result // empty] |
  last // empty
' "$tmp_events" > "$tmp_output" 2>/dev/null || true
jq -Rsr '
  [splits("\n") | fromjson? | objects |
    if .type == "result" then
      .result // empty
    elif .type == "assistant" then
      .message.content[]? | select(.type == "text") | .text
    else
      empty
    end |
    strings |
    select(test("\\S"))] |
  last // empty
' "$tmp_events" > "$tmp_unvalidated" 2>/dev/null || true
jq -Rr '
  (try fromjson catch null) as $event |
  if ($event | type) == "object" and
    $event.type == "result" and
    ($event.is_error == true or $event.subtype != "success") then
    $event.result // empty
  else
    empty
  end
' "$tmp_events" > "$tmp_diagnostics" 2>/dev/null || true
output_bytes="$(stat -c %s "$tmp_output")"

if [[ $claude_status -eq 0 ]] && validate_review_output "$tmp_output"; then
  cat "$tmp_output"
  cache_state="miss"
  if ! write_cache "$tmp_output" "claude"; then
    cache_state="write_failed"
    echo "Warning: Claude review succeeded, but its verdict could not be cached." >&2
  fi
  if ! write_last_review; then
    cache_state="write_failed"
    echo "Warning: Claude review succeeded, but cooldown state could not be recorded." >&2
  fi
  record_telemetry "claude" "$model" "$effort" "$duration" 0 "$cache_state" "success" "$claude_turns" "$output_bytes" "$last_event"
  exit 0
fi

fallback_reason=""
if [[ $claude_status -eq 0 ]]; then
  claude_status=65
  fallback_reason="invalid_output"
  echo "Claude exited successfully but did not return a complete valid review contract." >&2
elif [[ $claude_status -eq 124 || ( $claude_status -eq 137 && $duration -ge $timeout_seconds ) ]]; then
  fallback_reason="timeout"
  echo "Claude review timed out after ${timeout_seconds} seconds while still active; no independent verdict was returned." >&2
elif grep -Eiq "usage limit|rate.?limit|quota|resets? at|overloaded|not available|not installed|not on PATH" \
  "$tmp_stderr" "$tmp_diagnostics"; then
  fallback_reason="unavailable"
fi

if [[ "$fallback_reason" == "invalid_output" || "$fallback_reason" == "timeout" ]]; then
  unvalidated_source="$tmp_output"
  if ! grep -q '[^[:space:]]' "$unvalidated_source"; then
    unvalidated_source="$tmp_unvalidated"
  fi
  if [[ -s "$unvalidated_source" ]]; then
    {
      echo "----- UNVALIDATED CLAUDE OUTPUT (NOT A VERDICT) -----"
      cat "$unvalidated_source"
      echo "----- END UNVALIDATED CLAUDE OUTPUT -----"
    } >&2
  fi
fi

record_telemetry "claude" "$model" "$effort" "$duration" "$claude_status" "miss" \
  "${fallback_reason:-claude_error}" "$claude_turns" "$output_bytes" "$last_event"

if [[ "$fallback_enabled" != "1" ]]; then
  exit "$claude_status"
fi

if [[ -z "$fallback_reason" ]]; then
  echo "Claude review failed for a reason that does not qualify for automatic fallback." >&2
  exit "$claude_status"
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI is unavailable; cannot run the read-only fallback." >&2
  exit 127
fi

echo "Claude review ended with ${fallback_reason}; running one read-only Codex Auto Review fallback." >&2
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
  record_telemetry "codex-auto-review" "$fallback_model" "n/a" "$fallback_duration" "$fallback_status" "miss" "fallback_error"
  exit "$fallback_status"
fi

if ! grep -Eq '^REVIEWER:[[:space:]]*codex-auto-review' "$fallback_output"; then
  {
    echo "REVIEWER: codex-auto-review (degraded provider independence)"
    cat "$fallback_output"
  } > "$normalized_fallback"
  mv "$normalized_fallback" "$fallback_output"
fi

if ! validate_review_output "$fallback_output"; then
  fallback_bytes="$(stat -c %s "$fallback_output")"
  echo "Codex Auto Review fallback did not return a complete valid review contract." >&2
  record_telemetry "codex-auto-review" "$fallback_model" "n/a" "$fallback_duration" 65 "miss" \
    "invalid_output" 0 "$fallback_bytes" "result"
  exit 65
fi

cat "$fallback_output"
fallback_bytes="$(stat -c %s "$fallback_output")"

if [[ "$profile" == "deep" || "$profile" == "frontier" ]]; then
  record_telemetry "codex-auto-review" "$fallback_model" "n/a" "$fallback_duration" 0 "miss" \
    "success_after_${fallback_reason}" 0 "$fallback_bytes" "result"
  echo "High-risk review completed only by the same-provider fallback; independent release gate remains unresolved." >&2
  exit 3
fi

cache_state="miss"
if ! write_cache "$fallback_output" "codex-auto-review"; then
  cache_state="write_failed"
  echo "Warning: Codex fallback succeeded, but its verdict could not be cached." >&2
fi
if ! write_last_review; then
  cache_state="write_failed"
  echo "Warning: Codex fallback succeeded, but cooldown state could not be recorded." >&2
fi
record_telemetry "codex-auto-review" "$fallback_model" "n/a" "$fallback_duration" 0 "$cache_state" \
  "success_after_${fallback_reason}" 0 "$fallback_bytes" "result"
exit 0
