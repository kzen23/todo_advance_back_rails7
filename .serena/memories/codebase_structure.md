# Codebase Structure

## Directory Structure

```
todo_advance_back_rails7/
├── app/
│   ├── assets/          # Static assets (CSS, images)
│   ├── channels/        # Action Cable channels
│   ├── controllers/     # API controllers
│   │   ├── concerns/
│   │   ├── application_controller.rb
│   │   ├── genres_controller.rb
│   │   └── tasks_controller.rb
│   ├── helpers/         # View helpers
│   ├── javascript/      # JavaScript files
│   ├── jobs/           # Background jobs
│   ├── mailers/        # Email mailers
│   ├── models/         # Domain models
│   │   ├── concerns/
│   │   ├── application_record.rb
│   │   ├── genre.rb
│   │   └── task.rb
│   ├── services/       # Service objects (business logic)
│   │   ├── tasks/
│   │   │   ├── create_service.rb
│   │   │   └── duplicate_service.rb
│   │   └── service_result.rb
│   └── views/          # View templates
├── bin/                # Executables
├── config/             # Configuration files
│   ├── routes.rb       # API routes
│   ├── database.yml    # Database configuration
│   └── ...
├── db/                 # Database files
│   ├── migrate/        # Database migrations
│   └── schema.rb       # Database schema
├── spec/               # RSpec tests
│   ├── models/         # Model tests
│   ├── requests/       # Request/API tests
│   ├── services/       # Service object tests
│   ├── rails_helper.rb
│   └── spec_helper.rb
├── log/                # Application logs
├── public/             # Public static files
├── tmp/                # Temporary files
├── vendor/             # Third-party code
├── .rubocop.yml        # RuboCop configuration
├── .rspec              # RSpec configuration
├── Gemfile             # Ruby dependencies
├── docker-compose.yml  # Docker configuration
├── Dockerfile          # Docker image definition
└── claude.md           # Project instructions for Claude AI
```

## API Routes

```ruby
# Tasks API
POST   /tasks              # Create task
GET    /tasks              # List all tasks
GET    /tasks/:id          # Show task
PATCH  /tasks/:id          # Update task
DELETE /tasks/:id          # Delete task
POST   /tasks/:id/status   # Update task status
POST   /tasks/:id/duplicate # Duplicate task

# Genres API
POST   /genres             # Create genre
GET    /genres             # List all genres
GET    /genres/:id         # Show genre
PATCH  /genres/:id         # Update genre
DELETE /genres/:id         # Delete genre
```

## Layer Responsibilities

### Models (`app/models/`)
- Domain logic
- Associations and validations
- Scopes and queries
- Business rules

### Controllers (`app/controllers/`)
- HTTP request/response handling
- Parameter parsing
- Delegate to services
- Render JSON responses
- **Should be thin** - business logic goes in services

### Services (`app/services/`)
- Complex business logic
- Multi-step operations
- External API calls
- Return ServiceResult objects
- Naming: `Module::VerbService` (e.g., `Tasks::CreateService`)

### Concerns (`app/models/concerns/`, `app/controllers/concerns/`)
- Shared behavior across models or controllers
- Example: `Duplicatable` concern for task duplication

## Testing Structure (`spec/`)
- `models/` - Unit tests for models
- `requests/` - Integration tests for API endpoints
- `services/` - Unit tests for service objects
- Test coverage should be comprehensive
- Follow TDD principles
