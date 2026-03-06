# Pass Evidence Policy

Use this policy when setting `passes` in `.agents/PLAN.md`.

## Set `passes: true` only when all apply

1. Implementation exists in repository.
2. Relevant verification command(s) succeeded.
3. Behavior matches task criteria (example and negative case).

## Keep `passes: false` when any apply

1. Task is planned but not implemented.
2. Implementation exists but tests/verification are missing.
3. Verification failed or only partially passed.

## Evidence format

When finishing a wave, summarize evidence in commit notes or delivery log:

- command
- result
- scope

Example:
- `pnpm exec vitest ... gateway.test.ts` -> pass -> validates session runtime switch behavior
