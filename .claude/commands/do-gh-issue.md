1. Retrieve issue $ARGUMENTS from GitHub
2. Review the code and determine if the issue is valid.
    - Run any necessary tests to verify the issue.
    - If no tests exist to verify the issue, start by implementing the tests to prove that the issue does exist.
        - If the issue does not exist, inform the user and give a detailed explanation as to why you think so.
        - If the issue does exist, continue on.
3. Plan your approach to solve the issue carefully. Write out your plan to a file named @issue-ISSUE_NUM.md where ISSUE_NUM is the issue number.
4. Create a new branch and implement your solution:
    - Write robust, well-documented code.
    - Include thorough tests and ample debug logging.
    - Ensure all tests pass before moving on.
5. Update any relevant documentation regarding your fix.
6. Inform the user of your fix so they can manually verify, and provide them with a suggested commit message they can use.
