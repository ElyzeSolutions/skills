---
name: power-pages-force-link-environment
description: "Force-links a development or target environment to a Power Platform Pipelines host, overriding any existing association with a previous host. Use when creating a deploymentenvironments record fails with \"this environment is already associated with another pipelines host\", or when intentionally migrating an environment from one host to another (e.g., Platform Host → Custom Host, or between two Custom Hosts). Calls the documented `ManageEnvironmentStamp` Dataverse action (the API behind the \"Force Link\" button in the Deployment Pipeline Configuration app). DESTRUCTIVE to the previous host: makers lose access to any pipelines in that host that used this environment. Reversible by running Force Link from the previous host. Use when asked to: \"force link environment\", \"force-link to new host\", \"switch pipelines host\", \"environment already associated with another host\", \"take over pipelines association\", \"relink environment to host\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/force-link-environment
---

# power-pages-force-link-environment

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/force-link-environment`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/force-link-environment/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/force-link-environment`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/force-link-environment`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/force-link-environment` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
