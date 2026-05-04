# Dependency Planning

Use this file when writing or updating `.agents/PLAN.md` tasks.

## Dependency Contract

Treat `depends_on` as hard execution prerequisites.

- Include only tasks that must complete first.
- Exclude optional collaboration or informational links.
- Keep `depends_on` as an array, even when empty.

## Ordering Rules

Follow these ordering constraints:

1. Write tasks in topological order.
2. Reference only earlier task IDs in `depends_on`.
3. Keep IDs monotonic (`T-001`, `T-002`, ...).
4. Avoid long linear chains when parallelization is possible.

## Graph Rules

Enforce DAG constraints:

- Do not create self-dependencies (`T-010` depends on `T-010`).
- Do not reference unknown IDs.
- Do not create cycles (A -> B -> C -> A).
- Keep fan-in <= 3 by default.
- Allow higher fan-in only for explicit integration or release gate tasks.

## Split Heuristics

Split one task into multiple tasks when:

- A task has mixed prerequisites from unrelated tracks.
- A task requires both schema design and runtime rollout.
- Criteria mix unit-level verification and end-to-end integration checks.

Split pattern:

1. Create base task (schema/setup).
2. Create implementation task (feature/api/ui).
3. Create integration task (cross-track validation).

## Parallelization Heuristics

Run in parallel when tasks share no hard prerequisites.

- Keep track-local tasks independent when possible.
- Join tracks at explicit integration tasks.
- Add one gate task to verify merged behavior.

## Pass-State Consistency

Keep pass state coherent with dependencies.

- Keep child tasks `passes: false` when upstream dependencies remain unverified for that same scope.
- Keep previously validated tasks untouched unless new evidence invalidates them.
- Split scope instead of flipping a broad task from true to false.

## Validation Commands

Run dependency graph validation:

```bash
python "$HOME/.agents/skills/p4rd/scripts/validate_task_dependencies.py" .agents/PLAN.md
```

Run this with strict order enforcement when preparing a clean topological plan:

```bash
python "$HOME/.agents/skills/p4rd/scripts/validate_task_dependencies.py" .agents/PLAN.md --strict-order
```
