---
name: mobile-apps-preview-offline-scope
description: "Use when the user wants to estimate the download size + sync frequency cost of an offline profile BEFORE pushing to users. Read-only. Wraps verify-offline-profile.js with per-table row-count estimates."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/preview-offline-scope
---

# mobile-apps-preview-offline-scope

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/preview-offline-scope`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/preview-offline-scope/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/preview-offline-scope`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/preview-offline-scope`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/preview-offline-scope` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
