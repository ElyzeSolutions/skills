# AI Agent Skills

A collection of specialized skills for AI agents (specifically optimized for Gemini and Claude). This repository serves as a central hub for my organization's agentic workflows, combining community-driven best practices with custom internal tools.

---

## 🚀 Setup & Installation

To use these skills, the **entire contents of this repository** must be available in your local agent environment. Agents like **Codex**, Gemini CLI, and Claude are configured to automatically discover and utilize these skills when they are placed in the standard directory.

### Required Path: `~/.agents/skills`

### Quick Installation

For macOS/Linux:
```bash
curl -fsSL https://raw.githubusercontent.com/ElyzeSolutions/skills/main/install.sh | bash
```

For Windows (PowerShell):
```powershell
iwr https://raw.githubusercontent.com/ElyzeSolutions/skills/main/install.ps1 | iex
```

### 🪄 Compatibility (Manual Context)

For tools that don't natively support the `~/.agents/skills` path, you can provide the skill context manually using project-level configuration folders:

- **`.claude`**: Symlink or copy specific skills into a `.claude` folder in your project root.
- **`.antigravity`**: Used by older or alternative agent systems (inspired by Vercel's skill patterns).
- **`.gemini`**: For Gemini-specific project context.

To link a skill to a project:
```bash
# Example: Linking the Zustand skill
mkdir -p .claude
ln -s ~/.agents/skills/zustand-state-management .claude/zustand
```

---

## 🛠 Available Skills

### 🧠 Agent Autonomy & Planning
- **[p4rd](./p4rd)**: Generate and maintain agent-ready PRDs and task plans with strict dependency integrity.
- **[skill-creator](./skill-creator)**: Create, iterate, and benchmark new skills for AI agents.
- **[find-skills](./find-skills)**: Helps agents discover and install relevant skills for their current task.

### 🌐 Browser & Web Interaction
- **[agent-browser](./agent-browser)**: Browser automation CLI for navigation, form filling, and data extraction.
- **[browser-use](./browser-use)**: High-level browser interaction patterns.

### 🎨 Frontend Design & UX
- **[frontend-design](./frontend-design)**: Production-grade UI development and aesthetics.
- **[design-taste-frontend](./design-taste-frontend)**: Senior UI/UX engineering guidelines.
- **[redesign-existing-projects](./redesign-existing-projects)**: Audit and upgrade existing UIs.
- **[web-design-guidelines](./web-design-guidelines)**: Accessibility, UX, and consistency auditing.

### ⚛️ Frameworks & State Management
- **[zustand-state-management](./zustand-state-management)**: Type-safe global state patterns for Zustand.
- **[react-state-management](./react-state-management)**: Comprehensive guide for Redux, Jotai, and React Query.
- **[tanstack-query-best-practices](./tanstack-query-best-practices)**: Advanced data fetching and caching.
- **[tanstack-router-best-practices](./tanstack-router-best-practices)**: Type-safe routing and data loading.
- **[tanstack-start-best-practices](./tanstack-start-best-practices)**: Full-stack React patterns.

### ⚡ Performance & Optimization
- **[react-performance-optimization](./react-performance-optimization)**: Memoization and code splitting strategies.
- **[python-performance-optimization](./python-performance-optimization)**: Profiling and bottleneck elimination for Python.
- **[refactor-pass](./refactor-pass)**: Focused cleanup and simplification.
- **[vercel-react-best-practices](./vercel-react-best-practices)**: Performance guidelines from Vercel engineering.

### 🔧 Specialized Tooling
- **[ai-sdk](./ai-sdk)**: Best practices for building with the Vercel AI SDK.
- **[obsidian](./obsidian)**: Sync project context into Obsidian.
- **[polyx](./polyx)**: X/Twitter intelligence gathering, search, and AI-powered sentiment analysis.
- **[remotion-best-practices](./remotion-best-practices)**: Programmatic video creation using React.
- **[websocket-engineer](./websocket-engineer)**: Real-time communication and scaling.
- **[grepai-search-advanced](./grepai-search-advanced)**: Advanced patterns for GrepAI.
- **[full-output-enforcement](./full-output-enforcement)**: Ensures complete code generation without truncation.
- **[capture-api-response-test-fixture](./capture-api-response-test-fixture)**: Capture API responses for testing.
- **[list-npm-package-content](./list-npm-package-content)**: Verify bundle contents before publishing.
- **[develop-ai-functions-example](./develop-ai-functions-example)**: Scaffolding for AI tool development.

---

## 🤝 Contributing

1. **Create a new skill**: Use the `skill-creator` patterns to bootstrap a new directory.
2. **Follow the Standard**: Each skill must have a `SKILL.md` with YAML frontmatter (name, description).
3. **Verify**: Ensure the skill includes necessary reference materials and scripts.

---
*Maintained by the Organization. Built with ❤️ and AI.*
