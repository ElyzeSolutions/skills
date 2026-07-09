---
name: power-pages-integrate-webapi
description: "Integrates Power Pages Web API into a site's frontend code with proper permissions and deployment. Orchestrates the full integration lifecycle: code integration, table permissions setup, and deployment for Dataverse CRUD operations. Use when the user wants to add Web API calls, connect to Dataverse, or add data fetching to their frontend."
source: microsoft/power-platform-skills/plugins/power-pages/skills/integrate-webapi
---

# power-pages-integrate-webapi

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/integrate-webapi`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-webapi/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-webapi`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-webapi`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-webapi` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
