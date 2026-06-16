# Session Summary: Ansible Claude deploy — copy with stale-file cleanup

**Date**: 2026-06-13
**Duration**: Part of a multi-day BPE conversation that resolved here
**Conversation Turns**: ~3 in this segment, ~25 across the full conversation
**Estimated Cost**: ~$1 (this segment), ~$10 across the conversation
**Model**: claude-opus-4-7

## Key Actions

- Rewrote `ansible/tasks/claude.yml` to deploy the `.claude/` tracked entries by copy + stale-file cleanup. The repo is the source of truth; every deploy pushes the repo's content over live and removes any file in `~/.claude/rules/` that no longer exists in the repo source. Ad-hoc edits to live's tracked entries are intentionally transient — they get overwritten on the next deploy. Any change worth keeping goes in the repo via a commit.
- Specific playbook structure:
  - A migration step at the top detects and removes leftover symlinks at `~/.claude/{CLAUDE.md,rules,settings.json}` so subsequent copy tasks don't follow a symlink and write back into the repo. Idempotent: a no-symlink machine skips this step entirely. Self-deleting after first run on each machine that had a prior symlink-based deploy.
  - Wipes `~/.claude/rules/` before re-copying it from the repo. This is the "ensure old files are deleted" semantics — anything not present in `~/Code/MasonEgger/homedir/.claude/rules/` is removed from live every deploy. Required for the consolidation refactor that landed six file deletions.
  - Copies `CLAUDE.md`, `rules/`, and `settings.json` from repo over live. `ansible.builtin.copy` hashes before overwriting, so unchanged files report `ok` with no rewrite or mtime churn. The wipe-then-copy on `rules/` always reports `changed` for the wipe step; expected and accepted for simplicity.
  - `settings.local.json` is excluded — gitignored, per-machine.
- Took a manual snapshot (`~/.claude.pre-copy-deploy.20260613-094453/`) before the playbook run, belt-and-suspenders.
- Ran the playbook twice. First run on this machine: removed three pre-existing symlinks (from an earlier experiment), wiped rules, re-copied three entries. Second run: no symlinks, wipe reports `changed`, rules re-copy reports `changed`, `CLAUDE.md` and `settings.json` report `ok` because content hashes match. End state stable across runs.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "i dont want to deploy via symlink. i want ansible to deploy and ensure the old files are deleted." | Wrote claude.yml as copy + wipe + stale-file cleanup; ran twice for idempotency | Live system is real files; rules dir contains only repo's two files; obsolete files gone |

## Efficiency Insights

**What went well:**
- Wipe-then-copy on `rules/` is two ansible tasks total and reads cleanly. Doesn't require rsync (`synchronize delete=yes`) or any conditional logic.
- The migration step (symlink detection + removal) covers the case where a machine has a prior symlink-based deploy without requiring manual cleanup. After first run on such a machine, the step is a no-op.
- `ansible.builtin.copy`'s hash-before-write means `CLAUDE.md` and `settings.json` report `ok` on every re-run after the first deploy. Only the `rules/` wipe causes always-changed status — visible nuisance but functionally correct.

**What could improve:**
- The `rules/` always-`changed` status will surface as noise in any future deploy logs. If it starts to matter, swap the wipe-then-copy for `ansible.posix.synchronize` with `delete: yes` — that gets idempotency back but requires rsync at the cost of more setup.
- Pre-deploy manual snapshot was overkill in retrospect — the symlink-removal step on the first run is well-understood and reversible. The snapshot stays as a one-time belt for this transition; future deploys don't need it.

**Course corrections:**
- None this segment.

## Process Improvements

- For deploy strategies, identify the model up front: do live edits flow back to the repo (symlink), or does the repo overwrite live every deploy (copy)? Different mental models, different tradeoffs. The copy + cleanup model keeps the repo as the only source of truth and treats live state between deploys as ephemeral — better for machines where Claude Code may write to settings.json transiently (plugin enables, model changes) without those edits cluttering the dotfiles repo.
- When a deploy must "delete old files" (declarative state), wipe-then-copy on a directory is the simplest correct implementation in ansible. The always-changed status on the wipe step is a small price for clarity.
- For symlink → real-file migration on a single file (e.g. `settings.local.json`), `target=$(readlink path); rm path; cp "$target" path` works as a one-off bash step. Useful when the playbook can't reasonably handle migration for files outside its deploy set.

## Observations

- The "ad-hoc edits to ~/.claude/{CLAUDE.md,rules,settings.json} are lost on the next deploy" tradeoff is the design. The user wants a clean separation between the repo (intentional state, committed) and live (ephemeral state, can be wiped). Anything important goes through the repo.
- The wipe-then-copy is conceptually equivalent to "rm -rf the rules dir and re-copy" — simpler than tracking which files to delete based on a diff.
- The whole `.claude/` tree under the repo is now eight things: `CLAUDE.md`, `settings.json`, `settings.local.json` (gitignored), `rules/code-style.md`, `rules/database.md`, and three task files in the ansible tree that handle their deploy. Cleanly bounded.

## Suggested Skills for Next Session

- None specifically — next session likely pushes the branch and opens the PR.
