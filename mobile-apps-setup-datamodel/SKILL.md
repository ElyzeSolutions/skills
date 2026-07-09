---
name: mobile-apps-setup-datamodel
description: "Use when the user wants to design or redesign the Dataverse schema and connector plan for an existing mobile app, or has an ER diagram (image, Mermaid, or text) to apply. Skip when the user is creating a brand-new app — /create-mobile-app handles the data model inline."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/setup-datamodel
---

# mobile-apps-setup-datamodel

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/setup-datamodel`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/setup-datamodel/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/setup-datamodel`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/setup-datamodel`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/setup-datamodel` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
