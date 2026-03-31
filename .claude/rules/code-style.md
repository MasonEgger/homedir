## Writing Code

- Always follow a Test Driven Development Mindset
  - Write tests first, then minimal code to pass, then refactor. Repeat for each feature/bugfix.
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
