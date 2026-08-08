# Session Summary: Fix Ansible INJECT_FACTS_AS_VARS Deprecation

**Date**: 2026-08-08
**Duration**: ~20 minutes
**Conversation Turns**: ~3 touching this repo
**Estimated Cost**: low (grep/sed sweep + check-mode validation)
**Model**: claude-opus-4-8

## Key Actions

- A `--tags homedir,dotfiles,claude,vale` deploy surfaced `INJECT_FACTS_AS_VARS` deprecation warnings (ansible-core 2.24 will stop auto-injecting gathered facts as top-level `ansible_*` vars). Converted all 69 bare injected-fact references across the ansible tree to the `ansible_facts['...']` form: `ansible_user_dir`, `ansible_os_family`, `ansible_system`, `ansible_architecture` in group_vars/all.yml, setup.yml, obsidian.yml, packages.yml, tailscale.yml, vale.yml.
- Left magic variables (`ansible_run_tags`, `ansible_check_mode`) untouched: they are always-injected runtime vars, not gathered facts, so the deprecation does not apply. Verified their 43 occurrences were unchanged by the sweep.
- Validated: `--syntax-check` passes; a `--check` run (no file writes) shows `failed=0`, no INJECT_FACTS_AS_VARS warning, and facts still resolve.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "address those deprecation warnings" | 69-ref fact conversion, validated | This commit |
| "did claude-plugins clobber something" | Diagnosed: no; ansible claude task dropped 2 cosmetic settings keys | Reported separately |

## Efficiency Insights

**What went well:**
- Word-boundary sed scoped to the four fact names plus a magic-var count guard meant one sweep with no false positives (the count of run_tags/check_mode was identical before and after).
- Validated in `--check` mode so re-running the playbook could not re-clobber `~/.claude/settings.json`.

**What could improve:**
- The settings.json deploy hazard (repo copy overwrites live, dropping machine-local keys) bit again this session. It is a separate design fix, tracked as a recommendation, not bundled here.

## Process Improvements

- When converting injected facts, distinguish gathered facts (subject to INJECT_FACTS_AS_VARS) from magic vars (`ansible_check_mode`, `ansible_run_tags`, `ansible_play_hosts`); only the former change.

## Observations

- The `Install ~/.claude/settings.json from repo` copy task has no `backup: yes`, so the pre-deploy live file is unrecoverable after a clobber. Two live-only keys (`theme`, `skipWorkflowUsageWarning`) were lost this run.

## Suggested Skills for Next Session

- none (ansible/yaml mechanical work)
