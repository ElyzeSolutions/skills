---
name: code-apps-add-mcscopilot
description: "Adds Microsoft Copilot Studio connector to a Power Apps code app. Use when invoking Copilot Studio agents, sending prompts to agents, or integrating agent responses."
source: microsoft/power-platform-skills/plugins/code-apps/skills/add-mcscopilot
---

# code-apps-add-mcscopilot

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `code-apps/add-mcscopilot`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-mcscopilot/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-mcscopilot`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-mcscopilot`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/code-apps/skills/add-mcscopilot` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
