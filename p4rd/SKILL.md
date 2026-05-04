---
name: p4rd
description: Generate or update agent-ready PRD and task plans for new or existing projects, including roadmap alignment, gap analysis, dependency-safe task sequencing, and evidence-based pass tracking. Use when users ask to create PRD/plan files, extend scope, re-plan after implementation, sync tasks with latest commits, or align partial features to a roadmap.
---

# PRD And Plan Sync

Generate and maintain `.agents/PRD.md` and `.agents/PLAN.md` as executable specs with strict dependency integrity.

## Outputs

- `.agents/PRD.md` (requirements and scope)
- `.agents/PLAN.md` (JSON task list with `passes` state and valid `depends_on` graph)

## Modes

Choose one mode explicitly before editing files.

1. `init`: create first PRD/plan for a new project.
2. `extend`: add a new feature wave to existing PRD/plan.
3. `sync`: reconcile PRD/plan with implemented commits and current repo behavior.
4. `align`: plan closure of known partial alignment against external roadmap or architecture targets.

For `sync` or `align`, read existing `.agents/PRD.md`, `.agents/PLAN.md`, and relevant commit/docs first.

## Workflow

1. Choose mode (`init`, `extend`, `sync`, `align`).
2. Read current PRD/PLAN and implementation evidence.
3. Build a dependency map before drafting tasks.
4. Write PRD updates and PLAN tasks in topological order.
5. Validate task dependency graph and pass-state integrity.
6. Emit only verified `passes: true` values.

## Intake Questions

Ask concise multiple-choice questions when details are missing.

1. Project state?
A. New project
B. Existing project

2. Primary action?
A. Initialize PRD+plan
B. Extend with new wave
C. Sync implemented work into specs
D. Align gaps to roadmap

3. Risk posture?
A. Fast iteration
B. Balanced (recommended)
C. Safety-first with stronger gates

4. Quality gates?
A. `pnpm build && pnpm lint && pnpm typecheck`
B. `pnpm test:all && pnpm doctor:config`
C. Custom commands

5. Out of scope for this wave?
A. Infra/deployment changes
B. UI changes
C. Data migrations
D. Other explicit exclusions

## Planning Rules

- Keep tasks atomic and dependency-aware.
- Keep IDs monotonic: `T-001`, `T-002`, ... append new IDs, never reuse.
- Keep categories in: `setup`, `feature`, `ui`, `api`, `data`, `testing`.
- Derive scope from the live repo context, existing PRD/PLAN artifacts, and the current operator request. Do not hardcode product-specific assumptions, fake paths, or fixed task counts that are not justified by the repo and request.
- For simple single-feature requests, default to 3 tasks:
  - audit/setup
  - one combined implementation task
  - one validation/evidence task
- Merge overlapping `feature` and `ui` work when the same files, route surface, or nav shell changes satisfy both.
- Do not create a follow-up implementation task whose only purpose is to "integrate" or "wire" the same page/route/nav changes already required by the main implementation task.
- Avoid plans that require a second fresh product diff immediately after the primary feature is already shipped, unless there is a truly separate surface or artifact.
- Every task must include:
  - clear `description`
  - `depends_on` (array, hard prerequisites only)
  - `steps`
  - `criteria` with both:
    - Example case
    - Negative case
- For planned-but-unimplemented tasks: set `"passes": false`.
- Set `"passes": true` only when verification evidence exists (commands/tests/results).

## Dependency Semantics

Apply all rules:

1. Treat `depends_on` as hard prerequisites only. Do not include optional coordination.
2. Keep the task graph acyclic. Never create direct or indirect cycles.
3. Reference only existing task IDs. Never point to unknown IDs.
4. Keep dependencies backward-pointing in the list order. Task `T-0NN` should depend on earlier tasks only.
5. Limit fan-in to 3 dependencies unless the task is an explicit integration gate.
6. Split tasks when prerequisites are ambiguous. Prefer two smaller tasks over one mixed dependency task.
7. Keep track-level work parallel when possible. Add cross-track dependencies only for explicit integration points.
8. For simple page/route/API additions, prefer one cohesive implementation node over `implement -> integrate` chains that touch the same files.
9. If a later task would only restate acceptance criteria already covered by an earlier implementation task, merge them instead of creating a duplicate dependency edge.

## Anti-Duplication Check

Before finishing the PLAN, run this mental lint:

1. If two planned tasks would modify the same route/page/endpoint/file surface, ask whether they should be one implementation task.
2. If the request is a simple single-surface feature, there should usually be only:
   - one audit/setup task
   - one implementation task
   - one validation/evidence task
3. If existing `.agents/PRD.md` or `.agents/PLAN.md` already cover part of the scope, sync or extend them instead of re-initializing the same work as new duplicate tasks.
4. If a task only says "wire", "integrate", "polish", or "make discoverable" for the exact same surface the main implementation task already covers, merge it unless it is truly a separate validation gate.

Use dependency templates from:
- [references/dependency-planning.md](references/dependency-planning.md)

## Pass State Policy

When updating existing plans:

- Preserve already verified `passes: true` tasks unless evidence contradicts them.
- Add new tasks for uncovered gaps instead of mutating unrelated validated tasks.
- If a task is partially implemented, split it:
  - validated part remains `passes: true`
  - remaining scope becomes new task(s) with `passes: false`
- Keep pass-state consistency with dependencies:
  - A task cannot remain `passes: true` if any dependency is unverified (`passes: false`) for the same scope.

## Alignment Workflow

For roadmap alignment requests, execute this sequence:

1. Build a gap table: `roadmap target -> current capability -> gap`.
2. Separate gaps into tracks (for example memory intelligence, remediation autonomy).
3. Create 3-6 tasks per track with strict dependencies and measurable gates.
4. Add explicit non-goals for current wave to prevent scope bleed.
5. Update both PRD and PLAN so they remain consistent.

Use detailed templates from:
- [references/alignment-tracks.md](references/alignment-tracks.md)
- [references/dependency-planning.md](references/dependency-planning.md)
- [references/pass-evidence.md](references/pass-evidence.md)

## Required Sections In PRD Updates

Ensure PRD keeps or adds:

- Overview
- Goals
- Non-Goals
- Technical Stack
- Functional Requirements
- Quality Gates
- Open Questions

For alignment waves, add a dedicated section:
- `Roadmap Alignment Wave`

## Required Sections In PLAN Updates

Ensure PLAN keeps or adds:

- Decision/extension summary for the wave
- JSON tasks list
- Accurate `passes` values
- Valid dependency DAG (`depends_on`)

For alignment waves, add tasks that clearly map to named gaps.

## Dependency Validation

Run dependency validation after editing PLAN:

```bash
python "$HOME/.agents/skills/p4rd/scripts/validate_task_dependencies.py" .agents/PLAN.md
```

Run strict ordering validation when the task list must be fully topological:

```bash
python "$HOME/.agents/skills/p4rd/scripts/validate_task_dependencies.py" .agents/PLAN.md --strict-order
```

Run quick skill validation before finishing skill updates:

```bash
python "$HOME/.agents/skills/skill-creator/scripts/quick_validate.py" "$HOME/.agents/skills/p4rd"
```

## Memory And Remediation Alignment Defaults

When asked to align these partial areas, use two tracks.

1. `Memory Intelligence Track`
- trajectory capture schema
- compaction and retention policy engine
- structured recall ranking + evaluation harness
- context-graph projection from traces

2. `Remediation Autonomy Track`
- unified signal ingestion (tests/incidents/operator feedback)
- remediation planner with severity + dependency logic
- guarded auto-execution flow (approval policy)
- closed-loop learning from remediation outcomes

Default these tasks to `passes: false` unless explicitly implemented and verified.
