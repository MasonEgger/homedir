## Markdown Writing

These rules apply whenever writing any Markdown content — documentation, README files,
GitHub commit messages, PR descriptions, issue bodies, or any other prose output.

### Diagrams

- **NEVER use ASCII diagrams.** No box-and-arrow art, no ASCII flowcharts, no text-based
  tables-as-diagrams, no Unicode box-drawing characters used to represent structure.
- **Always use Mermaid** for any diagram, chart, or visual representation of structure,
  flow, or relationships. Wrap all diagrams in a fenced code block with the `mermaid` language tag:

  ````markdown
  ```mermaid
  flowchart TD
      A[Start] --> B[End]
  ```
  ````

- Applies everywhere: inline in docs, PR descriptions, commit message bodies, issue comments,
  architecture diagrams, sequence diagrams, ER diagrams, Gantt charts — all of it.
