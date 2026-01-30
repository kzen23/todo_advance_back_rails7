# Tech Stack

## Core
- **Ruby**: 3.2.0
- **Rails**: 7.1.0
- **Database**: MySQL 8.0

## Key Gems
- **puma**: Web server
- **mysql2**: MySQL database adapter
- **jbuilder**: JSON API builder
- **rack-cors**: CORS support for API
- **pry-rails**: Enhanced Rails console

## Development & Testing
- **rspec-rails**: 4.0.0 - Testing framework
- **rubocop**: Code linter
- **rubocop-rails**: Rails-specific linting rules
- **debug**: Debugging tool
- **capybara**, **selenium-webdriver**, **webdrivers**: System testing

## Frontend Libraries (minimal)
- **importmap-rails**: JavaScript with ESM import maps
- **turbo-rails**: Hotwire SPA-like page accelerator
- **stimulus-rails**: Hotwire JavaScript framework

## Environment
- **Docker**: Development environment uses Docker Compose
  - MySQL 8.0 container (port 3307)
  - Rails web container (port 3001)
- **Platform**: Windows (MINGW64_NT)
