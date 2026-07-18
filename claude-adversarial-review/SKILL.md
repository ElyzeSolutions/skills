---
name: claude-adversarial-review
description: Run one final, read-only adversarial review after implementation and validation, immediately before a commit, push, PR update, release, or final handoff of medium/high-risk code. Also use when the user explicitly asks Claude to challenge Codex's work, tests, assumptions, security, reliability, or architecture. Do not use for intermediate slices, read-only analysis, documentation, formatting, or small mechanical low-risk changes.
---

# Claude Adversarial Review

Use Claude as an independent critic at the final delivery boundary. Never let it
edit files or delegate back to Codex. Avoid repeated reviews of the same work.

## Risk profiles

- `--fast`: Sonnet at low effort for a user-requested review of a small,
  low-risk change. Low-risk work does not otherwise require external review.
- Default: Sonnet at medium effort for normal production changes.
- `--deep`: Opus at high effort for auth, payments, migrations, concurrency,
  security, data-loss, destructive behavior, or comparable high-risk work.
- `--frontier`: Fable at high effort only for exceptional cross-system
  architecture, the most consequential release gates, or an explicit request.

## Workflow

1. Finish the complete requested implementation and run its normal validation.
2. Choose the comparison base, normally `origin/main`.
3. Select the risk profile and run once immediately before shipping or final
   handoff:

   ```bash
   "$HOME/.agents/skills/claude-adversarial-review/scripts/review.sh" origin/main "<focus>"
   ```

   For high-risk work:

   ```bash
   "$HOME/.agents/skills/claude-adversarial-review/scripts/review.sh" --deep origin/main "<focus>"
   ```

4. Check every reported finding against the live source. Claude's output is review
   evidence, not ground truth.
5. Fix only confirmed findings and rerun relevant validation. Rerun the reviewer
   only after a confirmed P0/P1 fix or a material change to the reviewed interface
   or risk. Use `--force` when that justified rerun falls inside the cooldown.
6. Report confirmed findings, rejected findings, validation, reviewer identity,
   independence status, and the final verdict.

## Review rules

- Run Claude with bypass permissions to avoid non-interactive approval stalls, but
  expose only read/search/Bash tools, keep safe mode enabled, and explicitly prohibit
  mutations in the review prompt. The user has granted standing permission for this
  reciprocal Codex-to-Claude review path.
- Use a fresh non-persistent session so implementation context does not anchor the
  reviewer.
- Default to Sonnet at medium effort. Escalate by risk rather than task size or
  habit. Override with `CLAUDE_REVIEW_MODEL` or `CLAUDE_REVIEW_EFFORT` only for a
  deliberate exception.
- Profile timeouts are five minutes for `--fast`, ten minutes by default, and
  fifteen minutes for `--deep` and `--frontier`. Override with
  `CLAUDE_REVIEW_TIMEOUT_SECONDS` only when deliberately justified.
- Review the final merge-base diff, staged and unstaged changes, and relevant
  untracked files. Prioritize the changed paths supplied by the wrapper; inspect
  nearby code only when needed to establish a concrete failure mode.
- Require a Git repository and a meaningful comparison base. If the work lives
  outside Git or has no reviewable diff, do not invoke an unrelated repository
  or manufacture a review; report the limitation and use local validation.
- The wrapper fingerprints the base, final diff, untracked files, focus, and
  profile. Reuse a cached verdict for an unchanged fingerprint. It also enforces
  a per-repository cooldown to prevent rapid review loops; bypass it only with
  `--force` under the rerun rule above.
- If Claude is quota-limited or unavailable, the wrapper may run one ephemeral,
  read-only `codex-auto-review` fallback. This is a second-context review, not an
  independent-provider review. For `--deep` or `--frontier`, report degraded
  independence and do not treat the fallback as clearing the release gate.
- Set `CLAUDE_REVIEW_FALLBACK=0` to prohibit fallback. Set
  `CLAUDE_REVIEW_COOLDOWN_SECONDS` to tune the default 30-minute cooldown.
- Structured invocation telemetry is appended beneath
  `${XDG_CACHE_HOME:-$HOME/.cache}/codex/claude-adversarial-review/`; it contains
  timestamps, repository path, fingerprint, profile, reviewer, model, effort,
  duration, exit status, and cache state, but not prompts or source contents.
- Demand exact file and line evidence, a concrete failure mode, and severity.
- Treat tests as code under review. Challenge missing negative cases and tests that
  merely restate the implementation.
- Do not ask Claude to fix code in the review pass.
- Do not block delivery on speculative or unverified comments.

## Output contract

Require these sections:

- `VERDICT`: `SHIP`, `SHIP-WITH-FIXES`, or `FIX-FIRST`.
- `FINDINGS`: severity-ordered confirmed issues with file:line evidence, trigger,
  impact, and smallest safe fix direction.
- `TEST GAPS`: concrete missing or misleading coverage.
- `CHALLENGED ASSUMPTIONS`: hidden contract or operational assumptions.
- `CHECKED AND CLEAN`: important risk areas inspected without a finding.

If no issues are confirmed, Claude must say `FINDINGS: none`.

When the Codex fallback runs, it must use the same output contract and prepend
`REVIEWER: codex-auto-review (degraded provider independence)`.
