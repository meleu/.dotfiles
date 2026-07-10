---
name: do-work-rails
description: "Execute a discrete unit of work in end-to-end: plan, implement, validate via rubocop and the full test suite, then commit. Use when the user asks to do work, implement, build, fix, or ship a task in this project, or implement a phase from a given plan."
---

# do-work

A unit of work in this repo follows the following phases (do not skip phases, do not reorder them):

## 0. Understand the task

- Read any referenced plan or PRD.
- Explore the codebase to understand the relevant files, patterns, and conventions.
- If the task is non-trivial or ambiguous, ask the user to clarify scope before proceeding.
- Restate the task in one sentence so the goal is explicit.

## 1. Plan (optional)

If the task has not already been planned, create a plan for it.

## 2. Implement

- Work through the plan step by step.
- Add tests alongside the code change.

## 3. Feedback loops

Run both checks and fix every issue they report. Do not commit with failures.

```
bundle exec rubocop -a
bin/rails test:all
```

## 4. Commit

Once both loops are green, commit the work.
