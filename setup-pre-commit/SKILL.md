---
name: setup-pre-commit
description: Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing.
---

# Setup Pre-Commit Hooks

## What This Sets Up

- **Husky** pre-commit hook
- **lint-staged** running Prettier on all staged files
- **Prettier** config (if missing)
- **typecheck** and **test** scripts in the pre-commit hook

## Steps

### 1. Detect package manager

Check for `package-lock.json` (npm), `pnpm-lock.yaml` (pnpm), `yarn.lock` (Yarn),
or `bun.lock`/`bun.lockb` (Bun). Use whichever is present. Default to npm if
unclear.

Use that package manager consistently:

| Manager | Add dev dependencies | Run a local binary | Run a script |
| --- | --- | --- | --- |
| npm | `npm install --save-dev` | `npx` | `npm run` |
| pnpm | `pnpm add --save-dev` | `pnpm exec` | `pnpm run` |
| Yarn | `yarn add --dev` | `yarn` | `yarn` |
| Bun | `bun add --dev` | `bunx` | `bun run` |

In the commands below, replace `<exec>` and `<run>` with the detected row. Do
not fall back to `npx` in a pnpm, Yarn, or Bun repository.

### 2. Install dependencies

Install as devDependencies:

```
husky lint-staged prettier
```

### 3. Initialize Husky

```bash
<exec> husky init
```

This creates `.husky/` dir and adds `prepare: "husky"` to package.json.

### 4. Create `.husky/pre-commit`

Write this file (no shebang needed for Husky v9+):

```
<exec> lint-staged
<run> typecheck
<run> test
```

If the repo has no `typecheck` or `test` script in `package.json`, omit those
lines and tell the user.

### 5. Create `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. Create `.prettierrc` (if missing)

Only create if no Prettier config exists. Use these defaults:

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. Verify

- [ ] `.husky/pre-commit` exists and is executable
- [ ] `.lintstagedrc` exists
- [ ] `prepare` script in package.json is `"husky"`
- [ ] `prettier` config exists
- [ ] Run `<exec> lint-staged` to verify it works

### 8. Commit when requested

If the user requested a commit, stage only the hook/configuration files created
or changed by this task and commit them with a concise message such as
`chore: add pre-commit hooks`. Preserve unrelated worktree changes.

The commit will run through the new hook as an additional smoke test. Without
commit authority, stop after the explicit verification in step 7 and report the
uncommitted files.

## Notes

- Husky v9+ doesn't need shebangs in hook files
- `prettier --ignore-unknown` skips files Prettier can't parse (images, etc.)
- The pre-commit runs lint-staged first (fast, staged-only), then full typecheck and tests
