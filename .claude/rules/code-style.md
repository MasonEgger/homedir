---
paths:
  - "**/*.py"
  - "**/*.js"
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.go"
  - "**/*.rs"
  - "**/*.rb"
  - "**/*.java"
  - "**/*.c"
  - "**/*.cc"
  - "**/*.cpp"
  - "**/*.h"
  - "**/*.hpp"
  - "**/*.sh"
  - "**/*.zsh"
  - "**/*.bash"
  - "**/*.yml"
  - "**/*.yaml"
  - "**/*test*"
  - "**/test*/**"
  - "**/tests/**"
  - "**/conftest.py"
---

## Skill Precedence

If a skill claims the domain, use the skill; these rules are the fallback until every domain has one.
Python work loads the `python` skill via `python.md` in this directory, and that skill's files are the source of truth for all Python standards, the compiled taste profile included.
Never restate a skill-owned rule here; a restated rule drifts (the dead CLI-TDD exemption survived in this file after the skill removed it).
The cross-language principles below apply wherever no skill overrides them.

## Writing Code

- Follow TDD (tests first, minimal code to pass, refactor); for scope, the python skill's `tdd-workflow.md` is canonical and is not restated here.
- Prefer simple, clean, maintainable solutions over clever ones. Readability is primary.
- Realize that sometimes the best solution is to remove, not to add.
- Always adhere to best practices for the given language/tool you are writing.
- Make the smallest reasonable changes. Ask permission before reimplementing systems from scratch.
- Match the style of surrounding code. Consistency within a file beats external standards.
- NEVER make unrelated changes. Document them and ask instead of fixing immediately.
- NEVER remove code comments unless they are actively false.
- All code files should start with a brief 2-line comment explaining what the file does. Only the first line starts with "ABOUTME: " (grep-friendly).
- Comments should be evergreen - describe code as it is, not how it evolved.
- NEVER name things 'improved', 'new', or 'enhanced'. Names should be evergreen.

### Clean Code

- Single Responsibility: Each function/module should have one clear purpose. Don't lump unrelated logic together.
- Naming: Use descriptive names. Avoid generic names like `tmp`, `data`, `handleStuff`. For example, prefer `calculateInvoiceTotal` over `doCalc`.
- DRY Principle: Do not duplicate code. If similar logic exists in two places, refactor into a shared function (or clarify why both need their own implementation).
- Comments: Explain non-obvious logic, but don't over-comment self-explanatory code. Remove any leftover debug or commented-out code.

## Error Handling

- Trust internal code. Don't wrap everything in try/catch "just in case."
- Validate at system boundaries: user input, external APIs, file I/O, network calls.
- Fail fast and loud. Let errors propagate rather than silently swallowing them.
- Use specific exception types, not generic catches. Handle what you can recover from, let the rest bubble up.
- Don't add fallbacks or defaults for scenarios that shouldn't happen - if it happens, we want to know.

## Testing

- Tests MUST cover the functionality being implemented.
- NEVER ignore test output - logs often contain CRITICAL information.
- Test YOUR application logic, not frameworks/libraries.
- DO NOT test trivial code (getters, setters, simple assignments).
- Test behavior and outcomes, not implementation details.
- When uncertain: "Am I testing MY code's logic, or verifying that a library works?"
