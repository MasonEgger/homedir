# Session Summary: Guard the Metacognition Plugin to Dev Boxes

**Date**: 2026-09-23
**Duration**: one focused change to the claude-plugins sync script
**Model**: claude-fable-5

## Key Actions

- Added a machine gate to `.homedir/claude-plugins` for the new metacognition plugin (merged to the private marketplace today as PR #66 there): it is the guarded private taste-extraction factory and must never land on the work machine.
- The gate is `is_work_machine()`, currently `platform.system() == "Darwin"` per Mason's ruling that "is it a Mac" is the work-machine test for now; the comment flags revisiting if a Mac ever becomes a dev box.
- Mechanism: a `DEV_ONLY_PLUGINS` list joins `PLUGINS` through `active_plugins()` on non-Macs; on a Mac the same entries join the stale-removal pass instead, so a guarded plugin that ever leaks onto the work machine is uninstalled on the next sync, and the report prints an explicit skipped line there.
- No ansible change needed: both invocation paths (`claude.yml` current-user sync and fresh-install) run this script, so the gate covers them.
- Verified: ruff and mypy --strict clean; both platform branches simulated via a monkeypatched `platform.system` (dev box 15 plugins with metacognition, Mac 14 without); live run on this dev box installed metacognition 2026.09.21 from the marketplace.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "It should only install on my dev box... if it's a Mac don't install" | DEV_ONLY_PLUGINS + Darwin gate + Mac-side cleanup | Verified both branches, live-installed on dev |

## Observations

- The uninstall-on-Mac half was not requested but matches the guarding intent: skip-only would leave a manually installed copy in place forever; the sync now actively enforces the boundary.
- Loading the extensionless uv script for testing needs `SourceFileLoader` explicitly; `spec_from_file_location` returns no loader without a recognized extension.

## Suggested Skills for Next Session

- python:python for any further sync-script work.
