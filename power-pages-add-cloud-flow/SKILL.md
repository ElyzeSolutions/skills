---
name: power-pages-add-cloud-flow
description: "Integrates Power Automate cloud flows into a Power Pages site. Lists available flows, suggests relevant ones based on intent, identifies scenarios and web roles, creates metadata files, and generates client-side code to call flows. Handles both new flow registration and adding already-registered flows to additional pages without re-creating metadata. Use when the user wants to add, connect, register, or link a Power Automate cloud flow to their site."
source: microsoft/power-platform-skills/plugins/power-pages/skills/add-cloud-flow
---

# power-pages-add-cloud-flow

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/add-cloud-flow`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-cloud-flow/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-cloud-flow`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-cloud-flow`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-cloud-flow` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
