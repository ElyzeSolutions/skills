---
name: power-pages-configure-env-variables
description: "Configures environment variables for Power Pages site settings to support ALM across environments. Creates environment variable definitions in Dataverse, guides the user through linking site settings to those variables via the Power Pages Management app, adds the variables to the solution, and generates a deployment-settings.json file with per-stage override values. Use when asked to: \"configure environment variables\", \"add env vars\", \"set up deployment variables\", \"make site settings environment-specific\", \"configure ALM variables\", \"set up env-specific settings\", \"add deployment settings\", \"configure per-environment settings\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/configure-env-variables
---

# power-pages-configure-env-variables

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/configure-env-variables`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/configure-env-variables/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/configure-env-variables`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/configure-env-variables`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/configure-env-variables` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
