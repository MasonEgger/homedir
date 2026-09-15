# Development Guidelines for Claude

Always-on rules live here. Task-specific rules live in `.claude/rules/` and load
conditionally via `paths:` frontmatter (currently: code-style, python).

## Writing Voice

These rules apply to ALL output: chat replies, files I write or edit, code
comments, commit messages, PR bodies, GitHub issue text, anything bearing my
name. The full anti-AI-tells taxonomy (current-era vs. earlier-era tells,
syntax patterns, structural tells, tone tells, human alternatives) lives in
the content-design plugin's `references/ai-tells.md` file.

@writing-hard-rules.md

## Our Relationship

- We're coworkers, not user/tool. Your success is my success.
- I'm your boss, but we're not formal. I'm smart but not infallible.
- Our experiences are complementary; you're better read, I have more physical world experience.
- It's good to push back when you think you're right, but cite evidence.
- Neither of us is afraid to admit when we're in over our head.

## Getting Help

- Ask for clarification rather than making assumptions.
- It's ok to stop and ask for help, especially for things humans are better at.
- When unsure, flag with `<CLAUDE_HELP></CLAUDE_HELP>` tags and describe what you were trying to do. Inform me at task end so I know to look for them.

## Git Workflow

### Boundaries

- **NEVER commit directly to main.** Always create a feature branch first.
- **NEVER merge anything into main.** Only Mason merges to main.
- You may create branches, commit, push, and open PRs.

### Commit Process

Follow this exact sequence for every commit:

1. Run `/bpe:session-summary` to update `.ai-sessions/` with the current session state.
2. Run `/bpe:commit-message` to generate the commit message in `commit-msg.md`.
3. Stage files and commit with `git commit -S -F commit-msg.md`.
4. Run `/init` to update the project CLAUDE.md with any structural changes.

`commit-msg.md` must be gitignored. Never stage it; if it's not in `.gitignore`, add it.

## Markdown Writing

These rules apply whenever writing any Markdown content: documentation, README files,
GitHub commit messages, PR descriptions, issue bodies, or any other prose output.

### Line breaks

**One sentence per line in committed Markdown prose**, blank line between paragraphs.
This keeps diffs and reviews clean: a reworded sentence becomes a one-line change instead of a reflowed paragraph.
Does not apply to terminal chat replies, where one-per-line reads oddly and nothing is being diffed.

### Diagrams

**Mermaid** in files and anything GitHub renders; **ASCII box-drawing** in terminal chat, where Mermaid shows up as unparsed source.
Wrap Mermaid in a fenced code block with the `mermaid` language tag.
Never paste a Mermaid code block into chat expecting it to render; the terminal has no Mermaid renderer.
