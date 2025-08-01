- Use `uv` for python package management
    - Don't need to use a requirements.txt
- Run `uv init $ARGUMENT` to create a new package with the approprate name
- Modify `main.py` and add the appropriate type hints
- Install `mypy` as a dev dependency and run a type check with `--strict` and enforce it. Make the changes necessary to get there.
    - Write `mypy` config to `pyproject.toml`
- Install `ruff` as a dev dependency and lint the file. Use auto correct to fix any issues then manually fix any you find after that.
    - Write any linting config options to `pyproject.toml`
- Install `pytest` and `pytest-cov`  and write a test to test `main.py`. Ensure 100% test coverage
    - Write any testing config options to `pyproject.toml`
- Create a `justfile` and add the appropriate commands for managing the project based on the tools and steps above.
- Create a CLAUDE.md capturing all the information about this repository


