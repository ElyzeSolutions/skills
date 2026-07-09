---
name: power-pages-export-solution
description: "Exports a Dataverse solution containing Power Pages site components as a zip file, ready for deployment to another environment. Use when asked to: \"export solution\", \"download solution\", \"export managed\", \"export unmanaged\", \"package for deployment\", \"create solution zip\", \"export site package\", or \"build deployment artifact\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/export-solution
---

# power-pages-export-solution

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/export-solution`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/export-solution/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/export-solution`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/export-solution`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/export-solution` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
