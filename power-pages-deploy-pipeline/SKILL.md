---
name: power-pages-deploy-pipeline
description: "Triggers a Power Platform Pipeline deployment run for a Power Pages solution. Selects a target stage, validates the package, optionally configures deployment settings (environment variables, connection references), then deploys and polls for completion. Use when asked to: \"deploy pipeline\", \"run pipeline\", \"trigger deployment\", \"deploy to staging\", \"deploy to production\", \"run power platform pipeline\", \"deploy solution via pipeline\", \"promote solution\", \"push to staging\", \"push to production\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/deploy-pipeline
---

# power-pages-deploy-pipeline

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/deploy-pipeline`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/deploy-pipeline/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/deploy-pipeline`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/deploy-pipeline`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/deploy-pipeline` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
