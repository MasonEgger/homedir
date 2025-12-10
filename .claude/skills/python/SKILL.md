---
name: python
description: Python development standards and toolchain preferences. Use when (1) writing ANY Python code, (2) setting up Python projects with pyproject.toml, (3) creating standalone CLI scripts, (4) configuring Python tooling (ruff, mypy, pytest, nox, uv), (5) reviewing or refactoring Python code, or (6) advising on Python best practices. Enforces modern Pythonic style, strict type hints, and uv-based workflows.
---

# Python Development Standards

## Before Writing Any Code

**For applications and multi-file projects:** Read [references/tdd-workflow.md](references/tdd-workflow.md) first. Follow TDD with mandatory verification after every change.

**For CLI scripts and one-off utilities:** Skip TDD workflow. Focus on working code.

## Core Requirements

1. **Type hints everywhere** - all functions, all parameters, all return types. No `Any`.
2. **Docstrings on all public interfaces** - RST format for Sphinx compatibility
3. **Absolute imports only** - never use relative imports
4. **Modern Python idioms** - use latest features appropriate for target version
5. **Empty `__init__.py`** - never add anything to `__init__.py`

## Reference Files

Read based on task:

- [references/toolchain.md](references/toolchain.md) - Project setup and tool configuration (uv, ruff, mypy, pytest, nox, just)
- [references/cli-scripts.md](references/cli-scripts.md) - CLI tool development
- [references/documentation.md](references/documentation.md) - Docstring and doctest patterns
