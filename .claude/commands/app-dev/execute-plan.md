# Execute Plan Command

1. Read @plan.md and @todo.md
   - These files complement each other. @todo.md should track the current state of the implementation of @plan.md
2. Open @todo.md and select the first unchecked item to work on.
3. **CRITICAL**: Open @plan.md and locate the specific step being implemented
   - Find the detailed numbered prompts for this step (e.g., "1. RED: Write tests...", "2. GREEN: Implement...")
   - Follow these prompts EXACTLY in the specified order
   - Do NOT deviate from the file paths, test scenarios, or implementation approach specified
4. If you have any questions about the task at hand, ask the user.
5. Implement the plan for this item as specified in @plan.md:
   - **Follow the exact numbered sub-steps** in the plan.md prompt
   - **Use the specific file paths** mentioned in the prompts
   - **Implement the exact test scenarios** described
   - Follow strict TDD procedures (RED-GREEN-REFACTOR as specified)
   - Write robust, well-documented code
   - Focus tests on YOUR application logic, not framework functionality
   - Skip testing trivial code, framework features, or library behavior
   - Verify that all tests and linting passes
   - Make sure the tests pass, and the program builds/runs
6. **Update documentation as specified** in the plan.md prompts for this step
7. Check off the item that was completed in @todo.md
8. Ask the user if they wish to commit this change, or continue with the next item in the todo.

## Key Requirements:
- **NEVER** skip or reorder the numbered steps in plan.md
- **ALWAYS** use the exact file paths specified in the prompts
- **FOLLOW** the RED-GREEN-REFACTOR cycle as outlined in each step
- **COMPLETE** all documentation updates mentioned in the step
- **VERIFY** all application logic is tested (not framework/library code)
- Treat plan.md prompts as **implementation instructions**, not suggestions