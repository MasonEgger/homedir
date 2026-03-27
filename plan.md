# Claude Directory → Plugins Conversion Plan

## Current Inventory

Review each item and mark the **Action** column with one of:
- **plugin** — Convert to a plugin/skill
- **keep** — Leave as-is in .claude (not ready for packaging)
- **drop** — Remove (stale/unused)
- **rework** — Needs significant changes before packaging
- **merge** — Merge into another item (note which one)

### Existing Skills (already plugin-format)

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 1 | `tutorial-writing` | skills/tutorial-writing/ | Technical tutorial writing (DO style, 6 references, wordcount script) | |
| 2 | `python` | skills/python/ | Python dev standards, toolchain, TDD (4 references) | |

### Existing Agent

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 3 | `copy-editor` | agents/copy-editor.md | Vale-based style checking and copy editing | |

### Commands — app-dev

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 4 | `plan` | commands/app-dev/plan.md | Generate TDD implementation plan (plan.md + todo.md) | |
| 5 | `execute-plan` | commands/app-dev/execute-plan.md | Execute steps from plan.md following strict TDD | |
| 6 | `brainstorm` | commands/app-dev/brainstorm.md | Interactive 1-question-at-a-time spec development | |
| 7 | `find-missing-tests` | commands/app-dev/find-missing-tests.md | Audit code for missing test cases | |
| 8 | `setup-python-proj` | commands/app-dev/setup-python-proj.md | Scaffold Python project with uv, mypy, ruff | |

### Commands — git

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 9 | `plan-gh-issue` | commands/git/plan-gh-issue.md | Fetch GH issue, validate, plan fix with TDD | |
| 10 | `commit-msg` | commands/git/commit-msg.md | Generate commit message to commit-msg.md | |

### Commands — meta

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 11 | `lyra` | commands/meta/lyra.md | Prompt optimization specialist (4-D methodology) | |
| 12 | `session-summary` | commands/meta/session-summary.md | Generate .ai-sessions session summary | |

### Commands — journal

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 13 | `transcript-2-journal` | commands/journal/transcript-2-journal.md | Convert voice transcripts to Obsidian journal entries | **plugin** → productivity |
| 15 | `eod` | commands/journal/eod.md | EOD brain dump — voice transcript + Todoist sync + vault routing | **plugin** → productivity |
| 16 | `todoist-sync` | commands/journal/todoist-sync.md | Pull completed & pending Todoist tasks into journal | **plugin** → productivity |

### Commands — customers

| # | Item | Location | Description | Action |
|---|------|----------|-------------|--------|
| 14 | `discover-pain-points` | commands/customers/discover-pain-points.md | Evaluate sales discovery calls (Temporal-focused) | **plugin** → productivity |

## Open Questions

_Answers below each question._

### Q1: Plugin grouping
Once you've marked actions above, how do you want to group the "plugin" items? Options:
- **By domain** (app-dev, git, writing, etc.) — many small plugins
- **One big personal plugin** — everything in one `mason-toolkit` plugin
- **Something in between** — a few themed plugins

**Answer:**

### Q2: Where should plugins live?
- **This homedir repo** (deployed by Ansible)
- **Separate repo(s)**
- **Other**

**Answer:**

### Q3: Deployment
Should Ansible install these as proper plugins (via `claude-plugins` script or similar), or just copy them into `.claude/`?

**Answer:**

### Q4: Any items you want to rework significantly?
If you marked anything as "rework" above, describe what you'd change.

**Answer:**
