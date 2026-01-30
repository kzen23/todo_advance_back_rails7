# Project Overview

## Purpose
This is a **TODO application backend** built with Ruby on Rails 7.1. The application provides a REST API for managing tasks and genres.

## Main Features
- Task management with status tracking (not_started, in_progress, completed)
- Task prioritization (low, medium, high)
- Genre/Category management
- Task duplication functionality
- Task deadline tracking

## Domain Models
- **Task**: Main entity with name, explanation, status, priority, deadline, and genre association
- **Genre**: Categories for organizing tasks
- Tasks belong to a genre, and genres have many tasks (with dependent destroy)

## Architecture
- Follows Rails Way principles
- SOLID principles
- TDD (Test-Driven Development)
- Service layer pattern for business logic (e.g., Tasks::CreateService, Tasks::DuplicateService)
- Fat Model, Skinny Controller approach
