---
name: power-pages-security-review
description: "Runs a guided, end-to-end security review of a Power Pages site and consolidates every finding into one HTML report covering the live site, browser headers, firewall, authentication, and role-based permissions. Use when the user wants a full security review, a release-readiness check before publishing, an access-and-config check during development, live site monitoring, or asks open-ended questions like \"review my site security\", \"is my site safe to ship\", \"do a security check\", \"monitor my site\" — even if they do not name the individual checks."
source: microsoft/power-platform-skills/plugins/power-pages/skills/security-review
---

# power-pages-security-review

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/security-review`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/security-review/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/security-review`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/security-review`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/security-review` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
