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
