---
name: power-pages-import-solution
description: "Imports a Dataverse solution zip into a target environment, with optional staged import for dependency checking before committing. Use when asked to: \"import solution\", \"install solution\", \"deploy solution zip\", \"push solution to environment\", \"deploy to staging\", \"deploy to production\", or \"install site in new environment\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/import-solution
---

# power-pages-import-solution

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/import-solution`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/import-solution/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/import-solution`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/import-solution`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/import-solution` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
