# Code Style and Conventions

## Linting: RuboCop Configuration

### Ruby Version
- Target Ruby Version: 3.2
- NewCops: enabled

### String Literals
- Enforced style: **single quotes** (`'string'`)
- Also enforced in string interpolation

### Metrics
- **Method Length**: Max 20 lines
- **Block Length**: No limit for spec/ and config/
- **ABC Size**: Max 20
- **Line Length**: Max 120 characters (relaxed in config/ and spec/)

### Layout
- End of line: Disabled (to support Windows CRLF)

### Style
- **Documentation**: Disabled (no mandatory class/module documentation comments)
- **Frozen String Literal Comment**: Disabled

### Exclusions
- `bin/**/*`
- `db/schema.rb`
- `db/migrate/**/*`
- `node_modules/**/*`
- `vendor/**/*`
- `tmp/**/*`
- `log/**/*`
- `public/**/*`

## Rails-Specific
- **I18nLocaleTexts**: Disabled
- **Exit**: Allowed in specs

## Design Principles
- **SOLID principles**
- **Rails Way**
- **TDD (Test-Driven Development)**: Red -> Green -> Refactor cycle
- **Fat Model, Skinny Controller**
- **Single Responsibility Principle**: Classes and methods should have a single responsibility
- **Service Object Pattern**: Business logic extracted into service classes (e.g., Tasks::CreateService)

## Naming Conventions
- Service classes: Namespaced under module (e.g., `Tasks::CreateService`)
- Service method: `#call` for main execution
- Service results: Use `ServiceResult.success` and `ServiceResult.failure` pattern
