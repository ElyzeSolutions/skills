---
name: mcp-apps-generate-mcp-app-ui
description: "Generate an MCP App widget (self-contained HTML) for an MCP tool. Describe the visual you want and paste your tool's test output. Use when user asks to create an MCP App, widget, or visual for a tool."
source: microsoft/power-platform-skills/plugins/mcp-apps/skills/generate-mcp-app-ui
---

# mcp-apps-generate-mcp-app-ui

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mcp-apps/generate-mcp-app-ui`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mcp-apps/skills/generate-mcp-app-ui/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mcp-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mcp-apps/skills/generate-mcp-app-ui`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mcp-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mcp-apps/skills/generate-mcp-app-ui`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mcp-apps/skills/generate-mcp-app-ui` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
