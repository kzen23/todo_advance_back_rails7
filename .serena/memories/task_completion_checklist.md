# Task Completion Checklist

When completing a task, ensure ALL of the following criteria are met:

## 1. Tests Pass ✓
```bash
bundle exec rspec
```
- All tests must pass
- No pending tests
- Test coverage for new functionality

## 2. RuboCop Passes ✓
```bash
bundle exec rubocop
```
- No RuboCop violations
- All style guidelines followed
- Code is clean and maintainable

## 3. Rails Application Works ✓
```bash
rails s
# OR
docker-compose up
```
- Application starts without errors
- New features work as expected
- No breaking changes to existing functionality

## 4. Code Review Checklist
- [ ] Follows SOLID principles
- [ ] Single Responsibility Principle applied
- [ ] No code duplication (DRY)
- [ ] Service objects used for complex business logic
- [ ] Fat Model, Skinny Controller pattern followed
- [ ] Proper error handling implemented
- [ ] Edge cases considered

## 5. TDD Cycle Completed
- [ ] Red: Test written first and fails
- [ ] Green: Minimal code to make test pass
- [ ] Refactor: Code cleaned up and optimized

## 6. Documentation (if needed)
- [ ] Complex logic has inline comments
- [ ] README updated if public API changed
- [ ] Migration notes added if schema changed

## Workflow Summary
1. Write failing test (Red)
2. Write minimal code to pass (Green)
3. Refactor code (Refactor)
4. Run `bundle exec rspec` - must pass
5. Run `bundle exec rubocop` - must pass
6. Test manually in running application
7. Commit changes

## User Approval Required
**CRITICAL**: All tasks require explicit user approval before committing. Never proceed without user consent.
