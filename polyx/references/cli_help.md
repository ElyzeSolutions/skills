Usage: python -m polyx.cli [OPTIONS] COMMAND [ARGS]...

  PolyX — X/Twitter intelligence toolkit.

Options:
  --version                   Show the version and exit.
  --json                      Output as JSON.
  --jsonl                     Output as JSONL.
  --csv                       Output as CSV.
  --markdown                  Output as Markdown.
  --client [v2|graphql|auto]  X client to use.
  -v, --verbose               Enable verbose output.
  --help                      Show this message and exit.

Commands:
  analyze  AI-powered tweet analysis.
  cache    Cache management.
  costs    API cost tracking and budget management.
  health   Check PolyX configuration and connectivity.
  profile  Show user profile and recent tweets.
  report   Generate an intelligence report.
  search   Search tweets by query.
  thread   Fetch a conversation thread.
  trends   Show trending topics.
  tweet    Fetch a single tweet.
  watch    Watch tweets in real-time with polling.
Usage: python -m polyx.cli search [OPTIONS] QUERY

  Search tweets by query.

Options:
  -l, --limit INTEGER             Max tweets to return.
  --sort [relevancy|recency|likes|impressions]
  --since TEXT                    Time window (1h, 6h, 1d, 7d) or ISO date.
  --pages INTEGER                 Number of pages to fetch.
  --min-likes INTEGER             Minimum likes filter.
  --no-noise                      Filter promotional noise.
  --sentiment                     Include keyword sentiment analysis.
  --no-cache                      Bypass cache.
  --full-archive                  Search full archive (API v2 only).
  --help                          Show this message and exit.
Usage: python -m polyx.cli analyze [OPTIONS] QUERY

  AI-powered tweet analysis.

Options:
  -p, --provider [grok|openrouter|gemini]
                                  AI provider.
  -m, --model TEXT                Model name (e.g. 'gemini/gemini-pro').
  --prompt TEXT                   Custom analysis prompt.
  --help                          Show this message and exit.
Usage: python -m polyx.cli report [OPTIONS] TOPIC

  Generate an intelligence report.

Options:
  --pages INTEGER                 Pages of tweets to fetch.
  --sentiment                     Include sentiment analysis.
  -p, --provider [grok|openrouter|gemini]
                                  AI provider for synthesis.
  -m, --model TEXT                Model override.
  --accounts TEXT                 Specific accounts to include.
  --save                          Save report to file.
  --help                          Show this message and exit.
