---
name: polybot
description: Operate, troubleshoot, and orchestrate Polybot across Polymarket and MT5 lanes. Trigger when the user needs to start/stop the bot, check health/status, tune settings (risk, modules, profiles), execute trade approvals, or handle Telegram External mode callbacks.
---

# Polybot Skill

Use this skill when working inside a Polybot checkout. The repo root should contain `./polybot`, `./orch`, `AGENTS.md`, `OPERATIONS.md`, and `ARCHITECTURE.md`.

## Ground Rules

- Run commands from the repo root.
- Prefer `./polybot` for lifecycle, settings, risk, modules, profiles, verification, and diagnostics.
- Prefer `uv run polybot-trade ...` for manual Polymarket trade operations.
- For one-off scripts not exposed by `./polybot`, use `uv run python src/polybot/scripts/...`.
- Do not rely on legacy `python -m cli.trade` or root `scripts/*.py` compatibility paths.
- Never edit SQLite files directly. Use CLI/API-backed mutations.

## Core Workflow

1. Preflight: `./polybot status` and `./polybot health`
2. Mutate with the smallest API-backed or wrapper command possible
3. Verify:
   - always: `./polybot verify --strict`
   - after account/risk/execution changes: `./polybot verify-reconcile --strict`
   - after major release work: `./polybot verify-suite --deep`

## Canonical Commands

### Runtime Control

```bash
./polybot status
./polybot health
./polybot start
./polybot stop
./polybot restart
./polybot logs --since 1h
./polybot tail
./polybot clean --keep-bankroll --keep-logs
```

### API-Backed Mutations

```bash
./polybot settings get
./polybot settings set <key> <value>
./polybot settings preset quiet
./polybot settings preset balanced
./polybot settings preset full

./polybot module list
./polybot module disable <module_id> --reason maintenance
./polybot module enable <module_id>
./polybot module pause <module_id> --reason maintenance_window
./polybot module resume <module_id> --reason maintenance_complete
./polybot module start <module_id>
./polybot module stop <module_id> --reason hard_stop

./polybot risk get
./polybot risk set HALTED --reason manual_halt
./polybot risk resume --reason operator_resume

./polybot profile list
./polybot profile show <profile_id>
./polybot profile bankroll-reset <profile_id> --equity <usd>
./polybot drawdown fix <profile_id> --equity <usd> --risk-reason operator_recover
```

### Verification Gates

```bash
./polybot verify --strict
./polybot verify-reconcile --strict
./polybot verify-reconcile --strict --scope profile --profile-id <profile_id>
./polybot verify-reconcile --simulate-vol-sizing --simulation-limit 200
./polybot verify-live --strict
./polybot verify-onboarding
./polybot verify-canary --strict --rollback-dry-run
./polybot verify-release --strict --deep --execution-mode dry-run
./polybot verify-suite --deep
uv run python src/polybot/scripts/doc_drift_gate.py
uv run python src/polybot/scripts/mt5_sizing_canary_gate.py --strict
```

### Manual Trading

Use the packaged trade entrypoint:

```bash
uv run polybot-trade --help
uv run polybot-trade enter --market <id_or_slug> --side YES --amount 50 --strategy RIDE_TO_END
uv run polybot-trade enter --market <id_or_slug> --side NO --amount 25 --strategy TAKE_PROFIT_30 --execute --yes
uv run polybot-trade strategy --id <trade_id> --strategy TAKE_PROFIT_30
uv run polybot-trade status --id <trade_id>
uv run polybot-trade list
uv run polybot-trade exit --id <trade_id> --execute --yes
uv run polybot-trade approvals check
uv run polybot-trade approvals set --yes
```

### MT5 Approval Execution

List pending MT5 approvals:

```bash
uv run python -c "from polybot.lib.state_store import StateStore; import json; p=StateStore().get_approvals(venue='mt5', decision='pending', limit=5); print(json.dumps([{'id':a['id'],'symbol':(a.get('metadata') or {}).get('symbol'),'action':(a.get('metadata') or {}).get('action'),'lot_size':(a.get('metadata') or {}).get('lot_size'),'price':(a.get('metadata') or {}).get('price')} for a in p], indent=2))"
```

Approve one:

```bash
uv run python src/polybot/scripts/mt5_approve.py <approval_id>
```

### No-Spam Test Window

`./polybot settings preset quiet` is a notification preset only. It does **not** disable execution modules by itself.

Use this full posture when you want safe UI/API testing with minimal Telegram noise:

```bash
./polybot settings preset quiet
./polybot module disable mt5_execution --reason operator_no_spam_test
./polybot module disable polymarket --cascade --reason operator_no_spam_test
./polybot settings set notify_mt5_hold_block_reminder_sec 3600
./polybot settings set notify_mt5_block_reminder_sec 900
```

Restore normal posture:

```bash
./polybot module enable polymarket
./polybot module enable mt5_execution
./polybot settings preset balanced
```

## Telegram External Mode

When `telegram_feedback_owner=external`, callbacks must be bridged back to the Polybot dashboard API.

- Bypass rule: if a callback or command starts with `pb1|`, forward it directly
- Endpoint: `POST http://127.0.0.1:8888/api/telegram/callback`
- Payload:

```json
{"callback_data":"<data>","source":"openclaw_telegram_bridge"}
```

## Datastores

- `data/state_store.db`: approvals, trades, profiles, bankroll, risk state
- `data/events.db`: telemetry, timeline, runtime settings
- `data/api_cache.db`: API/cache state

## Repo Context To Load

When you need more detail, prefer these files from the workspace root:

- `AGENTS.md`: operator shortcuts and common-user-intent mappings
- `OPERATIONS.md`: deployment, verification, and runtime safety procedures
- `ARCHITECTURE.md`: system topology, routing, and lane semantics
- `references/commands.md`: current wrapper commands and quiet-mode posture
- `references/manual-trading.md`: trade + approval flows
- `references/verification-safety.md`: smoke checks and safety notes
- `src/polybot/dashboard/README.md`: dashboard/API operator surface

## Safety Notes

- Keep changes reversible and minimal.
- Use dashboard/API-backed mutations before editing config or code.
- After risky runtime changes, inspect `./polybot status`, `./polybot logs --since 1h`, and reconciliation gates.
- If docs and runtime disagree, trust `./polybot --help`, `uv run polybot-trade --help`, and the current source tree under `src/polybot/`.
