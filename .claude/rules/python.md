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
