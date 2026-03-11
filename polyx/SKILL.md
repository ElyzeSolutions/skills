---
name: polyx
description: X/Twitter intelligence gathering, search, sentiment analysis, and report generation. Use when you need to fetch tweets, analyze social media sentiment using AI (Grok, Gemini, OpenRouter), or generate comprehensive intelligence reports from X data.
allowedCommands:
  - polyx
requiredTools:
  - polyx
---

# PolyX — X/Twitter Intelligence

PolyX is a powerful toolkit for gathering and analyzing intelligence from X (Twitter). It supports dual-mode client operations (API v2 and GraphQL), pluggable AI providers, and flexible output formats.

Preferred Elyze/operator surface: use the installed `polyx` CLI. Only fall back to `uv run python -m polyx.cli ...` in a source-only checkout where the packaged `polyx` command is truly unavailable.

## Core Workflows

### 1. Searching Tweets
Search for recent tweets with optional sentiment analysis and noise filtering.

```bash
# Basic search
polyx search "query"

# Search with sentiment and no promotional noise
polyx search "query" --sentiment --no-noise --limit 50
```

When emitting native `execute_command` payloads for Elyze/operator runs, prefer structured `argv` such as `["polyx", "search", "query"]`. Keep the full search query as one argv item instead of splitting natural-language queries into multiple positional words.

### 2. AI Analysis & Model Selection
Analyze topics using Grok, Gemini, or OpenRouter. Supports unified "provider/model" syntax.

```bash
# Use specific provider and model
polyx analyze "topic" --model gemini/gemini-flash-lite-latest
polyx analyze "topic" --model openrouter/free

# Support for nested models
polyx analyze "AI" --model openrouter/openai/gpt-4o-mini
```

### 3. Intelligence Reports
Generate comprehensive Markdown reports synthesizing search results and AI insights.

```bash
# Generate report
polyx report "topic" --pages 3 --sentiment --model gemini/gemini-flash-lite-latest --save
```

### 4. Real-time Monitoring
Watch for new tweets and optionally deliver to webhooks.

```bash
polyx watch "query" --interval 1m --webhook <url>
```

### 5. User Profiles & Trends
Fetch user profiles, timelines, and trending topics.

Use `polyx search "topic"` for topic-specific requests such as "trends related to XAUUSD" or "recent discussion about Iran". Use `polyx trends` only for platform/location-wide trending topics, because it does not take a query string.

```bash
# User profile
polyx profile <username> --tweets 10

# Trends
polyx trends --location us
```

## Source-Only Fallback

Use this only when `polyx --help` is unavailable and you are operating from a source checkout with `uv` installed:

```bash
uv run python -m polyx.cli search "query"
```

## Output Formats
PolyX supports several output modes via global flags:
- `--terminal`: Human-readable rich output (default).
- `--json`: Full SearchResult envelope.
- `--jsonl`: One tweet per line.
- `--csv`: Flat format for spreadsheets.
- `--markdown`: Formatted report style.

## Configuration & Auth
- **API v2**: Requires `X_BEARER_TOKEN` (Bearer auth).
- **GraphQL**: Requires `AUTH_TOKEN` and `CT0` cookies.
- **AI**: Requires `GOOGLE_API_KEY`, `OPENROUTER_API_KEY`, or `XAI_API_KEY`.

See [cli_help.md](references/cli_help.md) for full parameter documentation.
