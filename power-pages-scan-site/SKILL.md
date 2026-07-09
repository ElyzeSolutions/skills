---
name: power-pages-scan-site
description: "Runs a security scan on a deployed Power Pages site, fetches the latest scan report, and produces a plain-language summary. Scans the live site's public surface for vulnerabilities and surfaces issues by severity. Use when the user wants to scan, check, test, audit, or assess a published site, find vulnerabilities on production, view the latest scan report, see previous scan results, run a security audit, or asks \"how safe is my live site?\", \"is my site vulnerable?\", \"audit my production site\" — even if they say \"find issues\" or \"check for problems\" without mentioning \"scan\" or \"security\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/scan-site
---

# power-pages-scan-site

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/scan-site`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/scan-site/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/scan-site`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/scan-site`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/scan-site` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
