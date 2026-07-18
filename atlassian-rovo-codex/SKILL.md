---
name: atlassian-rovo-codex
description: Configure and troubleshoot Atlassian Rovo MCP access for Codex CLI/IDE using OAuth with Jira and Confluence. Use when asked to set up Atlassian MCP, run OAuth login, verify Jira/Confluence access, diagnose Atlassian admin/domain/IP errors, or migrate away from legacy mcp-remote /sse guidance.
---

# Atlassian Rovo MCP for Codex

Set up Atlassian Rovo MCP in Codex with OAuth and keep Jira/Confluence access reliable.

## Quick Start

1. Confirm the CLI supports remote MCP URLs:
```bash
codex --version
codex mcp add --help
```
2. Add Atlassian Rovo MCP:
```bash
codex mcp add atlassian --url https://mcp.atlassian.com/v1/mcp
```
3. Start OAuth login:
```bash
codex mcp login atlassian
```
4. Verify connection:
```bash
codex mcp list
codex mcp list --json
```
Expect `Auth` to be `OAuth` and JSON `auth_status` to be `o_auth`.

## Workflow

### 1. Configure

Use the official Atlassian endpoint `https://mcp.atlassian.com/v1/mcp`.
Do not default to legacy `/sse` guidance unless the environment is explicitly constrained.

### 2. Authenticate

Prefer OAuth.
Only use API token auth when organization policy requires it.
If using API token, set `bearer_token_env_var` and avoid plaintext tokens in config files.

### 3. Validate

Run:
```bash
codex mcp get atlassian --json
codex mcp list --json
```
Then perform a real prompt in Codex that touches Jira and Confluence, for example:
- "Search Jira for my open issues."
- "Find Confluence pages in the SPACE key `<SPACE>` about onboarding."

### 4. Troubleshoot

Read `references/troubleshooting.md` for exact error-to-fix mapping:
- Site admin authorization errors
- Organization domain allowlist errors
- IP allowlist errors
- OAuth/login status issues in Codex

### 5. Compare Implementations Before Changing Stack

Read `references/comparison.md` before recommending alternate implementations.
Use it to avoid mixing Atlassian Rovo MCP setup with unrelated community servers.

## Security Rules

- Treat OAuth callback URLs and authorization codes as secrets.
- Avoid pasting callback URLs in shared channels.
- If leaked, revoke and re-authenticate.
