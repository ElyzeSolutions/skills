---
name: model-apps-report-issue
description: "Use this skill when the user wants to \"report a bug\", \"file an issue\", \"report an issue\", \"submit a bug report\", or report any problem with the model-apps plugin to the GitHub repository."
source: microsoft/power-platform-skills/plugins/model-apps/skills/report-issue
---

# model-apps-report-issue

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `model-apps/report-issue`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/model-apps/skills/report-issue/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/model-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/model-apps/skills/report-issue`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/model-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/model-apps/skills/report-issue`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/model-apps/skills/report-issue` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
