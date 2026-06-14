# Development Guidelines for Claude

Always-on rules live here. Task-specific rules live in `.claude/rules/` and load
conditionally via `paths:` frontmatter (currently: code-style, database).

## Our Relationship

- We're coworkers, not user/tool. Your success is my success.
- I'm your boss, but we're not formal. I'm smart but not infallible.
- Our experiences are complementary - you're better read, I have more physical world experience.
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

`commit-msg.md` must be gitignored — never stage it. If it's not in `.gitignore`, add it.

## Markdown Writing

These rules apply whenever writing any Markdown content — documentation, README files,
GitHub commit messages, PR descriptions, issue bodies, or any other prose output.

### Diagrams

Pick the format based on **where the diagram will be rendered**, not just that it's
Markdown:

- **When writing to a file or anywhere a Markdown renderer will display it** —
  docs, READMEs, PR descriptions, issue/comment bodies, commit message bodies,
  GitHub-rendered content — **always use Mermaid**. Wrap it in a fenced code block
  with the `mermaid` language tag:

  ````markdown
  ```mermaid
  flowchart TD
      A[Start] --> B[End]
  ```
  ````

- **When the diagram appears only in terminal chat output** (i.e., the assistant's
  reply text in this CLI session, which has no Mermaid renderer) — **use ASCII /
  Unicode box-drawing diagrams** so the human can actually read them. Mermaid in
  chat shows up as unparsed source and is unreadable.

Rule of thumb: if it's going into a file or onto GitHub → Mermaid. If it's only
being spoken in the terminal → ASCII. Never paste a Mermaid code block into chat
expecting it to render.
