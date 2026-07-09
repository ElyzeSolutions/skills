---
name: power-pages-setup-auth
description: "Use when the user asks to \"set up authentication\", \"add login\", \"add logout\", \"add sign in\", \"enable auth\", \"add role-based access\", \"add authorization\", \"protect routes\", \"configure identity provider\", \"configure Entra ID\", \"configure Entra External ID\", \"configure OpenID Connect\", \"add OIDC\", \"set up SAML\", \"set up WS-Federation\", \"set up local login\", \"add username password\", \"add Facebook login\", \"add Google sign in\", \"add Microsoft Account\", \"set up invitation login\", or otherwise wants to set up authentication (login/logout) and role-based authorization for their Power Pages code site using any supported identity provider (Microsoft Entra ID, Entra External ID, OpenID Connect, SAML2, WS-Federation, local authentication, Microsoft Account, Facebook, or Google)."
source: microsoft/power-platform-skills/plugins/power-pages/skills/setup-auth
---

# power-pages-setup-auth

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/setup-auth`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-auth/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-auth`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-auth`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/setup-auth` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
