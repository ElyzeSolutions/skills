---
name: mobile-apps-add-sample-data
description: "Use when the user wants to seed Dataverse tables with realistic sample records so a freshly-scaffolded code app shows real-looking data on first launch. Generates contextually appropriate rows from each table's schema and inserts them in dependency order. Mirrors microsoft/power-platform-skills/power-pages/add-sample-data, adapted for mobile apps."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/add-sample-data
---

# mobile-apps-add-sample-data

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/add-sample-data`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-sample-data/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-sample-data`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-sample-data`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-sample-data` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
