# Atlassian Rovo MCP Troubleshooting

Use this file when OAuth or permissions fail after adding:

```bash
codex mcp add atlassian --url https://mcp.atlassian.com/v1/mcp
```

## Core checks

Run:
```bash
codex mcp list
codex mcp list --json
codex mcp get atlassian --json
```

Interpretation:
- `Auth: OAuth` and `auth_status: "o_auth"` means login is active.
- `Auth: Unsupported` means login has not been completed for this server entry.

## Error map

`Your site admin must authorize this app`
- Cause: first-time app installation has not been authorized by a site admin.
- Fix: ask a site admin to complete OAuth once on the same Atlassian site.

`Your organization admin must authorize access from a domain to this site`
- Cause: org-level domain allowlist policy blocks the MCP client domain.
- Fix: org admin must allow the relevant domain in Atlassian Rovo MCP server settings.

`You don't have permission to connect from this IP address`
- Cause: Atlassian IP allowlisting is enabled and current network/VPN egress IP is not allowed.
- Fix: admin must allow current network/VPN IP ranges for the Atlassian products in use.

OAuth browser flow does not complete
- Cause: browser session mismatch, blocked callback, or stale login.
- Fix:
```bash
codex mcp logout atlassian
codex mcp login atlassian
```

Still no Jira/Confluence data after successful login
- Cause: missing user permissions in Jira projects or Confluence spaces.
- Fix: validate direct access in Atlassian UI with the same account, then re-test MCP query.

## Rebuild config safely

Use this reset sequence:
```bash
codex mcp remove atlassian
codex mcp add atlassian --url https://mcp.atlassian.com/v1/mcp
codex mcp login atlassian
codex mcp list
```

## API token fallback

Use only when org policy allows API token auth:
```bash
export ATLASSIAN_API_TOKEN='...'
codex mcp add atlassian \
  --url https://mcp.atlassian.com/v1/mcp \
  --bearer-token-env-var ATLASSIAN_API_TOKEN
```

If policy disables API token auth, fallback will fail and OAuth is required.
