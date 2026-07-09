---
name: mobile-apps-add-native
description: "Public entry point for native device capabilities and native controls — camera, image picker, barcode/QR scanner, document picker, file picker, secure storage, file system, sharing, PDF generation/viewing, pen/signature capture, background GPS/geolocation tracking, or supported local file workflows — in a Power Apps mobile app. Also owns routing to internal camera/PDF/pen/geolocation implementation helpers and the guidance boundary between native wrappers and Dataverse File/Image host controls."
source: microsoft/power-platform-skills/plugins/mobile-apps/skills/add-native
---

# mobile-apps-add-native

This is a Codex-compatible wrapper for the Microsoft Power Platform skill `mobile-apps/add-native`.

Before acting, read and follow the source skill completely:

- Source skill: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-native/SKILL.md`
- PLUGIN_ROOT: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`
- CLAUDE_SKILL_DIR: `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-native`

When the source skill mentions `${PLUGIN_ROOT}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps`.
When it mentions `${CLAUDE_SKILL_DIR}`, resolve it to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-native`.
For relative links inside that source file, resolve paths relative to `/home/dcarvalho/.agents/skills/.sources/power-platform-skills/plugins/mobile-apps/skills/add-native` unless the source explicitly says otherwise.

Use Codex-native tools that correspond to the source skill's tool names. If the source requests a Claude-only tool that is unavailable, use the closest Codex equivalent and keep the same safety gates, approval requirements, and verification steps.
