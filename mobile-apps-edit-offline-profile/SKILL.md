---
name: mobile-apps-edit-offline-profile
description: "Use when the user wants to change ONE aspect of an existing offline profile (row scope for a table, column list, sync frequency) without re-running the full /setup-offline-profile wizard. Mirrors the /edit-app gated edit pattern."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/edit-offline-profile
---

# mobile-apps-edit-offline-profile

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/edit-offline-profile`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/edit-offline-profile/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/edit-offline-profile`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/edit-offline-profile`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/edit-offline-profile` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
