# Session Summary: Live Test of the new-user Flow on Ubuntu 24.04

**Date**: 2026-08-23
**Duration**: ~60 minutes
**Conversation Turns**: ~3
**Estimated Cost**: medium (five playbook runs on a droplet, four fixes)
**Model**: claude-fable-5

## Key Actions

- Confirmed `doctl` is authed (`default` context, mason@masonegger.com, active).
- Imported this host's ed25519 key to DigitalOcean and created `homedir-test-newuser` (Ubuntu 24.04, `s-2vcpu-2gb`, nyc3, tag `homedir-test`). Snap-confined `doctl` cannot read `~/.ssh`, so the pubkey was copied to `~/key-tmp.pub` for the import.
- Installed Ansible from the PPA plus `ansible.posix`, cloned PR #37's branch, and ran `--tags new-user -e new_user_name=alice` five times. Each run surfaced one bug; the fifth was clean (`ok=62 failed=0`).
- Verified alice afterward with `runuser -u alice -- bash -lc`: sudo+docker groups, root key copied, ed25519 generated, sshd `PasswordAuthentication no`, `chage` forced, Claude Code 2.1.241, uv 0.12.5, nvm Node 24.19, Todoist CLI 3.3.0, 9 plugins across 6 marketplaces, global pre-commit hook, Vale 3.18, SSH signing key in `.gitconfig`, `.zshrc.local` owned by alice.
- Bugs fixed (three were latent in the old `mmegger` flow too):
  - `vale.yml`: private `vale-styles` SSH clone is fatal for a fresh user with no registered key and blocked everything after it. Now `ignore_errors` when `target_user` is defined, `accept_hostkey: true`, and a warning with the re-run command.
  - `user-tools.yml`: the nvm `blockinfile` wrote `~/.zshrc.local` as root. Added owner/group/become.
  - `claude.yml` ran before `homedir.yml`, but the target-user plugin install executes `~/.homedir/claude-plugins`. Reordered in `user.yml`. The same task used `su - USER -c`, a non-interactive zsh login shell that skips `.zshrc`, so `uv` was off PATH; switched to `-s /bin/bash` with `~/.local/bin` prepended.
  - `user.yml`: `chage -d 0` guarded on `new_user_result.changed` never fires if an earlier run died after creating the user. Replaced with a `~/.ansible-user-provisioned` marker file.
- Destroyed the droplet and the temporary DO SSH key after the test.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "Is doctl authed and working?" | `doctl auth list`, `doctl account get` | Yes |
| "spin up an ubuntu 24.04 ... cheapest ... 2cpu 2gb" | Created droplet, ran the playbook until clean, fixed four bugs, verified, tore down | Second commit on PR #37 |

## Efficiency Insights

**What went well:**
- Each run pinpointed exactly one failing task with a JSON blob that `python3 -c` could parse for `cmd`/`stderr`.

**What could improve:**
- The live test should have been the first step after the build; `--check` caught nothing that mattered.
- Verifying with `su - alice` after `chage -d 0` blocked on the password prompt and burned a 10 minute timeout. `runuser -u USER -- bash -lc` avoids it.

**Course corrections:**
- Switched from editing yesterday's session summary to writing this one: the pre-commit hook only accepts a newly added `.ai-sessions/` file.

## Process Improvements

- For any change to the provisioning task files, budget a droplet run. It is about $0.03 for the hour and finds what static checks cannot.

## Observations

- The `(target user)` variants in `user-tools.yml` report `changed` on every run even when nothing is installed, so the flow is not idempotent in the Ansible sense. Preexisting, left alone.
- The private `mmegger-private-plugins` marketplace is the one of seven that did not register for alice (no GitHub key), which is expected.

## Suggested Skills for Next Session

- None specific.
