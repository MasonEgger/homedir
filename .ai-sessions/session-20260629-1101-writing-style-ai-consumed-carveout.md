# Session Summary: Writing-style carve-out for AI-consumed files

**Date**: 2026-06-29
**Duration**: ~5 min sub-agent run inside a larger team-velocity-skills cleanup session
**Conversation Turns**: 1 (sub-agent dispatch)
**Estimated Cost**: ~$0.50
**Model**: claude-opus-4-7

## Key Actions

- Added a new section 8 ("Exceptions for AI-consumed instructional files") to `.claude/rules/writing-style.md`.
- The carve-out distinguishes prose-for-humans (blog posts, READMEs, PRs, commits) from prose-for-models (SKILL.md, CLAUDE.md, agent definitions, mode-instruction reference files).
- Hard prohibitions stay universal: em-dashes, banned vocabulary, promotional voice, vague attribution, "despite challenges, the future is bright" template, banned preambles and sign-offs, smart quotes.
- Relaxed for AI-consumed files: bullet+colon structured-bullet format, bold on load-bearing terms, three-part summaries, mild copula replacement when semantically loaded, synonym variation, title-case headings.
- Mirrored the change into the live `~/.claude/rules/writing-style.md` so it takes effect immediately without waiting for an ansible re-deploy.

## Why

Working on the team-velocity-skills skill exposed that strict anti-AI-tell rules were degrading the quality of files Claude itself reads. Stripping `- **Goal:** description` bullet patterns and bolded load-bearing terms from SKILL.md and mode-instruction references was making the model's job harder, not easier. The carve-out names this explicitly so future edits to instructional files don't get policed by rules meant for human-facing prose.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| Parent agent dispatch ("add section 8 to writing-style.md") | Located source in homedir repo (`~/Code/MasonEgger/homedir/.claude/rules/writing-style.md`), branched off main, appended section, mirrored to live, committed | New section 8 lands on `feat/writing-style-ai-consumed-carveout` branch; live `~/.claude/rules/writing-style.md` reflects new content |

## Files Touched

- `.claude/rules/writing-style.md` — appended section 8 (37 lines).
- Mirror copy: `~/.claude/rules/writing-style.md` (out-of-repo, synced manually post-commit).

## Follow-ups

- PR open to merge `feat/writing-style-ai-consumed-carveout` into main when Mason is ready.
- No ansible re-deploy needed for this machine (live copy already mirrored). Other machines pick up the change on next `setup.yml` run.
