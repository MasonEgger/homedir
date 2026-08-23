# Session Summary: user-tools Idempotency and Re-run Fixes

**Date**: 2026-08-23
**Duration**: ~45 minutes
**Conversation Turns**: ~1
**Estimated Cost**: medium (one droplet, four playbook runs, one local run)
**Model**: claude-fable-5

## Key Actions

- Made every task in `user-tools.yml` report `changed` only when it installs something, verified by a second `--tags new-user` run on a fresh droplet (user-tools all `ok`) and a local `--tags user-tools` run (`changed=0`).
- Root causes, each confirmed on the droplet or locally:
  - Oh My Zsh: `creates` skipped the script but `changed_when: true` still reported a change. Dropped the override.
  - Claude CLI: the guard stat'd `~/.claude/local/bin/claude`, which the installer never creates; it symlinks `~/.local/bin/claude`. The CLI was being reinstalled on every run, on this machine too.
  - nvm/Node: `nvm which --lts` is not a valid invocation in nvm 0.40.1 (`which` takes a version; the alias is `lts/*`), so the guard always failed and `nvm install --lts` ran every pass. Now `nvm which "lts/*"` plus an `NVM_CHANGED` stdout marker driving `changed_when`.
  - Todoist and pnpm checks ran as the Ansible user (root) with `$HOME=/root`, never seeing the target user's nvm. `NVM_DIR` now points at `target_home`.
- Found and fixed a re-run blocker: after `user.yml` runs `chage -d 0`, every `su - USER` task fails with "Authentication token manipulation error" because su's PAM account stack enforces the expiry. Swapped `su -` for `runuser -l` in `user-tools.yml` and `claude.yml`; `/etc/pam.d/runuser` has no account stack. The old `mmegger` flow had the same problem on any second run.
- `claude.yml` still reports four changes per run: the rules wipe-and-recopy (by design) and the plugin script (bare command, no `changed_when`). Left alone; noted on the PR.
- Droplet `homedir-test-idem` and the temporary DO key destroyed.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "fix the user-tools changed-every-run idempotency too" | Read the file, fixed five guards, swapped su for runuser, verified on droplet and locally | Third commit on PR #37 |

## Efficiency Insights

**What went well:**
- Running the playbook twice on a fresh droplet and grepping `^changed` gave an exact list of offenders each iteration.

**What could improve:**
- The paste-joined TASK/status output misaligns after an `include_tasks` line (no status line), which made me misread which local task had changed. Use `--diff` or read the raw log for anything ambiguous.

**Course corrections:**
- None.

## Process Improvements

- When a shell task has a guard, test the guard command by hand as the target user before trusting `changed_when`. Three of the five bugs were guards that could never succeed.

## Observations

- `su` vs `runuser` matters on Debian only through PAM: `/etc/pam.d/su` includes `common-account` (expiry enforced), `/etc/pam.d/runuser` does not.

## Suggested Skills for Next Session

- None specific.
