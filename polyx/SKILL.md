---
name: polyx
description: X/Twitter intelligence gathering, search, sentiment analysis, and report generation. Use when you need to fetch tweets, analyze social media sentiment using AI (Grok, Gemini, OpenRouter), or generate comprehensive intelligence reports from X data.
---

# PolyX — X/Twitter Intelligence

PolyX is a powerful toolkit for gathering and analyzing intelligence from X (Twitter). It supports dual-mode client operations (API v2 and GraphQL), pluggable AI providers, and flexible output formats.

## Core Workflows

### 1. Searching Tweets
Search for recent tweets with optional sentiment analysis and noise filtering.

```bash
# Basic search
uv run python -m polyx.cli search "query"

# Search with sentiment and no promotional noise
uv run python -m polyx.cli search "query" --sentiment --no-noise --limit 50
```

### 2. AI Analysis & Model Selection
Analyze topics using Grok, Gemini, or OpenRouter. Supports unified "provider/model" syntax.

```bash
# Use specific provider and model
uv run python -m polyx.cli analyze "topic" --model gemini/gemini-flash-lite-latest
uv run python -m polyx.cli analyze "topic" --model openrouter/free

# Support for nested models
uv run python -m polyx.cli analyze "AI" --model openrouter/openai/gpt-4o-mini
```

### 3. Intelligence Reports
Generate comprehensive Markdown reports synthesizing search results and AI insights.

```bash
# Generate report
uv run python -m polyx.cli report "topic" --pages 3 --sentiment --model gemini/gemini-flash-lite-latest --save
```

### 4. Real-time Monitoring
Watch for new tweets and optionally deliver to webhooks.

```bash
uv run python -m polyx.cli watch "query" --interval 1m --webhook <url>
```

### 5. User Profiles & Trends
Fetch user profiles, timelines, and trending topics.

```bash
# User profile
uv run python -m polyx.cli profile <username> --tweets 10

# Trends
uv run python -m polyx.cli trends --location us
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
- **AI**: Requires `GEMINI_API_KEY`, `OPENROUTER_API_KEY`, or `XAI_API_KEY`.

See [cli_help.md](references/cli_help.md) for full parameter documentation.
