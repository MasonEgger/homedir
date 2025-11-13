## Fix excessive test generation in app-dev commands

Refactored custom Claude Code commands to prevent AI from writing needless tests for framework and library code. The previous configuration incentivized testing everything (including Django, pytest, and other frameworks) instead of focusing on application-specific logic.

### Root Cause
The original commands had three main issues:
1. Rigid requirement for "100% test coverage" created perverse incentive to test trivial/framework code
2. No guidance on what NOT to test (frameworks, libraries, trivial code)
3. Missing concrete examples distinguishing good tests (application logic) from bad tests (framework verification)

### Changes Made

**.claude/CLAUDE.md:**
- Replaced "NO EXCEPTIONS POLICY" with nuanced "TESTING POLICY"
- Added explicit requirements to focus on YOUR application logic, not framework behavior
- Added DO NOT list for frameworks, libraries, trivial code, configuration files
- Added guiding question: "Am I testing MY code's logic, or verifying that a library/framework works?"

**plan.md:**
- Added "Testing Guidelines for Generated Prompts" section with explicit DO/DO NOT lists
- Added concrete examples of GOOD vs BAD tests in the RED-GREEN-REFACTOR template
- Changed "Verify 100% test coverage" to "Verify meaningful test coverage of YOUR application logic"

**execute-plan.md:**
- Added guidance to focus tests on application logic, not framework functionality
- Added instruction to skip testing trivial code, framework features, or library behavior
- Changed coverage verification from "100% test coverage" to "all application logic is tested"

**brainstorm.md:**
- Updated TDD focus to emphasize "YOUR application logic" over generic "test scenarios"
- Added explicit mention of business rules, validation, error handling as focus areas
- Clarified not to test framework or library behavior

**setup-python-proj.md:**
- Removed "Ensure 100% test coverage" requirement
- Changed to "write tests to verify `main.py`'s application logic"

### Expected Impact
AI will now write tests that verify custom business logic, validation rules, and application-specific behavior instead of testing whether Django can create models or whether pytest works correctly.
