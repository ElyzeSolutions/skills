# Implementation Comparison

Use this file when choosing between official Atlassian Rovo MCP and community alternatives.

## Preferred default

Use Atlassian Rovo MCP directly:
```bash
codex mcp add atlassian --url https://mcp.atlassian.com/v1/mcp
codex mcp login atlassian
```

Why:
- Native OAuth flow
- Managed by Atlassian Cloud
- Jira and Confluence access aligned with existing user permissions

## What is outdated or mismatched

Legacy guidance still seen in posts:
- Codex supports only stdio MCP servers
- Must use `mcp-remote` with `/sse` for Atlassian

Treat this as version-dependent and often outdated for current Codex builds that support URL-based MCP configuration.

Atlassian now recommends `/mcp` over `/sse` where possible.

## Community server: `sooperset/mcp-atlassian`

Use when:
- You want a self-hosted MCP server
- You need custom operational control

Tradeoffs:
- Different architecture from Atlassian Rovo MCP
- Requires separate setup/hosting and credentials
- Commonly API-token based in quick starts

Do not conflate this with Atlassian Rovo MCP onboarding.

## Claude-oriented Confluence skills

Skills installed via `npx skills add ...` in your examples are optimized for Claude workflows.
They may reference Claude-specific MCP tool naming conventions and helper scripts that are not guaranteed to exist in Codex environments.

Reuse their domain guidance (templates, governance, macro usage), but adapt:
- MCP tool names
- command wrappers
- size-limit assumptions
- local script paths

## Decision guide

Choose Atlassian Rovo MCP when:
- Goal is fastest Jira/Confluence access in Codex via OAuth
- Admin policies permit Atlassian-managed MCP integration

Choose a self-hosted community server when:
- You require custom server behavior not offered by Atlassian Rovo MCP
- You accept the additional maintenance burden
