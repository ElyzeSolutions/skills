---
name: power-pages-add-ai-webapi
description: "Integrates Power Pages generative-AI summarization APIs (PREVIEW) into a Single Page Application (SPA) site — the Search Summary API and the Data Summarization API — on any record-detail or list page. Generates per-target service code (CSRF-handled) and AI site settings; delegates Web API settings, table permissions, and web roles to `/integrate-webapi` and `/create-webroles`. Use whenever a user wants AI/Copilot output that condenses Dataverse content on a Power Pages site — an AI summary, AI-generated overview or \"key insights\" across a record or list, a search-results summary, a case/incident summary, or recommendation-chip refinement — even when phrased as \"AI-generated paragraph\", \"insights\", or \"overview\". Do NOT use for: generative pages in model-driven apps (use the model-apps `genpage` skill), Copilot Studio agents/chatbots, summarizing documents or PDFs, Power BI dashboards, plain keyword search with no AI summary, or plain Dataverse CRUD (use `/integrate-webapi`)."
source: microsoft/power-platform-skills/plugins/power-pages/skills/add-ai-webapi
---

# power-pages-add-ai-webapi

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `power-pages/add-ai-webapi`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-ai-webapi/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-ai-webapi`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-ai-webapi`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/power-pages/skills/add-ai-webapi` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
