---
name: code-apps-create-code-app
description: "Creates Power Apps code apps using React and Vite. Use when building code apps, scaffolding projects, or deploying to Power Platform."
source: microsoft/power-platform-skills/plugins/code-apps/skills/create-code-app
---

# code-apps-create-code-app

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `code-apps/create-code-app`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/create-code-app/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/create-code-app`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/create-code-app`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/create-code-app` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
