---
name: github-issue-workflow
description: End-to-end workflow for resolving GitHub issues with the gh CLI as an agentic coding assistant. Use when asked to pick up, work on, fix, or close a GitHub issue, or to turn an issue into a PR — covers triage, branching, feeding issue context into the coding task, committing with issue links, opening the PR via gh, handling review feedback, and cleanup.
---

# GitHub issue workflow

Use `gh` to pull structured issue/PR data *into* context at each step below,
rather than paraphrasing from memory or a screenshot. The point of the loop
is that every step that touches GitHub state goes through `gh`, so nothing
drifts from the source of truth.

## 1. Triage

`gh issue list --label bug --state open` (adjust label/milestone/assignee
filters as needed) to see what's actually open before picking work.

## 2. Read full context before writing any code

`gh issue view <number> --comments` — get the original description *and*
the discussion thread. Repro steps, scope changes, and "actually don't do
X" corrections often live in comments, not the issue body.

## 3. Branch named after the issue

`git checkout -b fix/<number>-short-description` (or `feat/`, matching repo
convention). Keeps the branch traceable back to the issue without needing a
separate lookup later.

## 4. Feed the issue into the coding task

Pull structured data rather than hand-summarizing:
`gh issue view <number> --json title,body,comments`. Paste that (or the
issue URL) as the actual task input so the requirements are exact, not a
paraphrase that quietly drops a constraint.

## 5. Implement

Explore the relevant code before editing it. Make the change, then run the
project's real test suite/linters — don't declare done on the diff alone.

## 6. Review the diff before committing

`git diff`, or run `/code-review` for a second pass on correctness and
simplification. Catching issues here is cheaper than catching them in PR
review.

## 7. Commit with an issue link

Include `Fixes #<number>` (full resolution) or `Refs #<number>` (partial/
related) in the commit message, so GitHub can auto-link and, on merge,
auto-close.

## 8. Open the PR via `gh`

`gh pr create --title "..." --body "Fixes #<number> ..."`. Keep the body
focused on *why*, plus a test-plan checklist — not a restatement of the
diff.

## 9. Pull review feedback back through `gh`, not by hand

`gh pr view --comments` or `gh api repos/<owner>/<repo>/pulls/<number>/comments`
to get reviewer comments verbatim into context for follow-up fixes, rather
than re-explaining the feedback secondhand.

## 10. Merge and confirm closure

`gh pr merge --squash --delete-branch` (match team convention on squash vs.
merge vs. rebase). The `Fixes #<number>` link auto-closes the issue on
merge — verify with `gh issue view <number>` if it matters that it actually
closed (e.g. it won't auto-close across repos, or if the closing keyword
was in a non-default branch PR).

## 11. Cleanup

`--delete-branch` on the merge command handles this automatically; if
merged manually, delete the local and remote branch explicitly.
