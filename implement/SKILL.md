---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the complete working-tree change against
the agreed fixed point. Verify each finding against the live source, address
confirmed issues, and rerun the relevant validation.

Commit only when the user requested a commit or the enclosing workflow
explicitly grants commit/shipping authority. Stage only files owned by this
task, preserve unrelated worktree changes, and report the resulting commit.

When implementation came from a tracker ticket and the user or enclosing
workflow authorized tracker updates, mark that ticket complete only after the
agreed delivery is validated (and committed/pushed when those were part of the
delivery): check its acceptance criteria, set a local ticket to `Status: done`
or close the hosted issue using the configured tracker workflow. Never close a
parent issue. If update authority or a required delivery step is missing, leave
the ticket open and report exactly what remains.
