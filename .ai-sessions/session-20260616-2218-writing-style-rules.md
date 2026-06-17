# Session Summary: Anti-AI writing style rules

**Date**: 2026-06-16
**Duration**: ~2.5 hours
**Conversation Turns**: ~14
**Estimated Cost**: ~$8-12 (Opus, web fetch, skill-reviewer subagent, multiple Vale debug cycles)
**Model**: claude-opus-4-7

## Key Actions

- Investigated why the existing per-project em-dash memory wasn't firing on slidev work (answer: per-project auto-memory doesn't propagate across projects; the previous memory only existed in two of Mason's project dirs).
- Designed a three-layer anti-AI-writing architecture: (1) global hard rules in `~/.claude/CLAUDE.md`, (2) full taxonomy in `~/.claude/rules/writing-style.md` (path-gated via `paths:` frontmatter), (3) deterministic Vale rules in `~/Code/vale-styles/styles/MasonBase/`. Rejected adding a skill on top because skills trigger on intent and that's exactly what failed Mason on slidev.
- Pulled the full Wikipedia "Signs of AI writing" taxonomy and filtered out Wikipedia-specific items (wikitext, AFC drafts, citation templates) for Mason's blog/slides/docs context.
- Wrote `.claude/rules/writing-style.md` (~280 lines, single-file inline taxonomy) covering vocabulary tells (current + earlier era), syntax tells, structure tells, tone tells, meta patterns, a quick self-check, and a human-writing contrast section.
- Added "Writing Voice" section to `.claude/CLAUDE.md` with universal hard rules (em-dash ban, top ~28 banned phrases, parallelism ban, canned preamble ban, promotional voice ban, vague attribution ban). Scrubbed 5 existing em-dashes from the file so it stopped contradicting itself.
- Updated the rules-currently-loaded comment to include `python` (already in repo) and `writing-style` (new).
- Ran the plugin-dev:skill-reviewer agent against the rule file + Vale rules + CLAUDE.md. Reviewer flagged 5 critical issues, 6 strong suggestions, 7 nits, 10 coverage gaps. Applied all 5 criticals + 3 strong suggestions; logged the rest.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| "When are writing skills invoked? Slidev never triggers them, always emdashes. Should I make a 'writing' rules thing in homedir?" | Surveyed skills, found em-dash rule lives in per-project memory only; confirmed `~/.claude/CLAUDE.md` is right home. | Answered yes; clarified skill vs CLAUDE.md vs rules tradeoffs. |
| "Write a whole anti-ai set of rules or skills based on Wikipedia. Ultrathink." | Fetched the article, designed 3-layer architecture, asked one scope question. | Approved: all 3 layers + scrub CLAUDE.md em-dashes, single-file inline taxonomy. |
| (approved scope) | Wrote `~/.claude/rules/writing-style.md`, updated `~/.claude/CLAUDE.md`, wrote 9 Vale rules in MasonBase. Smoke-tested. | All rules firing; 8 errors / 32 warnings on AI-flavored test doc. |
| "Use /skill-creator:skill-reviewer to do a full review. Run evals." | Launched plugin-dev:skill-reviewer agent. Added Vale regression fixtures (`ai-tells-bad.md`, `ai-tells-good.md`) + 20 new assertions to `tests/run.sh`. | Reviewer report applied (C1-C5 + S1/S4/S6); fixtures green at 33 passed / 0 failed. |
| "Fix it, commit both PRs." | Discovered ~/.claude not a git repo; was redirected to `~/Code/MasonEgger/homedir/`. Saved a reference memory so future sessions don't repeat. | Branched off main in homedir, propagated edits, this commit. |

## Efficiency Insights

**What went well:**
- Asking one focused architecture question (AskUserQuestion with scope + layout choices) avoided spinning on design.
- Smoke-testing each Vale rule against a known-bad doc before declaring done caught the `raw:` vs `tokens:` issue (multi-pattern `raw:` fails silently).
- The skill-reviewer agent caught real bugs the smoke test missed: the AIParallelism regex matched only single-token right-hand sides; would have missed ~80% of real cases.

**What could improve:**
- Edited `~/.claude/CLAUDE.md` directly instead of editing the homedir repo source. There is an existing lesson on exactly this (2026-05-24) and a memory was saved on the same topic; missed both. Solution applied: saved a more specific reference memory in this session.
- First pass on Vale rules used `raw:` with multiple list items; took two debug cycles to figure out it must be `tokens:` for multi-pattern. The existing `ThereIs.yml` could have made this obvious if read more carefully first.
- The first AIParallelism regex was tight enough to pass the smoke test but loose enough to miss most real cases. Need realistic-bad fixtures, not just "any bad words" smoke tests.

**Course corrections:**
- Switched all multi-pattern Vale rules from `raw:` to `tokens:` after a minimal reproducer showed the silent-failure.
- After reviewer feedback, loosened the AIParallelism regex from `[\w\-]+` (single-word right side) to `[^.!?,\n]{1,50}?` (phrase-bounded). 5/5 catches, 0 false positives in re-test.
- Demoted CannedPreambles and AIParallelism from `level: error` to `warning` since both have edge cases that could block CI on legitimate writing.

## Process Improvements

- For dotfile changes (anything that maps into `~/.claude/`, `~/.zshrc`, etc.), check `~/Code/MasonEgger/homedir/` first; never edit the deployed copy. The lesson and reference memory both exist now; next session should not repeat the mistake.
- When adding any family of Vale rules to MasonBase, also add good/bad fixtures under `tests/fixtures/<family>-{bad,good}.md` and the matching assertions in `tests/run.sh`. The fixture system IS the eval harness for this layer.
- For Vale `existence` rules with multiple patterns: use `tokens:` (each entry is a separate regex). Use `raw:` only for a single pattern, which can OR-alternate internally.
- When writing rules that ban words/phrases: prefer `level: warning` over `level: error` until the rule has been run against a corpus of the user's own writing. Errors block CI; false positives in publishing-mode rules are common.

## Observations

- The architecture call (rules + Vale over a skill) was driven by Mason's specific failure mode (skills don't trigger reliably on slidev). The "skill is the right thing for everything" reflex would have produced a worse outcome here.
- Plugin-dev:skill-reviewer remains the highest-leverage review tool we have; its findings paid for the agent dispatch many times over.
- The Vale fixture+run.sh pattern that already existed in this user's vale-styles repo was a clean eval harness to extend. Existing test infrastructure beat anything I would have stood up from scratch.
- The Wikipedia "Signs of AI writing" article is a stronger reference than I expected; its taxonomy maps cleanly to actionable Vale rules with one-step filtering for the Wikipedia-only items.

## Suggested Skills for Next Session

- `python:python`: only if next step touches the ansible playbooks or any helper scripts.
- `productivity:vault-routing`: if writing-style coverage is extended to vault routing for blog drafts.
- `content-design:validated-pattern-writing` or `content-design:tutorial-writing`: if next step audits an existing draft against the new rules.
