# Session Summary: Plugin Scope Hygiene

**Date**: 2026-09-20
**Model**: claude-fable-5

## Key Actions

- Root-caused why claude-plugins reported stale versions (productivity 0.23.0 era) while updates succeeded: 12 project-scope install records, pinned to this repo since 2026-08-23, shadowed the user-scope versions in `claude plugin list`, and the script's parser kept whichever record came last.
- The records came from this repo's checked-in .claude/settings.json enabledPlugins block; removed it entirely (bpe included) since everything is installed globally at user scope.
- Uninstalled all 12 project-scope records via `claude plugin uninstall --scope project`; zero remain.
- Script hardening: installed_versions() is now scope-aware (user records only), install and update pass --scope user explicitly, and a new audit_scopes() warns after every sync if any non-user-scope record exists, with the exact uninstall command per stray.
- Deployed to ~/.homedir/ and verified a live run from $HOME: every version reports current, no scope warnings.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "Why the hell are there project scope? ... fix everything about this" | Records purged, settings cleaned, script hardened | PR opened |

## Observations

- The official plugins (frontend-design, plugin-dev, skill-creator) now report pinned commit versions; their user-scope records were shadowed by Version: unknown project records before.
