---
name: mobile-apps-design-system
description: "Creates and manages the brand design system for a Power Apps mobile app. Generates brand/design-system.md (source of truth), brand/tokens.ts (importable Tamagui tokens), and brand/design-system.html (visual gallery). Triggered at Step 6.5 of /create-mobile-app, or standalone via /design-system."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/design-system
---

# mobile-apps-design-system

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/design-system`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/design-system/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/design-system`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/design-system`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/design-system` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
