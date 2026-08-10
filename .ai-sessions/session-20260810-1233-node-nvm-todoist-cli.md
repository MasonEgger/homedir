# Session Summary: Node via nvm and Todoist CLI Setup

**Date**: 2026-08-10
**Duration**: ~50 minutes
**Conversation Turns**: ~12 touching this repo
**Estimated Cost**: medium (multi-file ansible refactor + live install/verify)
**Model**: claude-opus-4-8

## Key Actions

- Diagnosed why `td` (the `@doist/todoist-cli` "Todoist CLI") was absent despite the ansible role claiming to install it: `npm` was missing (apt ships `nodejs` without `npm`), the install guard `command -v td` false-positived against the `td=tmux detach` shell alias, and apt's node 18 is too old for the CLI (needs node >=24, which surfaced as EBADENGINE then EACCES on the root-owned npm prefix).
- Moved Node off apt onto nvm (Node LTS, v24). Dropped `nodejs`/`npm` from `apt_packages`; macOS still gets a current node from the brew `node` package.
- Reworked `tasks/user-tools.yml`: added an "ensure nvm + Node LTS" step (current + target user), routed the Todoist CLI and pnpm installs through nvm (its prefix is user-writable, so no sudo and no prefix override), and changed the Todoist guard to `npm ls -g --depth=0 @doist/todoist-cli` so the `td` alias can no longer skip the install.
- Put nvm interactive sourcing in `~/.zshrc.local` (OS-specific, never clobbered by the `.zshrc` copy) via a marked blockinfile, not the cross-OS tracked `.zshrc`. Moved the `tasks/obsidian.yml` nvm-sourcing block to `.zshrc.local` too (same marker/content), so both tags manage it identically.
- Ran `--tags user-tools` live: clean (`failed=0`), CLI installed under nvm node 24.19.0 / npm 11.17.0, `todo --version` = 3.1.7 in a login shell.
- Documented the headless auth path in `ansible/README.md`: the CLI's default keyring store fails on a headless box (`AUTH_STORE_WRITE_FAILED`), so authenticate with `--credential-store plaintext`. Verified reads afterward (`td auth status`, `td today`, `td project list` all return live data).

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "should the Todoist CLI be installed per the ansible config?" | Traced user-tools.yml, found npm-missing + td-alias guard bugs | This commit |
| "add npm and fix the guard" | Added npm to apt, switched guard to `npm ls -g` | Superseded by nvm move |
| "don't install node from system packages, use official path" | Removed apt node/npm, routed everything through nvm | This commit |
| ".zshrc must be accurate across all OS; OS-specific goes in .zshrc.local" | Put nvm sourcing in `.zshrc.local`, not tracked `.zshrc` | This commit |
| "fix the OAuth callback" / "did plaintext" | Delivered local callback; diagnosed keyring; documented `--credential-store plaintext` | Auth working |
| "move obsidian's nvm sourcing to .zshrc.local too" | Repointed the obsidian blockinfile | This commit |

## Efficiency Insights

**What went well:**
- Running `--tags user-tools` live proved the whole chain (nvm install, CLI install, auth, reads) instead of trusting syntax-check alone.

**What could improve:**
- Two early fixes (add `npm` to apt, `~/.local` npm prefix) were thrown away once the real constraint (node >=24) surfaced. Checking the package's `engines` field first would have gone straight to nvm.

## Process Improvements

- nvm install logic now lives in both `user-tools.yml` and `obsidian.yml` (guarded, idempotent, same marker) so each tag is self-sufficient. If a third consumer appears, extract it into a shared `tasks/nvm.yml` included by setup.yml.

## Observations

- The interactive `td` binary resolves only when nvm's node is active, which is why sourcing nvm in `.zshrc.local` is required for `todo` (aliased to `command td`) to work.

## Suggested Skills for Next Session

- none (ansible/shell work)
