# Suggested Commands

## Testing
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/task_spec.rb

# Run specific test line
bundle exec rspec spec/models/task_spec.rb:10
```

## Linting & Code Quality
```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix RuboCop violations
bundle exec rubocop -a

# Auto-fix unsafe corrections too
bundle exec rubocop -A
```

## Rails Server
```bash
# Start Rails server (local)
rails s

# Start with specific port
rails s -p 3001

# Note: In Docker environment, use docker-compose
docker-compose up
```

## Rails Console
```bash
# Start Rails console
rails c

# Start console in sandbox mode (rollback all changes on exit)
rails console --sandbox
```

## Database
```bash
# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Reset database (drop, create, migrate, seed)
rails db:reset

# Create database
rails db:create

# Seed database
rails db:seed

# Check migration status
rails db:migrate:status
```

## Docker Commands (Development Environment)
```bash
# Start all services
docker-compose up

# Start in detached mode
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f web

# Execute command in web container
docker-compose exec web bash
docker-compose exec web rails c
docker-compose exec web bundle exec rspec
```

## Windows-Specific Utility Commands
```bash
# List files (Git Bash / MINGW64)
ls -la

# Change directory
cd /c/Users/kn022/todo_advance_back_rails7

# Find files
find . -name "*.rb"

# Search in files (grep)
grep -r "search_term" app/

# View file contents
cat app/models/task.rb
```

## Git Commands
```bash
# Check status
git status

# Create and checkout new branch
git checkout -b feature/issue-123

# Stage changes
git add .

# Commit changes
git commit -m "commit message"

# Push to remote
git push origin branch-name
```
