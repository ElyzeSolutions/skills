---
name: power-pages-telemetry
description: "Use this skill when the user wants to enable, disable, turn on or off, opt out of, opt in to, or check the status of power-pages telemetry / anonymous usage data. Triggers: \"disable telemetry\", \"turn off telemetry\", \"opt out of telemetry\", \"stop collecting usage data\", \"enable telemetry\", \"telemetry status\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/telemetry
---

# power-pages-telemetry

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/telemetry`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/telemetry/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/telemetry`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/telemetry`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/telemetry` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
