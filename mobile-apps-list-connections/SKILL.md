---
name: mobile-apps-list-connections
description: "Use when the user asks to find, create, or look up a Power Platform connection ID or connection reference for the current environment."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/list-connections
---

# mobile-apps-list-connections

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/list-connections`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/list-connections/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/list-connections`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/list-connections`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/list-connections` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
