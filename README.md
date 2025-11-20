# Real Estate Building Management Platform

A full-stack Rails + React application for managing commercial real estate buildings with dynamic, client-specific custom fields.

## 🏗️ Architecture Overview

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
npm install

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

**Quick Examples:**

```bash
# List all buildings
curl http://localhost:3000/api/v1/buildings

# Create a building
curl -X POST http://localhost:3000/api/v1/buildings \
  -H "Content-Type: application/json" \
  -d '{
    "building": {
      "client_id": 1,
      "address": "123 Main St",
      "city": "Boston",
      "state": "MA",
      "zip_code": "02101",
      "custom_fields": {
        "square_footage": "5000",
        "year_built": "1990"
      }
    }
  }'

# Update a building
curl -X PATCH http://localhost:3000/api/v1/buildings/1 \
  -H "Content-Type: application/json" \
  -d '{
    "building": {
      "custom_fields": {
        "square_footage": "5500"
      }
    }
  }'
```

## 🗄️ Database Schema

```
Clients (5 seeded)
├── Buildings (17 seeded)
│   └── CustomFieldValues (43 seeded)
└── CustomFieldDefinitions (15 seeded)
```

**Custom Field Types:**
- **Number**: Numeric values (e.g., square footage, year built)
- **Freeform**: Text strings (e.g., description, special features)
- **Enum**: Predefined choices (e.g., property type, condition)

## ✅ Testing

**50 passing tests** covering:
- Model validations and associations
- Service layer business logic
- API endpoints and error handling
- Custom field type validation

```bash
# Run all tests
bundle exec rspec

# Run specific test suites
bundle exec rspec spec/models
bundle exec rspec spec/requests
bundle exec rspec spec/services
```

## 🔑 Key Features

### Backend
- ✅ RESTful API with proper HTTP status codes
- ✅ Dynamic custom fields per client
- ✅ Comprehensive error handling
- ✅ N+1 query prevention (eager loading)
- ✅ Caching for performance
- ✅ Database indexes for scalability
- ✅ Service layer for business logic
- ✅ 50 RSpec tests

### Frontend (TODO)
- [ ] Building list with cards
- [ ] Create/Edit building forms
- [ ] Dynamic custom field rendering
- [ ] API integration with hooks
- [ ] Form validation

## 📁 Project Structure

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

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails 7.2.1
- **Database**: PostgreSQL
- **Frontend**: React + esbuild
- **Testing**: RSpec
- **Performance**: Kaminari (pagination), Bullet (N+1 detection)

## 📊 Performance Optimizations

1. **Eager Loading**: Prevents N+1 queries
2. **Caching**: Client data cached (1 hour TTL)
3. **Pagination**: 20 items per page default
4. **Indexes**: Composite indexes on frequently queried fields
5. **Bullet Gem**: Development N+1 query alerts

## 🔒 Security Notes

- No authentication (per requirements)
- CSRF protection disabled for API endpoints
- SQL injection protected via ActiveRecord
- Mass assignment protected via strong parameters
- Server-side validation on all inputs

## 🚦 Production Readiness Checklist

Backend (Complete):
- [x] Database schema with proper indexes
- [x] API endpoints with error handling
- [x] Validation and business logic
- [x] Comprehensive test coverage
- [x] Documentation

Frontend (In Progress):
- [ ] React components
- [ ] API integration
- [ ] Form handling
- [ ] Error handling

## 📝 Requirements

See [REQUIREMENTS.md](REQUIREMENTS.md) for the original specification.

## 🤝 Contributing

This is a take-home assessment project. See commit history for implementation timeline.

