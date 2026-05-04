# AI Agent Skills

A public collection of reusable skills for local coding agents. Each skill packages task-specific instructions and, when needed, supporting references, templates, scripts, or examples.

## Install

These skills are designed to live at `~/.agents/skills`, which is a common discovery path for agent tooling such as Codex, Claude Code, and Gemini CLI.

For macOS and Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/ElyzeSolutions/skills-new/main/install.sh | bash
```

For Windows PowerShell:

```powershell
iwr https://raw.githubusercontent.com/ElyzeSolutions/skills-new/main/install.ps1 | iex
```

## What The Install Scripts Do

`install.sh` and `install.ps1` are bootstrap scripts. They:

1. Create `~/.agents` if it does not already exist.
2. Clone this repository into `~/.agents/skills` on first install.
3. Update the existing checkout on later runs.
4. Point the local checkout at `ElyzeSolutions/skills-new` before updating.

If you prefer to install manually:

```bash
git clone https://github.com/ElyzeSolutions/skills-new.git ~/.agents/skills
```

## Repository Layout

Each skill lives in its own directory and usually includes:

- `SKILL.md`: the main skill definition and usage guidance
- `references/`: focused supporting documentation
- `templates/`: reusable starter files
- `scripts/`: utility scripts used by the skill
- `examples/` or `assets/`: optional examples and supporting assets

## Selected Skill Areas

- Planning and skill authoring: `p4rd`, `skill-creator`, `find-skills`
- Browser automation: `agent-browser`, `browser-use`, `playwright-cli`, `playwright-generate-test`
- Frontend design and UX: `frontend-design`, `design-taste-frontend`, `redesign-existing-projects`, `web-design-guidelines`
- React and state management: `zustand-state-management`, `react-state-management`, `tanstack-query-best-practices`, `tanstack-router-best-practices`, `tanstack-start-best-practices`
- Performance and refactoring: `react-performance-optimization`, `python-performance-optimization`, `refactor-pass`, `vercel-react-best-practices`
- Specialized workflows: `ai-sdk`, `obsidian`, `polybot`, `polyx`, `remotion-best-practices`, `websocket-engineer`

## Using A Skill In A Project

If your tool does not automatically read `~/.agents/skills`, you can symlink specific skills into project-local directories:

```bash
mkdir -p .claude
ln -s ~/.agents/skills/zustand-state-management .claude/zustand
```

## Contributing

1. Add or update a skill in its own directory.
2. Keep `SKILL.md` concise, explicit, and production-oriented.
3. Include only the references and scripts the skill actually needs.
4. Avoid machine-specific paths, local state, generated caches, and secrets.
