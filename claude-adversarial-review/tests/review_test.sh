#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
review_script="$(cd "${script_dir}/.." && pwd)/scripts/review.sh"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

fake_bin="${test_root}/bin"
repo="${test_root}/repo"
mkdir -p "$fake_bin" "$repo"

cat > "${fake_bin}/claude" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${FAKE_CLAUDE_CALLS:-}" ]]; then
  printf 'called\n' >> "$FAKE_CLAUDE_CALLS"
fi

valid_review=$(printf '%s\n' \
  'VERDICT: SHIP' \
  'FINDINGS: none' \
  'TEST GAPS: none' \
  'CHALLENGED ASSUMPTIONS: none' \
  'CHECKED AND CLEAN: wrapper behavior')

case "${FAKE_CLAUDE_MODE:-success}" in
  success)
    printf '%s\n' '{"type":"system","subtype":"init"}'
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{}}]}}'
    jq -nc --arg result "$valid_review" '{type:"result",subtype:"success",is_error:false,result:$result,num_turns:1}'
    ;;
  malformed-stream)
    printf '%s\n' 'upgrade notice: this is not JSON'
    printf '%s\n' '{"type":"system","subtype":"init"}'
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{}}]}}'
    jq -nc --arg result "$valid_review" '{type:"result",subtype:"success",is_error:false,result:$result,num_turns:1}'
    ;;
  nonobject-stream)
    printf '%s\n' '"upgrade available: run claude update"'
    printf '%s\n' '42'
    printf '%s\n' '["notice"]'
    printf '%s\n' '{"type":"system","subtype":"init"}'
    jq -nc --arg result "$valid_review" '{type:"result",subtype:"success",is_error:false,result:$result,num_turns:1}'
    ;;
  trailing-verdict)
    trailing_review="${valid_review/VERDICT: SHIP/VERDICT: SHIP — reviewed with no blockers.}"
    printf '%s\n' '{"type":"system","subtype":"init"}'
    jq -nc --arg result "$trailing_review" '{type:"result",subtype:"success",is_error:false,result:$result,num_turns:1}'
    ;;
  error-result)
    printf '%s\n' '{"type":"system","subtype":"init"}'
    jq -nc --arg result "$valid_review" '{type:"result",subtype:"error",is_error:true,result:$result,num_turns:1}'
    ;;
  template-echo)
    template_review=$(printf '%s\n' \
      'VERDICT: SHIP | SHIP-WITH-FIXES | FIX-FIRST' \
      'FINDINGS: severity ordered' \
      'TEST GAPS: concrete missing cases' \
      'CHALLENGED ASSUMPTIONS: hidden assumptions' \
      'CHECKED AND CLEAN: important areas')
    printf '%s\n' '{"type":"system","subtype":"init"}'
    jq -nc --arg result "$template_review" '{type:"result",subtype:"success",is_error:false,result:$result,num_turns:1}'
    ;;
  empty)
    printf '%s\n' '{"type":"system","subtype":"init"}'
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"text","text":"substantial partial evidence from empty result"}]}}'
    printf '%s\n' '{"type":"result","subtype":"success","is_error":false,"result":"","num_turns":1}'
    ;;
  invalid)
    printf '%s\n' '{"type":"system","subtype":"init"}'
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"text","text":"done"}]}}'
    jq -nc --arg result 'VERDICT: MAYBE' '{type:"result",subtype:"success",is_error:false,result:$result,num_turns:1}'
    ;;
  quota)
    printf 'usage limit reached; resets at midnight\n' >&2
    exit 1
    ;;
  quota-stdout)
    jq -nc --arg result 'usage limit reached; resets at midnight' \
      '{type:"result",subtype:"error_during_execution",is_error:true,result:$result,num_turns:1}'
    exit 1
    ;;
  timeout)
    printf '%s\n' '{"type":"system","subtype":"init"}'
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"text","text":"partial review evidence"},{"type":"tool_use","name":"Grep","input":{}}]}}'
    sleep 5
    ;;
  timeout-descendant)
    printf '%s\n' '{"type":"system","subtype":"init"}'
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Bash","input":{}}]}}'
    sleep 5 &
    wait
    ;;
  failure)
    printf 'unexpected transport failure\n' >&2
    exit 1
    ;;
  plain-failure-with-quota-prose)
    printf 'review discusses quota semantics but this is not a structured error\n'
    exit 1
    ;;
esac
EOF
chmod +x "${fake_bin}/claude"

cat > "${fake_bin}/codex" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

output_file=""
while [[ $# -gt 0 ]]; do
  if [[ "$1" == "--output-last-message" ]]; then
    output_file="$2"
    shift 2
    continue
  fi
  shift
done

if [[ -z "$output_file" ]]; then
  exit 2
fi

if [[ "${FAKE_CODEX_MODE:-success}" == "failure" ]]; then
  exit 1
fi

if [[ "${FAKE_CODEX_MODE:-success}" == "invalid" ]]; then
  printf 'VERDICT: MAYBE\n' > "$output_file"
  exit 0
fi

printf '%s\n' \
  'VERDICT: SHIP-WITH-FIXES' \
  'FINDINGS: none' \
  'TEST GAPS: none' \
  'CHALLENGED ASSUMPTIONS: provider independence is degraded' \
  'CHECKED AND CLEAN: fallback behavior' > "$output_file"
EOF
chmod +x "${fake_bin}/codex"

git -C "$repo" init -q
git -C "$repo" config user.name "Review Test"
git -C "$repo" config user.email "review-test@example.invalid"
printf 'base\n' > "${repo}/fixture.txt"
git -C "$repo" add fixture.txt
git -C "$repo" commit -q -m "base"
base_ref="$(git -C "$repo" rev-parse HEAD)"
printf 'change\n' >> "${repo}/fixture.txt"
mkdir -p "${repo}/nested-repository"
git -C "${repo}/nested-repository" init -q
git -C "${repo}/nested-repository" config user.name "Nested Review Test"
git -C "${repo}/nested-repository" config user.email "nested-review-test@example.invalid"
printf 'nested\n' > "${repo}/nested-repository/fixture.txt"
git -C "${repo}/nested-repository" add fixture.txt
git -C "${repo}/nested-repository" commit -q -m "nested base"
ln -s nested-repository "${repo}/nested-repository-link"
mkdir -p "${repo}/commitless-repository"
git -C "${repo}/commitless-repository" init -q
printf 'commitless content\n' > "${repo}/commitless-repository/fixture.txt"
git -C "${repo}/commitless-repository" add fixture.txt

export PATH="${fake_bin}:/usr/bin:/bin"
export XDG_CACHE_HOME="${test_root}/cache"
export CLAUDE_REVIEW_COOLDOWN_SECONDS=0
export FAKE_CLAUDE_CALLS="${test_root}/claude-calls"
repo_key="$(printf '%s' "$repo" | sha256sum | cut -d' ' -f1)"

failures=0

fail() {
  printf 'not ok - %s\n' "$1"
  failures=$((failures + 1))
}

pass() {
  printf 'ok - %s\n' "$1"
}

assert_status() {
  local expected="$1" actual="$2" name="$3"
  if [[ "$actual" == "$expected" ]]; then
    pass "$name"
  else
    fail "$name (expected status ${expected}, got ${actual})"
  fi
}

run_review() {
  local name="$1"
  shift
  set +e
  (
    cd "$repo"
    "$review_script" "$@" "$base_ref" "$name"
  ) > "${test_root}/${name}.out" 2> "${test_root}/${name}.err"
  review_status=$?
  set -e
}

export FAKE_CLAUDE_MODE=success
run_review success
assert_status 0 "$review_status" "valid Claude review succeeds"
if ! grep -q 'Is a directory' "${test_root}/success.err"; then
  pass "untracked nested repository and directory symlink fingerprint safely"
else
  fail "untracked nested repository and directory symlink fingerprint safely"
fi
if grep -q '^fatal:' "${test_root}/success.err"; then
  fail "commitless repository fingerprint emits no fatal diagnostics"
else
  pass "commitless repository fingerprint emits no fatal diagnostics"
fi
grep -q '^VERDICT: SHIP$' "${test_root}/success.out" &&
  pass "valid Claude verdict is emitted" ||
  fail "valid Claude verdict is emitted"
jq -e 'select(.reviewer == "claude" and .reason == "success" and .timeout_seconds == 600 and .turns == 1 and .output_bytes > 0)' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "success telemetry records progress metadata" ||
  fail "success telemetry records progress metadata"
success_fingerprint="$(jq -r 'select(.reviewer == "claude" and .reason == "success") | .fingerprint' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" | tail -n 1)"
success_cache="${XDG_CACHE_HOME}/codex/claude-adversarial-review/${repo_key}/${success_fingerprint}.txt"
if grep -q '^REVIEWER: claude$' "$success_cache" &&
  [[ ! -e "${success_cache%.txt}.reviewer" ]]; then
  pass "cache publishes verdict and reviewer identity atomically"
else
  fail "cache publishes verdict and reviewer identity atomically"
fi

export FAKE_CLAUDE_MODE=malformed-stream
run_review malformed-stream
assert_status 0 "$review_status" "non-JSON stdout does not destroy a valid review"
if grep -q 'parse error' "${test_root}/malformed-stream.err"; then
  fail "malformed stream is ignored defensively"
else
  pass "malformed stream is ignored defensively"
fi

export FAKE_CLAUDE_MODE=nonobject-stream
run_review nonobject-stream
assert_status 0 "$review_status" "valid non-object JSON lines do not destroy a review"

export FAKE_CLAUDE_MODE=trailing-verdict
run_review trailing-verdict
assert_status 0 "$review_status" "verdict with trailing prose remains valid"

export FAKE_CLAUDE_MODE=template-echo
run_review template-echo --no-fallback
assert_status 65 "$review_status" "prompt template echo cannot clear the gate"

export FAKE_CLAUDE_MODE=error-result
run_review error-result
assert_status 0 "$review_status" "errored Claude result uses standard fallback"
jq -e 'select(.reviewer == "claude" and .reason == "invalid_output" and .exit_status == 65)' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "errored result event cannot clear the Claude gate" ||
  fail "errored result event cannot clear the Claude gate"

before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=failure
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
assert_status 0 "$review_status" "valid cached review succeeds"
if [[ "$before_calls" == "$after_calls" ]] && grep -q 'REVIEW CACHE HIT' "${test_root}/success.err"; then
  pass "valid cached review skips Claude"
else
  fail "valid cached review skips Claude"
fi

before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=success
run_review success --force
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
if [[ "$after_calls" -eq $((before_calls + 1)) ]]; then
  pass "--force bypasses a valid cache entry"
else
  fail "--force bypasses a valid cache entry"
fi

git -C "${repo}/nested-repository" status --short >/dev/null
git -C "${repo}/commitless-repository" status --short >/dev/null
before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=failure
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
if [[ "$before_calls" == "$after_calls" ]] && grep -q 'REVIEW CACHE HIT' "${test_root}/success.err"; then
  pass "nested repository metadata does not invalidate the cache"
else
  fail "nested repository metadata does not invalidate the cache"
fi

printf 'nested change\n' >> "${repo}/nested-repository/fixture.txt"
git -C "${repo}/nested-repository" add fixture.txt
git -C "${repo}/nested-repository" commit -q -m "nested change"
before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=success
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
if [[ "$after_calls" -eq $((before_calls + 1)) ]]; then
  pass "nested repository HEAD change invalidates the cache"
else
  fail "nested repository HEAD change invalidates the cache"
fi

printf 'dirty tracked change\n' >> "${repo}/nested-repository/fixture.txt"
before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=success
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
if [[ "$after_calls" -eq $((before_calls + 1)) ]]; then
  pass "nested repository tracked worktree change invalidates the cache"
else
  fail "nested repository tracked worktree change invalidates the cache"
fi

printf 'new nested file\n' > "${repo}/nested-repository/new-file.txt"
before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=success
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
if [[ "$after_calls" -eq $((before_calls + 1)) ]]; then
  pass "nested repository untracked file invalidates the cache"
else
  fail "nested repository untracked file invalidates the cache"
fi

printf 'commitless worktree change\n' >> "${repo}/commitless-repository/fixture.txt"
before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=success
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
if [[ "$after_calls" -eq $((before_calls + 1)) ]]; then
  pass "commitless repository worktree change invalidates the cache"
else
  fail "commitless repository worktree change invalidates the cache"
fi

success_fingerprint="$(jq -r 'select(.reviewer == "claude" and .reason == "success") | .fingerprint' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" | tail -n 1)"
success_cache="${XDG_CACHE_HOME}/codex/claude-adversarial-review/${repo_key}/${success_fingerprint}.txt"

repo_cache_dir="${XDG_CACHE_HOME}/codex/claude-adversarial-review/${repo_key}"
chmod 500 "$repo_cache_dir"
export FAKE_CLAUDE_MODE=success
run_review cache-write-failure
assert_status 0 "$review_status" "cache write failure does not overturn a valid review"
chmod 700 "$repo_cache_dir"
if grep -q '^VERDICT: SHIP$' "${test_root}/cache-write-failure.out" &&
  grep -q 'verdict could not be cached' "${test_root}/cache-write-failure.err"; then
  pass "cache write failure preserves verdict and emits warning"
else
  fail "cache write failure preserves verdict and emits warning"
fi
jq -e 'select(.reviewer == "claude" and .cache == "write_failed" and .reason == "success")' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "cache write failure is visible in telemetry" ||
  fail "cache write failure is visible in telemetry"

printf 'invalid cache\n' > "$success_cache"
before_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
export FAKE_CLAUDE_MODE=failure
run_review success
after_calls="$(wc -l < "$FAKE_CLAUDE_CALLS")"
assert_status 1 "$review_status" "invalid cached review is not trusted"
if [[ "$after_calls" -eq $((before_calls + 1)) ]]; then
  pass "invalid cached review invokes Claude"
else
  fail "invalid cached review invokes Claude"
fi

export FAKE_CLAUDE_MODE=empty
run_review empty
assert_status 0 "$review_status" "empty Claude result uses standard fallback"
grep -q '^REVIEWER: codex-auto-review' "${test_root}/empty.out" &&
  pass "fallback reviewer identity is emitted" ||
  fail "fallback reviewer identity is emitted"
jq -e 'select(.reviewer == "claude" and .reason == "invalid_output" and .exit_status == 65)' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "empty Claude result is recorded as invalid" ||
  fail "empty Claude result is recorded as invalid"
grep -q 'substantial partial evidence from empty result' "${test_root}/empty.err" &&
  pass "empty result preserves assistant evidence as unvalidated" ||
  fail "empty result preserves assistant evidence as unvalidated"

export FAKE_CLAUDE_MODE=invalid
run_review invalid
assert_status 0 "$review_status" "malformed Claude contract uses standard fallback"
grep -q 'did not return a complete valid review contract' "${test_root}/invalid.err" &&
  pass "malformed contract is diagnosed explicitly" ||
  fail "malformed contract is diagnosed explicitly"
grep -q 'UNVALIDATED CLAUDE OUTPUT (NOT A VERDICT)' "${test_root}/invalid.err" &&
  pass "invalid Claude findings remain visible but untrusted" ||
  fail "invalid Claude findings remain visible but untrusted"

export FAKE_CLAUDE_MODE=invalid
run_review no-fallback --no-fallback
assert_status 65 "$review_status" "--no-fallback preserves invalid-output failure"
if [[ ! -s "${test_root}/no-fallback.out" ]] &&
  grep -q 'UNVALIDATED CLAUDE OUTPUT (NOT A VERDICT)' "${test_root}/no-fallback.err"; then
  pass "--no-fallback keeps unvalidated output off stdout"
else
  fail "--no-fallback keeps unvalidated output off stdout"
fi

export FAKE_CLAUDE_MODE=empty
export FAKE_CODEX_MODE=invalid
run_review invalid-fallback
assert_status 65 "$review_status" "malformed fallback contract cannot clear gate"
grep -q 'fallback did not return a complete valid review contract' "${test_root}/invalid-fallback.err" &&
  pass "malformed fallback is diagnosed explicitly" ||
  fail "malformed fallback is diagnosed explicitly"
unset FAKE_CODEX_MODE

export FAKE_CLAUDE_MODE=quota
run_review quota
assert_status 0 "$review_status" "quota failure uses standard fallback"
jq -e 'select(.reviewer == "claude" and .reason == "unavailable")' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "quota failure is classified as unavailable" ||
  fail "quota failure is classified as unavailable"

export FAKE_CLAUDE_MODE=quota-stdout
run_review quota-stdout
assert_status 0 "$review_status" "stdout quota event uses standard fallback"
jq -se '[.[] | select(.reviewer == "claude")] | last | .reason == "unavailable"' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "stdout quota event is classified as unavailable" ||
  fail "stdout quota event is classified as unavailable"

export FAKE_CLAUDE_MODE=timeout
export CLAUDE_REVIEW_TIMEOUT_SECONDS=1
run_review timeout --deep
assert_status 3 "$review_status" "deep timeout fallback leaves gate unresolved"
grep -q 'timed out after 1 seconds while still active' "${test_root}/timeout.err" &&
  pass "timeout is diagnosed explicitly" ||
  fail "timeout is diagnosed explicitly"
jq -e 'select(.reviewer == "claude" and .reason == "timeout" and .exit_status == 124 and .turns == 1)' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "timeout telemetry preserves completed turns" ||
  fail "timeout telemetry preserves completed turns"
grep -q 'partial review evidence' "${test_root}/timeout.err" &&
  pass "timeout preserves partial Claude evidence as unvalidated" ||
  fail "timeout preserves partial Claude evidence as unvalidated"
unset CLAUDE_REVIEW_TIMEOUT_SECONDS

export FAKE_CLAUDE_MODE=timeout-descendant
export CLAUDE_REVIEW_TIMEOUT_SECONDS=1
start_seconds="$SECONDS"
run_review timeout-descendant --no-fallback
elapsed_seconds=$((SECONDS - start_seconds))
assert_status 124 "$review_status" "timeout kills descendants holding the output pipe"
if (( elapsed_seconds < 4 )); then
  pass "descendant timeout bounds the full pipeline"
else
  fail "descendant timeout bounds the full pipeline"
fi
unset CLAUDE_REVIEW_TIMEOUT_SECONDS

export FAKE_CLAUDE_MODE=failure
run_review failure
assert_status 1 "$review_status" "unqualified Claude failure does not fallback"
grep -q 'does not qualify for automatic fallback' "${test_root}/failure.err" &&
  pass "unqualified failure keeps explicit diagnostic" ||
  fail "unqualified failure keeps explicit diagnostic"

export FAKE_CLAUDE_MODE=plain-failure-with-quota-prose
run_review plain-failure-with-quota-prose
assert_status 1 "$review_status" "ordinary stdout quota prose does not trigger fallback"

export FAKE_CLAUDE_MODE=success
run_review deep-default --deep
assert_status 0 "$review_status" "deep profile succeeds with fake reviewer"
jq -e 'select(.profile == "deep" and .reason == "success" and .timeout_seconds == 1800)' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "deep profile observes a thirty-minute default" ||
  fail "deep profile observes a thirty-minute default"

export CLAUDE_REVIEW_TIMEOUT_SECONDS=invalid
run_review invalid-timeout
assert_status 2 "$review_status" "invalid timeout configuration is rejected"
unset CLAUDE_REVIEW_TIMEOUT_SECONDS

export CLAUDE_REVIEW_COOLDOWN_SECONDS=invalid
run_review invalid-cooldown
assert_status 2 "$review_status" "invalid cooldown configuration is rejected"
export CLAUDE_REVIEW_COOLDOWN_SECONDS=0

export FAKE_CLAUDE_MODE=success
run_review cooldown-base --force
assert_status 0 "$review_status" "cooldown fixture review succeeds"
export CLAUDE_REVIEW_COOLDOWN_SECONDS=3600
run_review cooldown-changed
assert_status 75 "$review_status" "changed fingerprint is blocked during cooldown"
jq -e 'select(.reason == "cooldown" and .exit_status == 75)' \
  "${XDG_CACHE_HOME}/codex/claude-adversarial-review/telemetry.jsonl" >/dev/null &&
  pass "cooldown telemetry is recorded" ||
  fail "cooldown telemetry is recorded"

printf 'CORRUPT\n' > "${repo_cache_dir}/last-review"
export FAKE_CLAUDE_MODE=success
run_review corrupt-cooldown
assert_status 0 "$review_status" "malformed cooldown state is ignored safely"
if grep -q 'unbound variable' "${test_root}/corrupt-cooldown.err"; then
  fail "malformed cooldown state avoids Bash arithmetic errors"
else
  pass "malformed cooldown state avoids Bash arithmetic errors"
fi

if (( failures > 0 )); then
  printf '%s test(s) failed\n' "$failures" >&2
  exit 1
fi

printf 'all review wrapper tests passed\n'
