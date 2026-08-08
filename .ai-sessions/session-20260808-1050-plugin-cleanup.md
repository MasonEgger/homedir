# Session Summary: Drop Six Unused Claude Code Plugins

**Date**: 2026-08-08
**Duration**: short
**Model**: claude-opus-4-8

## Key Actions

- A `/doctor` pass found six plugins with zero invocations across 43 sessions over 29 days: asana, discord, playground, playwright, slack, telegram (all from `claude-plugins-official`).
- Removed them from the `claude-plugins` sync script's `PLUGINS` list and added them to `STALE_PLUGINS` so every machine uninstalls them on the next run.
- Removed the six keys from `.claude/settings.json` `enabledPlugins`.
- On this machine: removed the six from live `~/.claude/settings.json` and ran `claude plugin uninstall` for each; the `claude-plugins-official` marketplace stays registered (frontend-design, plugin-dev, skill-creator still use it).
- Kept `example-skills` (claude-api plus the doc/design skills are useful) and `obsidian` (productivity depends on it); left the user's in-flight `document-skills` addition untouched.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| /doctor then "keep example-skills, remove the others, update the homedir script" | Uninstalled 6, edited script + both settings files | Live install and source both reflect the removal |

## Observations

- The homedir script was already mid-edit adding `document-skills`; that change was preserved and my removals layered on top.
- `STALE_PLUGINS` is the convergence mechanism: other machines uninstall the six on their next `claude-plugins` run without any manual step.

## Suggested Skills for Next Session

- None.
