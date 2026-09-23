# Session: Disable the Claude Session Link in Commits and PRs

- **Date**: 2026-09-23
- **Duration**: ~10 minutes (tail of a longer plugin-private session)
- **Conversation turns**: 2 in this repo's scope
- **Estimated cost**: minimal (config edit)
- **Model**: Fable 5

## Key Actions

- Identified the setting behind the `Claude-Session:` commit trailer and the session URL appended to PR descriptions: `attribution.sessionUrl` in Claude Code's settings.json (the existing `includeCoAuthoredBy: false` covers only the Co-Authored-By trailer, not the session link).
- Set `"attribution": {"sessionUrl": false}` in the repo source at `.claude/settings.json`, next to `includeCoAuthoredBy`.
- Applied the same edit to the live `~/.claude/settings.json` for immediate effect; the repo copy makes it survive ansible deploys, since `attribution` is not in claude.yml's machine-local preserved-keys list.
- Validated both files parse with `jq`.

## Prompt Inventory

| Prompt | Action | Outcome |
| --- | --- | --- |
| "why do you always add a link to the Claude session to the pr? I don't want that and I think there's a global setting" | Located `attribution.sessionUrl`, edited repo + live settings.json | Setting off; PR opened for the repo copy |

## Efficiency Insights

- The `update-config` skill's schema dump named the exact key (`attribution.sessionUrl`) on the first pass; no trial and error against the live client.

## Process Improvements

- Any settings.json key Mason wants durable must land in this repo's `.claude/settings.json`, never only in the live file: claude.yml preserves just model, theme, skipWorkflowUsageWarning, enabledPlugins, and extraKnownMarketplaces across deploys.

## Observations

- The setting took effect in the running session immediately after the live-file edit (the harness swapped its attribution instruction mid-session).
