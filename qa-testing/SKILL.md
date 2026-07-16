---
name: qa-testing
description: Verify your work by actually operating the app or website you changed, instead of assuming it works. Strongly recommended whenever you build, modify, or debug a web app, website, or desktop GUI app. Drive real browsers with the agent-browser CLI and native desktop apps with the cua-driver CLI. These are installed on demand through the host's normal command-approval flow.
---

# QA testing - verify by actually driving it

After you build or change an app or website, do not assume it works. Drive it
and check.

## 1. Check what is already available

Local apps and already-installed tools do not require a network probe. Check for
the tool needed by the task first:

```bash
command -v agent-browser || true
command -v cua-driver || true
```

Only test network access when a missing tool must be installed or the target URL
is remote. Probe the actual download host or target URL, not GitHub as a proxy
for all networking. If access is blocked, report the exact host and let the user
enable network access through their current agent host; do not prescribe a
host-specific permissions command.

## 2. Web apps and websites - agent-browser

Install `agent-browser` only when it is missing. Use the normal package manager
instead of piping a remote script into a shell:

```bash
if ! command -v agent-browser >/dev/null; then
  npm install -g agent-browser
fi
agent-browser install
agent-browser skills get core
```

On Windows PowerShell:

```powershell
if (-not (Get-Command agent-browser -ErrorAction SilentlyContinue)) {
  npm install -g agent-browser
  $env:Path = "$env:APPDATA\npm;$env:Path"
}
agent-browser install
agent-browser skills get core
```

Then use the tool's maintained guide: `agent-browser open <url>`, take a
snapshot, act on the element refs, and snapshot again.

## 3. Native desktop apps - cua-driver

If `cua-driver` is not installed, use the host's normal approved tool-install
flow or the official cua-driver installation instructions. Do not execute an
unpinned remote script by piping it directly into a shell or PowerShell. Once
installed, run `cua-driver list-tools` and follow the maintained tool surface.

For native apps, verify a real state change after the action. A click command
that reports success is not enough by itself. Capture an initial state, act,
then capture a post-action state and compare visible text, counters, status
labels, selected state, input values, or screenshot evidence.

## Windows PowerShell command hygiene

Many Windows hosts still run Windows PowerShell 5.1, where `&&` is not a valid
statement separator. Use separate commands, semicolons, or explicit
`if ($LASTEXITCODE -eq 0) { ... }` checks instead. Quote tool arguments that
begin with `@`, especially agent-browser refs.

## Principles

- Use `command -v` before installing.
- Probe network only when installation or the target actually needs it.
- Never pipe an unpinned remote installer directly into a shell.
- Defer to each tool's own docs: `agent-browser skills get core` and
  `cua-driver list-tools`.
- Snapshot, act, and re-snapshot to confirm each step landed.
- Confirm before consequential actions such as purchases, messages, form
  submissions, or deletions.
