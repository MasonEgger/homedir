---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

## Python Core Requirements

1. **Type hints everywhere** - all functions, all parameters, all return types. No `Any`.
2. **Docstrings on all public interfaces** - RST format for Sphinx compatibility.
3. **Absolute imports only** - never use relative imports.
4. **Modern Python idioms** - use latest features appropriate for target version.
5. **Empty `__init__.py`** - never add anything to `__init__.py`.
6. **Descriptive variable names** - single-letter names (`i`, `j`, `k`, `m`, `x`, etc.) are NEVER allowed. Use names that convey meaning: `line_index`, `inner_index`, `label_match`.
7. **`X | None` over `Optional[X]`** - for projects targeting Python 3.10+, use PEP 604 union syntax (`str | None`) instead of `typing.Optional[str]`. Ruff UP007 enforces this.
