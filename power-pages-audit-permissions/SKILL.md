---
name: power-pages-audit-permissions
description: "Audits existing table permissions on a Power Pages site by analyzing them against site code and Dataverse metadata. Generates an HTML audit report with findings grouped by severity (critical, warning, info, pass) and suggests fixes for issues found. Use when the user wants to review, verify, or check table permissions for security issues."
source: microsoft/power-platform-skills/plugins/power-pages/skills/audit-permissions
---

# power-pages-audit-permissions

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/audit-permissions`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/audit-permissions/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/audit-permissions`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/audit-permissions`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/audit-permissions` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
