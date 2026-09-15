# Session Summary: Correct the SentenceLength Pre-Merge Claim (Ground Truth)

**Date**: 2026-09-15
**Duration**: minutes (orchestrator RESUME recovery)
**Model**: claude-fable-5 (parent session)

## Key Actions

- The writing-rules goal run hit its Step 8 iteration cap on one unresolved finding: the `.vale.ini.j2` comment claimed `MasonTechnical.SentenceLength` does not exist on vale-styles main and that Vale ignores the `[max] = 25` line pre-merge.
- The orchestrator settled the disputed fact directly: `git ls-tree main:styles/MasonTechnical` shows `SentenceLength.yml` present on main (hand-rolled occurrence rule), and the iter-3 validator's empirical probe showed Vale 3.21 honors the bracket param against a main checkout.
- Replaced the false sentences with the verified state: all eight rules exist hand-rolled on main and run on their own defaults; std-rebuild converts them to Std extends children; the `[max]` line is honored either way and makes the per-type cap explicit.

## Prompt Inventory

| Prompt/Command | Action Taken | Outcome |
|---|---|---|
| (goal-run RESUME after iter-cap Failure) | One comment block corrected with validator-supplied, ground-truth-verified wording | PR #38 branch accurate |

## Observations

- Two subagents asserted the same false git fact in sequence (one from a misread listing, one claiming to have verified it); the empirical test at iter 3 and the orchestrator's direct `git ls-tree` broke the echo. A validator finding is evidence, not truth.
