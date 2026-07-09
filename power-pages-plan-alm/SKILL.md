---
name: power-pages-plan-alm
description: "Creates an ALM (Application Lifecycle Management) plan for deploying a Power Pages site across environments. Gathers your promotion strategy, target environments, and approval requirements upfront, then generates a visual HTML plan document for your review and approval. **plan-alm does not deploy anything itself** — it is a planner. After you approve the plan, run the individual ALM skills (setup-solution, setup-pipeline, deploy-pipeline, or export-solution/import-solution); each detects the approved plan and executes the right step in order, keeping the plan updated as it runs. Use when asked to: \"plan my alm\", \"set up alm\", \"create deployment plan\", \"plan my deployments\", \"help me deploy to multiple environments\", \"set up promotion strategy\", \"create cicd plan\", \"plan site promotion\", \"help me go to production\", \"set up pipeline for my site\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/plan-alm
---

# power-pages-plan-alm

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/plan-alm`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/plan-alm/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/plan-alm`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/plan-alm`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/plan-alm` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
