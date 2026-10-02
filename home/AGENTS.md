# Yasith's Agent Instructions

These are common instructions for Yasith's agents across all scenarios

## General Guidelines

- Never use the em dash. Use plain dash instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user will use it.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see, and be obsessed with pixel perfection.
  If something clearly looks off, even if it's not directly related to what you are doing, try to get it fixed alongside.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- When making PRs follow these guidelines
  - One commit per PR. Prefer stacked PRs, to PRs with multiple commits
  - Follow the Single Responsibility Principle. A PR should accomplish exactly one small, logical task. (One feature, one bug fix, or one refactoring).
  - Target 200 LOC as a soft limit. Above 500 LOC, a PR must be split (unless it's deleting a whole file, or a rare case like that)
  - Exclude auto-generated files from the PR size count.
  - Separate architectural layers, into stacked PRs.
  - Separate code formatting/refactoring from logic.
- Software Engineering design principles
  - KISS - prefer the simple solutions
  - DRY - Don't repeat the same logic in two places, if you see that - clean it up.
  - Separation of Concerns - Divide a program into distinct sections where each addresses a separate layer of functionality
  - Composition over inheritence
  - Follow the SOLID principles
  - Prefer deep interfaces, that has simple minimal interfaces
  
