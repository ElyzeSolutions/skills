---
name: canvas-apps-canvas-app
description: "Creates or edits a Power Apps Canvas App through the Canvas Authoring MCP coauthoring session. Handles new app generation from requirements, simple inline edits, and complex multi-screen changes with parallel screen builders. Triggers on requests to create, build, generate, modify, update, change, or edit a Canvas App or .pa.yaml files."
source: microsoft/power-platform-skills/plugins/canvas-apps/skills/canvas-app
---

# canvas-apps-canvas-app

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `canvas-apps/canvas-app`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/canvas-app/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/canvas-app`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/canvas-app`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/canvas-apps/skills/canvas-app` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
