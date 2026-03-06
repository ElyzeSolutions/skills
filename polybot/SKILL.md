---
name: polybot
description: Operate, troubleshoot, and orchestrate Polybot across Polymarket and MT5 lanes. Trigger when the user needs to start/stop the bot, check health/status, tune settings (risk, modules, profiles), execute trade approvals, or handle Telegram External mode callbacks.
---

# Polybot Skill

Complete operational control plane for the Polybot trading system.

## Core Workflow

1. **Preflight**: Confirm environment, check `./polybot status` and `./polybot health`.
2. **Action**: Apply surgical changes using CLI or scripts.
3. **Verification**: Run `./polybot verify --strict` and check logs.

## Runtime Controls (CLI)

Use `./polybot` for most operations.

| Command | Description |
|---------|-------------|
| `./polybot status` | Check process status |
| `./polybot health` | Check system health (API, DB, Balance) |
| `./polybot start/stop/restart` | Process lifecycle management |
| `./polybot settings get/set` | Runtime configuration |
| `./polybot module list/enable/disable` | Module orchestration |
| `./polybot risk get/set` | Global risk state (e.g. HALTED) |
| `./polybot profile list/show` | Profile-scoped management |
| `./polybot verify --strict` | Post-change validation |

## Manual Trading & Approvals

### Polymarket CLI
```bash
uv run python -m cli.trade enter --market <id> --side YES --amount <usd>
uv run python -m cli.trade list
uv run python -m cli.trade exit --id <trade_id> --execute
```

### MT5 Approvals
List pending:
```bash
uv run python -c "from lib.state_store import StateStore; import json; print(json.dumps(StateStore().get_approvals(venue='mt5', decision='pending'), indent=2))"
```
Approve:
```bash
uv run python scripts/mt5_approve.py <approval_id>
```

## Telegram External mode (Callback Bridge)

When `telegram_feedback_owner=external`, callbacks must be bridged to the Polybot API.

**Bypass Rule**: If a command or callback starts with `pb1|`, forward it directly to the API.

**API Endpoint**: `POST http://127.0.0.1:8888/api/telegram/callback`
**Payload**: `{"callback_data":"<data>","source":"openclaw_telegram_bridge"}`

## Operational Presets

- **Quiet Mode**: `./polybot settings preset quiet` (disables execution modules).
- **Halt**: `./polybot risk set HALTED --reason <msg>`.

## Datastores & Safety

- **State**: `data/state_store.db` (Approvals, Trades, Risk).
- **Telemetry**: `data/events.db` (Logs, Settings).
- **Safety**: Always `./polybot verify --strict` after mutations. Do not edit SQLite files directly.

## Reference Map

Load minimal context from `references/` when needed:
- `references/commands.md`: CLI details.
- `references/account-manager.md`: Profile/lane rules.
- `references/manual-trading.md`: Detailed trade CLI.
- `references/verification-safety.md`: Checklists.
