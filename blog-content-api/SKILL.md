---
name: blog-content-api
description: Use this skill whenever the user wants to publish, edit, delete, inspect, or automate blog posts and project entries for the Blog content API, especially from the Blog repo, terminal, shell scripts, CI, remote machines, or with API keys. Prefer the repo's private local CLI when available. Trigger on requests about blog publishing, project artifacts, slug changes, post draft save/discard/publish flows, image uploads, CLI commands, curl examples, API docs, content automation, or syncing content into this Astro blog even if the user does not explicitly say "API."
compatibility: Requires shell access. Works best when the Blog repo is available locally so the agent can use `npm run blog -- ...` and read docs/content-api.md. Falls back to curl for remote-only environments.
---

# Blog Content API

Use this skill to operate the Blog content API safely and efficiently.

## Preferred interface

When working inside the Blog repo, prefer the private local CLI:

```sh
npm run blog -- <resource> <action> [options]
```

The CLI still calls the same HTTP API, so it needs:

```sh
export BLOG_BASE_URL='https://your-domain.com'
export BLOG_API_KEY='paste-the-key-here'
```

Use `curl` only when the repo or CLI is unavailable, the user explicitly wants raw HTTP examples, or they are wiring a remote shell/CI job where npm scripts are not appropriate.

## Source of truth

When working inside the Blog repo, read these in order:

1. `docs/content-api.md`
2. `src/lib/content-api-openapi.json` only if you need field-level details or machine-readable schema

If those files are missing, inspect the repo for `/api/posts`, `/api/projects`, and `/api/upload-image` routes before making assumptions.

## What this skill handles

- Creating, listing, updating, and deleting posts
- Saving, discarding, and publishing post drafts through the posts API
- Creating, listing, updating, and deleting projects
- Uploading images and wiring the returned `/uploads/...` URL into content
- Generating ready-to-run CLI or curl commands
- Explaining auth, payload shapes, slugs, and response formats

## Auth expectations

Prefer `Authorization: Bearer <api-key>`.

Also supported:

- `x-api-key: <api-key>`

If the user needs a new key, direct them to the Blog admin dashboard at `/admin`. Managed keys are shown only once when created, so do not imply they can be recovered later.

## Working style

1. Confirm the base URL.
If the repo is local and the user is targeting their deployed site, prefer the URL they provide.
If no deployment URL is available, use the local dev server URL only when that is clearly the target.

2. Use the documented payloads instead of inventing fields.
Posts use `title`, `slug`, `content`, and `published`.
Post updates also support `draft_action` with `preserve`, `discard`, `save`, or `publish`.
Projects use `title`, `slug`, `description`, `hero_image`, `gallery_images`, `technologies`, `status`, and `published`.

3. Upload images before creating content that references them.
For posts, insert the returned URL into markdown image syntax.
For projects, pass the returned URL as `hero_image` or append it to `gallery_images`.

4. Treat slugs as first-class.
If the user provides a slug, preserve it unless they ask to change it.
If they omit it, let the server normalize it from the title.

When updating posts, be deliberate about draft state.
Use `draft_action: "discard"` after a live API edit if the user wants to clear any stale admin draft shadow.
Use `draft_action: "save"` to stage a draft remotely without changing the live post.
Use `draft_action: "publish"` to stage and immediately promote the draft live.

5. Return the result in a way the user can act on quickly.
Summarize what endpoint you used, what was created or changed, and the final slug or upload URL.

## Terminal execution pattern

Prefer the local CLI when the Blog repo is available:

1. Export configuration:
`export BLOG_BASE_URL='https://your-domain.com'`
`export BLOG_API_KEY='...'`
2. Upload images if needed:
`npm run blog -- upload-image ./cover.png`
3. Create or update content with `posts` or `projects` commands.
4. Report the returned ID, slug, and any upload URL.

The CLI command map:

- `npm run blog -- posts list --published all|true|false`
- `npm run blog -- posts get <id-or-slug>`
- `npm run blog -- posts create --title <title> --content-file <path> [--slug <slug>] [--published true|false]`
- `npm run blog -- posts update <id-or-slug> [--title <title>] [--content-file <path>] [--draft-action preserve|discard|save|publish]`
- `npm run blog -- posts delete <id-or-slug>`
- `npm run blog -- projects list --published all|true|false`
- `npm run blog -- projects get <id-or-slug>`
- `npm run blog -- projects create --title <title> --description <text> [--hero-image <url>] [--gallery-image <url>] [--technology <name>] [--status active|shipped|archived] [--published true|false]`
- `npm run blog -- projects update <id-or-slug> [--hero-image <url>|--clear-hero-image] [--gallery-image <url>|--clear-gallery] [--technology <name>|--clear-technologies]`
- `npm run blog -- projects delete <id-or-slug>`
- `npm run blog -- upload-image <path>`

Use repeated `--gallery-image` and `--technology` flags for arrays.

## Curl fallback pattern

Use `curl` when the local CLI is not available or the user specifically needs raw HTTP.

Typical flow:

1. Export a key in the shell:
`export BLOG_API_KEY='...'`
2. Upload an image if needed.
3. Create or update the post or project.
4. Report the returned ID, slug, and any upload URL.

## Examples

### Create a post

```sh
curl -X POST "$BLOG_BASE_URL/api/posts" \
  -H "Authorization: Bearer $BLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Shipping from home",
    "slug": "shipping-from-home",
    "content": "# Hello\n\nPublished from the terminal.",
    "published": true
  }'
```

### Upload an image

```sh
curl -X POST "$BLOG_BASE_URL/api/upload-image" \
  -H "Authorization: Bearer $BLOG_API_KEY" \
  -F "file=@./cover.png"
```

### Update a post and clear any pending draft

```sh
curl -X PATCH "$BLOG_BASE_URL/api/posts/shipping-from-home" \
  -H "Authorization: Bearer $BLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Shipping from home",
    "content": "# Hello\n\nUpdated from the terminal.",
    "draft_action": "discard"
  }'
```

### Create a project with uploaded media

```sh
curl -X POST "$BLOG_BASE_URL/api/projects" \
  -H "Authorization: Bearer $BLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Terminal-first publishing",
    "description": "Created remotely from a shell script.",
    "hero_image": "/uploads/1712345678901-cover.png",
    "gallery_images": [
      "/uploads/1712345678902-overview.webp",
      "/uploads/1712345678903-detail.webp"
    ],
    "technologies": ["Astro", "SQLite", "curl"],
    "published": false
  }'
```

## Error handling

- `401`: key missing or invalid. Ask for a fresh key or confirm the header format.
- `404`: wrong slug or ID. Suggest listing the collection first.
- `409`: slug conflict. Suggest a new slug or fetch the existing record.
- `503`: no valid keys configured yet. Tell the user to generate one in `/admin` or configure an env key.

## Response style

Keep the answer practical and short:

- what you changed
- endpoint used
- final slug or identifier
- upload URL if relevant
- exact next command only if it helps

## Reference file

Load `references/api.md` when you need the quick endpoint map without opening the full repo docs.
