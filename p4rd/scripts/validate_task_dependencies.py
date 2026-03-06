#!/usr/bin/env python3
"""Validate dependency integrity for .agents/PLAN.md task JSON."""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict, deque
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

TASK_ID_RE = re.compile(r"^T-\d{3,}$")
JSON_BLOCK_RE = re.compile(r"```json\s*(.*?)```", re.IGNORECASE | re.DOTALL)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate task dependencies in .agents/PLAN.md or JSON task files."
    )
    parser.add_argument(
        "plan_path",
        nargs="?",
        default=".agents/PLAN.md",
        help="Path to PLAN markdown/json file (default: .agents/PLAN.md).",
    )
    parser.add_argument(
        "--strict-order",
        action="store_true",
        help="Fail when a task depends on later-listed tasks.",
    )
    return parser.parse_args()


def _coerce_tasks(payload: Any) -> Optional[List[Dict[str, Any]]]:
    if isinstance(payload, list) and all(isinstance(item, dict) for item in payload):
        return payload
    if isinstance(payload, dict):
        tasks = payload.get("tasks")
        if isinstance(tasks, list) and all(isinstance(item, dict) for item in tasks):
            return tasks
    return None


def load_tasks(path: Path) -> List[Dict[str, Any]]:
    text = path.read_text(encoding="utf-8")

    # Try strict JSON first.
    try:
        parsed = json.loads(text)
        tasks = _coerce_tasks(parsed)
        if tasks is not None:
            return tasks
    except json.JSONDecodeError:
        pass

    # Try JSON code blocks in markdown.
    for block in JSON_BLOCK_RE.findall(text):
        try:
            parsed = json.loads(block)
        except json.JSONDecodeError:
            continue
        tasks = _coerce_tasks(parsed)
        if tasks is not None:
            return tasks

    raise ValueError(
        "Unable to locate a valid JSON task list. "
        "Expected a top-level JSON array (or {'tasks': [...]}) or a ```json fenced block."
    )


def find_cycle(task_ids: List[str], deps_map: Dict[str, List[str]]) -> Optional[List[str]]:
    visiting: set[str] = set()
    visited: set[str] = set()
    stack: List[str] = []
    index: Dict[str, int] = {}

    def dfs(node: str) -> Optional[List[str]]:
        visiting.add(node)
        index[node] = len(stack)
        stack.append(node)
        for dep in deps_map[node]:
            if dep in visiting:
                start = index[dep]
                return stack[start:] + [dep]
            if dep not in visited:
                cycle = dfs(dep)
                if cycle:
                    return cycle
        stack.pop()
        index.pop(node, None)
        visiting.remove(node)
        visited.add(node)
        return None

    for task_id in task_ids:
        if task_id not in visited:
            cycle = dfs(task_id)
            if cycle:
                return cycle
    return None


def compute_topological_order(task_ids: List[str], deps_map: Dict[str, List[str]]) -> List[str]:
    children: Dict[str, List[str]] = defaultdict(list)
    indegree: Dict[str, int] = {task_id: 0 for task_id in task_ids}

    for task_id in task_ids:
        for dep in deps_map[task_id]:
            children[dep].append(task_id)
            indegree[task_id] += 1

    queue = deque([task_id for task_id in task_ids if indegree[task_id] == 0])
    order: List[str] = []

    while queue:
        node = queue.popleft()
        order.append(node)
        for child in children[node]:
            indegree[child] -= 1
            if indegree[child] == 0:
                queue.append(child)

    return order


def critical_path(order: List[str], deps_map: Dict[str, List[str]]) -> List[str]:
    if not order:
        return []

    score: Dict[str, int] = {}
    parent: Dict[str, Optional[str]] = {}

    for task_id in order:
        deps = deps_map[task_id]
        if not deps:
            score[task_id] = 1
            parent[task_id] = None
            continue

        best_dep = max(deps, key=lambda dep: score.get(dep, 1))
        score[task_id] = score.get(best_dep, 1) + 1
        parent[task_id] = best_dep

    end = max(order, key=lambda task_id: score.get(task_id, 1))
    path: List[str] = []
    cursor: Optional[str] = end
    while cursor is not None:
        path.append(cursor)
        cursor = parent.get(cursor)

    path.reverse()
    return path


def validate(tasks: List[Dict[str, Any]], strict_order: bool) -> Tuple[List[str], List[str]]:
    errors: List[str] = []
    warnings: List[str] = []

    if not tasks:
        errors.append("Task list is empty.")
        return errors, warnings

    ids: List[str] = []
    id_to_task: Dict[str, Dict[str, Any]] = {}
    id_to_index: Dict[str, int] = {}

    for idx, task in enumerate(tasks):
        task_id = task.get("id")
        if not isinstance(task_id, str):
            errors.append(f"Task at index {idx} has missing or non-string 'id'.")
            continue
        if not TASK_ID_RE.match(task_id):
            errors.append(f"{task_id}: invalid ID format (expected T-###...).")
        if task_id in id_to_task:
            errors.append(f"{task_id}: duplicate task ID.")
            continue
        ids.append(task_id)
        id_to_task[task_id] = task
        id_to_index[task_id] = idx

    deps_map: Dict[str, List[str]] = {}

    for task_id in ids:
        task = id_to_task[task_id]
        deps = task.get("depends_on")
        if not isinstance(deps, list):
            errors.append(f"{task_id}: missing or non-array 'depends_on'.")
            deps_map[task_id] = []
            continue

        normalized: List[str] = []
        seen: set[str] = set()
        for dep in deps:
            if not isinstance(dep, str):
                errors.append(f"{task_id}: dependency value must be string, got {dep!r}.")
                continue
            if dep == task_id:
                errors.append(f"{task_id}: self-dependency is not allowed.")
                continue
            if dep in seen:
                errors.append(f"{task_id}: duplicate dependency '{dep}'.")
                continue
            seen.add(dep)
            normalized.append(dep)

        deps_map[task_id] = normalized

    for task_id, deps in deps_map.items():
        for dep in deps:
            if dep not in id_to_task:
                errors.append(f"{task_id}: unknown dependency '{dep}'.")
                continue
            if strict_order and id_to_index[dep] > id_to_index[task_id]:
                errors.append(
                    f"{task_id}: dependency '{dep}' appears later in list; keep topological order."
                )
            if not strict_order and id_to_index[dep] > id_to_index[task_id]:
                warnings.append(
                    f"{task_id}: dependency '{dep}' appears later in list."
                )

    cycle = find_cycle(ids, deps_map)
    if cycle:
        errors.append("Cycle detected: " + " -> ".join(cycle))

    for task_id, task in id_to_task.items():
        if task.get("passes") is True:
            blocked = [dep for dep in deps_map.get(task_id, []) if id_to_task.get(dep, {}).get("passes") is False]
            if blocked:
                warnings.append(
                    f"{task_id}: passes=true while dependencies are unverified: {', '.join(blocked)}."
                )

    return errors, warnings


def main() -> int:
    args = parse_args()
    plan_path = Path(args.plan_path)
    if not plan_path.exists():
        print(f"ERROR: file not found: {plan_path}", file=sys.stderr)
        return 1

    try:
        tasks = load_tasks(plan_path)
    except ValueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    except OSError as exc:
        print(f"ERROR: failed to read {plan_path}: {exc}", file=sys.stderr)
        return 1

    errors, warnings = validate(tasks, strict_order=args.strict_order)

    if errors:
        print("Dependency validation failed:")
        for error in errors:
            print(f"- {error}")
        if warnings:
            print("Warnings:")
            for warning in warnings:
                print(f"- {warning}")
        return 1

    ids = [task["id"] for task in tasks if isinstance(task.get("id"), str)]
    deps_map = {
        task["id"]: [dep for dep in task.get("depends_on", []) if isinstance(dep, str)]
        for task in tasks
        if isinstance(task.get("id"), str)
    }
    order = compute_topological_order(ids, deps_map)
    path = critical_path(order, deps_map)
    edge_count = sum(len(deps) for deps in deps_map.values())

    print(
        f"Dependency validation passed for {len(ids)} tasks and {edge_count} dependency edges."
    )
    if path:
        print(f"Estimated critical path ({len(path)} tasks): {' -> '.join(path)}")
    if warnings:
        print("Warnings:")
        for warning in warnings:
            print(f"- {warning}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
