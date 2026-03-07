# Blog Content API Reference

Use this file as the quick cheat sheet for the Blog content API.

## Auth

- `Authorization: Bearer <api-key>`
- or `x-api-key: <api-key>`

Managed keys are generated in `/admin`.

## Endpoints

### Posts

- `GET /api/posts?published=all|true|false`
- `POST /api/posts`
- `GET /api/posts/:id-or-slug`
- `PUT /api/posts/:id-or-slug`
- `PATCH /api/posts/:id-or-slug`
- `DELETE /api/posts/:id-or-slug`

Post payload:

```json
{
  "title": "string",
  "slug": "optional string",
  "content": "markdown string",
  "published": true
}
```

### Projects

- `GET /api/projects?published=all|true|false`
- `POST /api/projects`
- `GET /api/projects/:id-or-slug`
- `PUT /api/projects/:id-or-slug`
- `PATCH /api/projects/:id-or-slug`
- `DELETE /api/projects/:id-or-slug`

Project payload:

```json
{
  "title": "string",
  "slug": "optional string",
  "description": "string",
  "hero_image": "/uploads/example.png",
  "technologies": ["Astro", "SQLite", "curl"],
  "published": false
}
```

`technologies` can also be a comma-separated string or `null`.

### Uploads

- `POST /api/upload-image`

Multipart form field:

- `file`

Upload response:

```json
{
  "url": "/uploads/1712345678901-cover.png",
  "filename": "1712345678901-cover.png",
  "content_type": "image/png",
  "size": 58231
}
```

## Common flow

1. Upload image if needed.
2. Use returned `url` in markdown or `hero_image`.
3. Create or patch the post or project.

## Field rules

- Slugs are normalized server-side.
- Posts require non-empty `title` and `content`.
- Projects require non-empty `title` and `description`.
- `published` accepts booleans and boolean-like values such as `true`, `false`, `1`, `0`, `live`, and `draft`.

## Useful docs in the repo

- `docs/content-api.md`
- `src/lib/content-api-openapi.json`
