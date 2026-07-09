---
name: power-pages-setup-pipeline
description: "Sets up a Power Platform Pipeline for automated Power Pages deployments. Power Platform Pipelines is Microsoft's native CI/CD tool built into the Power Platform — no external infrastructure required. Use when asked to: \"set up ci/cd\", \"create pipeline\", \"setup pipeline\", \"set up power platform pipelines\", \"create power pipelines\", \"automate deployments\", \"set up automated deployment\", \"create deployment pipeline\", \"use power pipelines\". Also handles: \"set up github actions\" or \"set up azure devops pipeline\" (shows coming-soon guidance for those platforms)."
source: microsoft/power-platform-skills/plugins/power-pages/skills/setup-pipeline
---

# power-pages-setup-pipeline

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/setup-pipeline`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-pipeline/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-pipeline`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-pipeline`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-pipeline` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
