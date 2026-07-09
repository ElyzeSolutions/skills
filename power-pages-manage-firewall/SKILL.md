---
name: power-pages-manage-firewall
description: "Inspects and configures the web application firewall (WAF) in front of a Power Pages production site. Lists the current state, recommends enabling protection when it is off, and walks the user through adding, updating, or removing custom rules — IP blocks, country blocks, path blocks, and rate limits. Use when the user wants to turn on WAF, block traffic by IP or country, rate-limit login or signup pages, protect pages from brute-force attempts, restrict access to specific paths, review the current firewall configuration, or asks \"is my site protected against bots / common web attacks?\" — even if they say \"add rate limit\" or \"protect login page\" without mentioning \"firewall\" or \"WAF\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/manage-firewall
---

# power-pages-manage-firewall

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/manage-firewall`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-firewall/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-firewall`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-firewall`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-firewall` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
