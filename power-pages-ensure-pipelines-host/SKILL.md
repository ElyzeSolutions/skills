---
name: power-pages-ensure-pipelines-host
description: "Ensures the tenant has a usable Power Platform Pipelines host environment before any pipeline operation runs. Detects host state via the same resolution order as the Power Apps UI (org-db setting → BAP env metadata → default-custom-host setting); if any existing host (Platform or Custom) is found, uses it. If no host is bound to the source env, provisions a new **Platform Host** (recommended, idempotent) or a **Custom Host** via the BAP env-create API with the `D365_ProjectHost` template, or guides the user through PPAC install / `New custom host` (manual fallbacks). Polls lifecycle operations, verifies the host responds to Pipelines API calls, writes a host-check artifact other ALM skills consume. Use when asked to: \"set up pipelines host\", \"ensure pipelines host\", \"no pipelines host\", \"install pipelines\", \"create pipelines host\", \"provision platform host\", \"provision custom host\". Also invoked transparently by /power-pages:setup-pipeline when its host discovery step finds nothing."
source: microsoft/power-platform-skills/plugins/power-pages/skills/ensure-pipelines-host
---

# power-pages-ensure-pipelines-host

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/ensure-pipelines-host`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/ensure-pipelines-host/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/ensure-pipelines-host`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/ensure-pipelines-host`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/ensure-pipelines-host` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
