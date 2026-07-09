---
name: power-pages-manage-headers
description: "Inspects and configures the security headers a Power Pages site sends to browsers — Content Security Policy, frame and clickjacking protection, cross-origin sharing, cookie behavior, and related site settings. Identifies gaps and walks the user through fixes. Use when the user wants to review headers, fix CSP errors, allow embedding in another site, control cross-origin access, harden cookie settings, or asks \"are my browser settings safe?\", \"fix my CSP\", \"set up CORS\" — even if they only mention a specific header name without saying \"security headers\"."
source: microsoft/power-platform-skills/plugins/power-pages/skills/manage-headers
---

# power-pages-manage-headers

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/manage-headers`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-headers/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-headers`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-headers`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/manage-headers` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
