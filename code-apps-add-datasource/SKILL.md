---
name: code-apps-add-datasource
description: "Adds a data source or connector to a Power Apps code app. Asks what the user wants to accomplish and routes to the appropriate specialized skill."
source: microsoft/power-platform-skills/plugins/code-apps/skills/add-datasource
---

# code-apps-add-datasource

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `code-apps/add-datasource`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-datasource/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-datasource`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-datasource`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-datasource` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
