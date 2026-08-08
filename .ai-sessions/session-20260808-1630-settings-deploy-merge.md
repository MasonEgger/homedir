# Session Summary: Deep-Merge settings.json on Deploy

**Date**: 2026-08-08
**Duration**: ~25 minutes
**Conversation Turns**: ~3 touching this repo
**Estimated Cost**: low (one task rewrite + check-mode validation)
**Model**: claude-opus-4-8

## Key Actions

- The ansible `claude` task installed `~/.claude/settings.json` with a wholesale `copy` overwrite, dropping any machine-local key on every deploy (this session it lost `theme` and `skipWorkflowUsageWarning`) and reverting the live `model` choice to the repo's `claude-fable-5[1m]` pin.
- Replaced the single copy task with a three-task merge: slurp the live file (tolerating absence), extract a defined set of machine-local keys from it, and write `repo_baseline | combine(machine_local_overlay)` via `to_nice_json`. The overlay wins for machine-local keys, so `model` and friends are preserved; the repo still supplies them as bootstrap defaults on a fresh machine.
- Machine-local key set: `model`, `theme`, `skipWorkflowUsageWarning`, `enabledPlugins`, `extraKnownMarketplaces` (the last two are owned by the claude-plugins script, not the repo).
- Added `backup: true` and updated the file header comment, which had claimed settings.json was a pure overwrite.
- Validated with `--syntax-check` and a `--check --diff` run (no writes): the would-write output keeps `model: claude-opus-4-8` (not reverted to fable) and live's 14 enabledPlugins including `document-skills`, while repo-managed keys (env, permissions, includeCoAuthoredBy, skipAutoPermissionPrompt) come from the repo. `failed=0`.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "switch the task to deep-merge repo-managed keys; will it overwrite model?" | Built model as machine-local (live wins); validated preservation | This commit |

## Efficiency Insights

**What went well:**
- `--check --diff` proved the merge output end-to-end (model preserved, plugins preserved) without writing to the live file, so no re-clobber risk during validation.

**What could improve:**
- `to_nice_json` sorts keys, and Claude Code writes its own order, so a deploy will report `changed` and write a backup even when values are unchanged. Cosmetic churn; accepted for now.

## Process Improvements

- A plain deep-merge does not protect a diverged key by itself; precedence decides. Machine-local keys must explicitly win over the repo, which means lifting them from live and layering them on top of the repo baseline.

## Observations

- The design also fixes the silent `/model` revert the user had been fighting: model is now machine-local, so the repo pin only applies as a fresh-machine default.

## Suggested Skills for Next Session

- none (ansible/jinja work)
