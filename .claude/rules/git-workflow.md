## Git Workflow

### Boundaries

- **NEVER commit directly to main.** Always create a feature branch first.
- **NEVER merge anything into main.** Only Mason merges to main.
- You may create branches, commit, push, and open PRs.

### Commit Process

Follow this exact sequence for every commit:

1. Run `/bpe:session-summary` to update `.ai-sessions/` with the current session state.
2. Run `/bpe:commit-message` to generate the commit message in `commit-msg.md`.
3. Stage files and commit with `git commit -S -F commit-msg.md`.
4. Run `/init` to update the project CLAUDE.md with any structural changes.

`commit-msg.md` must be gitignored — never stage it. If it's not in `.gitignore`, add it.
