---
name: power-pages-diagnose-deployment
description: "Surfaces PAC CLI upload errors and Dataverse async operation errors, pattern-matches against a known failure catalog, and optionally auto-fixes identified issues. Use when asked to: \"diagnose deployment\", \"debug deployment\", \"deployment failed\", \"show deployment errors\", \"fix deployment issues\", \"show upload logs\", \"why did my deploy fail\", or \"troubleshoot upload\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/diagnose-deployment
---

# power-pages-diagnose-deployment

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/diagnose-deployment`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/diagnose-deployment/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/diagnose-deployment`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/diagnose-deployment`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/diagnose-deployment` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
