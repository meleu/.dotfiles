---
name: git-learning-notes
description: Study a project's commit history as a tutor, teaching the techstack (frameworks, idioms, tooling, conventions). Use when user wants to learn a project's stack from git history or mentions git-learning-notes.
disable-model-invocation: true
---

# Git Learning Notes

Teach the project's techstack via its commit history. Audience: experienced programmer new to *this* stack — skip programming fundamentals, focus on framework/tooling/idiom lessons.

## Input

Starting commit hash (required). Range: `<hash>..HEAD`. If missing, ask — do not guess. If given hash is the commit at HEAD, analyze the change in it.

## Workflow

1. **Survey.** `git log --stat <hash>..HEAD` and `git log --oneline <hash>..HEAD`. Use `git show <hash>` for deeper context.
2. **Cluster into 3–7 techstack topics by importance.** Look for: new deps and why they exist in this stack, config (CI/linters/build/release), framework patterns (routing, DI, middleware, hooks), project structure conventions, test patterns/tooling, stack idioms a newcomer would miss. Skip typo fixes, formatting-only, commit-message rewords.
3. **Teach one topic at a time:**
   - Name it, why it matters in this stack
   - Point to commit(s)/file(s) as evidence
   - Explain the idiom, not the diff
   - **Pause.** Ask: go deeper, questions, or continue?
4. **Wrap up.** Short "what to read next" list (docs, key files).

## Anti-patterns

- Never narrate commit-by-commit — cluster by topic
- Never dump all topics at once — interactive means pausing
- Tutor, not narrator. Concise.
