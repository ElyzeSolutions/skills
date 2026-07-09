---
name: canvas-apps-add-data-source
description: "Guide the user to add a data source, connection, or API connector to a Canvas App via Power Apps Studio, then verify and continue. USE WHEN the user asks to add a data source, add a connection, add an API, add a connector, connect to SharePoint / Dataverse / SQL / Excel / OneDrive / Teams / Office 365, or any similar request to make new data available to the app. DO NOT USE WHEN the user is asking to list or describe existing data sources — call list_data_sources or list_apis directly instead."
source: microsoft/power-platform-skills/plugins/canvas-apps/skills/add-data-source
---

# canvas-apps-add-data-source

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `canvas-apps/add-data-source`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/add-data-source/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/add-data-source`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/add-data-source`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/add-data-source` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
