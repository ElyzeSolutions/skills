---
name: mobile-apps-debug-app
description: "Use when the user has finished building a mobile app, started it with `npm run dev`, and wants the running app monitored for runtime errors AND silent failures (empty lists, blank screens, swallowed network errors) and fixed autonomously. Accepts a free-text symptom (e.g., `/debug-app \"todos not appearing on home screen\"`) to drive terminal-log diagnostics — injects temporary console.log statements at data-path boundaries, reads Metro terminal output, and cleans up logs after the root cause is fixed. Otherwise polls the Metro terminal every 5s, classifies errors using an 8-category table, fixes inline or routes to the right skill, verifies each fix from terminal output, and exits after 3 consecutive clean polls. Foreground loop — blocks the conversation while running. Run only after the app is loaded."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/debug-app
---

# mobile-apps-debug-app

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/debug-app`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/debug-app/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/debug-app`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/debug-app`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/debug-app` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
