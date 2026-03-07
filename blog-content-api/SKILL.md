---
name: blog-content-api
description: Use this skill whenever the user wants to publish, edit, delete, inspect, or automate blog posts and project entries for the Blog content API, especially from the terminal, shell scripts, CI, remote machines, or with API keys. Trigger on requests about blog publishing, project artifacts, slug changes, image uploads, curl examples, API docs, content automation, or syncing content into this Astro blog even if the user does not explicitly say "API."
compatibility: Requires shell access for curl or similar HTTP tooling. Works best when the Blog repo is available locally so the agent can read docs/content-api.md and src/lib/content-api-openapi.json.
---

# Blog Content API

Use this skill to operate the Blog content API safely and efficiently.

## Source of truth

When working inside the Blog repo, read these in order:

1. `docs/content-api.md`
2. `src/lib/content-api-openapi.json` only if you need field-level details or machine-readable schema

If those files are missing, inspect the repo for `/api/posts`, `/api/projects`, and `/api/upload-image` routes before making assumptions.

## What this skill handles

- Creating, listing, updating, and deleting posts
- Creating, listing, updating, and deleting projects
- Uploading images and wiring the returned `/uploads/...` URL into content
- Generating ready-to-run terminal commands
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
Projects use `title`, `slug`, `description`, `hero_image`, `technologies`, and `published`.

3. Upload images before creating content that references them.
For posts, insert the returned URL into markdown image syntax.
For projects, pass the returned URL as `hero_image`.

4. Treat slugs as first-class.
If the user provides a slug, preserve it unless they ask to change it.
If they omit it, let the server normalize it from the title.

5. Return the result in a way the user can act on quickly.
Summarize what endpoint you used, what was created or changed, and the final slug or upload URL.

## Terminal execution pattern

Prefer `curl` unless the user already has another HTTP client in place.

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

### Create a project with uploaded media

```sh
curl -X POST "$BLOG_BASE_URL/api/projects" \
  -H "Authorization: Bearer $BLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Terminal-first publishing",
    "description": "Created remotely from a shell script.",
    "hero_image": "/uploads/1712345678901-cover.png",
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
