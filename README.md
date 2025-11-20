# Real Estate Building Management Platform

A full-stack Rails + React application for managing commercial real estate buildings with dynamic, client-specific custom fields.

## Architecture Overview

This application implements a multi-tenant building management system where:
- **Clients** can create and manage their buildings via API
- **External consumers** can read all buildings with pagination
- **Custom fields** allow each client to define unique building attributes dynamically

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed design decisions.

## 🚀 Quick Start

### Option 1: Local Development (Recommended for this project)

**Prerequisites:**
- Ruby 3.4.1
- PostgreSQL
- Node.js (for esbuild)

**Setup:**
```bash
# Install dependencies
bundle install
yarn install

# Setup database
cp .env.example .env  # Update DB credentials
rails db:create db:migrate db:seed

# Start server
rails s

# Run tests
bundle exec rspec
```

### Option 2: Docker

```bash
docker compose build
docker compose up

# Run specs
docker compose run web bundle exec rspec
```

Visit http://localhost:3000

## 📚 API Documentation

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete API reference.

**Custom Field Types:**
- **Number**: Numeric values (e.g., square footage, year built)
- **Freeform**: Text strings (e.g., description, special features)
- **Enum**: Predefined choices (e.g., property type, condition)

```bash
# Run all tests
bundle exec rspec
```

## Project Structure

```
app/
├── controllers/api/v1/     # API endpoints
├── models/                 # ActiveRecord models
├── serializers/            # JSON serializers
├── services/               # Business logic
└── javascript/components/  # React components

spec/
├── models/                 # Model tests
├── requests/api/v1/        # API integration tests
└── services/               # Service tests

db/
├── migrate/                # Database migrations
└── seeds.rb                # Sample data
```

## Tech Stack

- **Backend**: Ruby on Rails 7.2.1
- **Database**: PostgreSQL
- **Frontend**: React + esbuild
- **Testing**: RSpec
- **Performance**: Kaminari (pagination), Bullet (N+1 detection)
- **Testing**: RSpec with 53 passing tests

## Performance Optimizations

1. **Eager Loading**: Prevents N+1 queries
2. **Caching**: Client data cached (1 hour TTL)
3. **Pagination**: 20 items per page default
4. **Indexes**: Composite indexes on frequently queried fields
5. **Bullet Gem**: Development N+1 query alerts

## Security Notes

- No authentication (per requirements)
