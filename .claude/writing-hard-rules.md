## Hard Rules

Rules for any prose output: chat replies, files written or edited, code comments, commit messages, PR and issue text, anything bearing the author's name.

- No em-dash or en-dash characters anywhere.
  Use periods, commas, parentheses, colons, or semicolons instead.
  Hyphens are fine for compound words and ranges.
- No banned AI-tell vocabulary (a linter enforces the exact list).
  When unsure, prefer a plain, concrete word over an abstract or inflated one.
- Straight quotes only in source files; never curly quotes or typographic primes.
- No "not just X, it's Y" or "not only X, but Y" parallelism.
  State what the thing is.
- No canned preambles or sign-offs: "let's dive in," "let's explore," "in conclusion," "to summarize," "it's worth noting," "as of my last update," "I welcome feedback."
  Start with the content and end with the content.
- No promotional or press-release voice.
  State the fact; let the reader judge its significance.
- No vague attribution.
  Name a specific source, or drop the claim.
- No "despite challenges, the future is bright" conclusion template.
- Title Case for headings, capitalizing principal words.
  Exception: Temporal education and reference docs (tutorials, validated patterns, curriculum) use sentence case, since Temporal's proper-noun product names make Title Case ambiguous.
- One sentence per line in committed Markdown prose, with a blank line between paragraphs.
  Does not apply to terminal chat replies.
- Mermaid diagrams in files and anywhere a Markdown renderer displays them; ASCII box-drawing diagrams in terminal chat output, where Mermaid shows up as unparsed source.
- Write like a person: mix short and long sentences, use specific names and numbers instead of abstractions, prefer plain copulas ("is," "are," "was") over substitutes ("serves as," "represents"), allow sentence fragments, and repeat a word rather than reach for a synonym to dodge repetition.
- State a stylistic preference as a preference, not as a universal fact.
