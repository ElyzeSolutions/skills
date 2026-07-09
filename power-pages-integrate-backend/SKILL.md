---
name: power-pages-integrate-backend
description: "Analyzes the user's business problem and recommends the right backend integration approach — Web API, AI Web API (generative summaries / grounded search), Server Logic, Cloud Flows, or a combination — for a Power Pages site, then routes to the appropriate specialized skill. Use when the user wants to add backend integration, connect to data, add AI summaries, or needs help deciding which backend approach to use."
source: microsoft/power-platform-skills/plugins/power-pages/skills/integrate-backend
---

# power-pages-integrate-backend

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/integrate-backend`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-backend/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-backend`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-backend`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/integrate-backend` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
