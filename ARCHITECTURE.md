# Backend Architecture

## Overview
This Rails API backend manages a multi-tenant building management system with dynamic custom fields per client.

## Key Design Decisions

### 1. Service Layer Pattern
**Why:** Separates business logic from controllers, making code more testable and maintainable.

**Implementation:**
- `BuildingService` handles create/update operations with custom fields
- Validates client existence before building operations
- Manages transactions for atomic operations
- Centralizes error handling

**Benefits:**
- Controllers stay thin (SRP)
- Business logic is reusable
- Easier to test in isolation
- Clear separation of concerns

### 2. Polymorphic Custom Fields
**Why:** Support dynamic, client-specific fields without schema changes.

**Implementation:**
- `CustomFieldDefinition`: Defines field schema per client
- `CustomFieldValue`: Stores actual values with type validation
- Three field types: number, freeform, enum_type

**Benefits:**
- No schema migrations for new fields
- Client isolation (fields are client-scoped)
- Type safety with custom validations
- Flexible and extensible

### 3. ActiveModel Serializers
**Why:** Consistent, clean JSON responses without exposing internal structure.

**Implementation:**
- `BuildingSerializer`: Returns flattened custom_fields hash
- `ClientSerializer`: Includes nested field definitions
- Avoids exposing internal IDs and timestamps unnecessarily

**Benefits:**
- API contract stays stable even if models change
- Clean, predictable JSON structure
- Easy to version if needed

### 4. Eager Loading & N+1 Prevention
**Why:** Performance optimization to avoid database query explosions.

**Implementation:**
```ruby
Building.includes(:client, :custom_field_values, client: :custom_field_definitions)
```

**Benefits:**
- Single query instead of N+1
- Bullet gem monitors for violations
- Fast response times even with large datasets

### 5. Caching Strategy
**Why:** Reduce database load for frequently accessed, rarely changed data.

**Implementation:**
- Clients list cached for 1 hour
- Auto-invalidation via `ClientCacheable` concern
- Simple Rails.cache for MVP

**Benefits:**
- Faster API responses
- Reduced database queries
- Easy to swap cache backend (Redis, Memcached)

### 6. Error Handling
**Why:** Clear, actionable error messages for API consumers.

**Implementation:**
- `rescue_from ActiveRecord::RecordNotFound` → 404
- `rescue_from ActiveRecord::RecordInvalid` → 422
- Validation errors return full messages array
- Service layer catches and translates exceptions

**Benefits:**
- Consistent error format
- Helpful debugging information
- Proper HTTP status codes

### 7. Database Indexes
**Why:** Optimize query performance on foreign keys and lookups.

**Implementation:**
- Composite index on `custom_field_values(building_id, custom_field_definition_id)`
- Foreign key indexes on all belongs_to relationships
- Unique indexes for business constraints

**Benefits:**
- Fast lookups and joins
- Enforced data integrity
- Scalable for large datasets

## Data Model

```
┌─────────────┐
│   Client    │
│             │
│ - name      │
└─────┬───────┘
      │
      │ has_many
      │
      ├──────────────────────┬─────────────────────────┐
      │                      │                         │
      ▼                      ▼                         ▼
┌─────────────────┐  ┌──────────────────────┐  ┌─────────────┐
│    Building     │  │CustomFieldDefinition │  │   (cached)  │
│                 │  │                      │  └─────────────┘
│ - address       │  │ - field_name         │
│ - city          │  │ - field_type         │
│ - state         │  │ - enum_options       │
│ - zip_code      │  └──────────┬───────────┘
└────────┬────────┘             │
         │                      │
         │ has_many             │
         │                      │
         ▼                      │
┌─────────────────────┐         │
│ CustomFieldValue    │◄────────┘
│                     │  belongs_to
│ - value (TEXT)      │
└─────────────────────┘
```

## Testing Strategy

### Unit Tests (Models)
- Validations and associations
- Custom validation logic
- Type conversions

### Integration Tests (Requests)
- Full HTTP request/response cycle
- API contract validation
- Error handling scenarios

### Service Tests
- Business logic isolation
- Transaction rollback behavior
- Error propagation

**Coverage:** 50 passing tests across models, services, and API endpoints.

## Performance Optimizations

1. **Eager Loading**: Prevents N+1 queries via `includes()`
2. **Caching**: Client list cached to reduce DB hits
3. **Pagination**: Kaminari for large datasets
4. **Indexes**: Foreign keys and composite indexes for fast lookups
5. **Bullet Gem**: Development-time N+1 detection

## Security Considerations

1. **No Authentication**: Per requirements (would add JWT/OAuth in production)
2. **CSRF Protection**: Disabled for API with `null_session`
3. **SQL Injection**: Protected by ActiveRecord parameterization
4. **Mass Assignment**: Strong parameters in controllers
5. **Validation**: Server-side validation prevents invalid data

## Scalability Considerations

1. **Horizontal Scaling**: Stateless API can run on multiple servers
2. **Database**: PostgreSQL supports read replicas for scaling reads
3. **Caching**: Redis can replace Rails.cache for distributed caching
4. **Background Jobs**: Service layer ready for async processing (Sidekiq)
5. **API Versioning**: Namespaced under `/api/v1` for future versions

## Future Improvements

1. **GraphQL**: More flexible querying for complex UIs
2. **WebSockets**: Real-time updates for collaborative editing
3. **Audit Logging**: Track changes to buildings/custom fields
4. **Soft Deletes**: `paranoia` gem for data recovery
5. **Search**: Elasticsearch for full-text search on addresses
6. **File Uploads**: ActiveStorage for building images
7. **API Rate Limiting**: Rack::Attack for DoS protection
8. **Monitoring**: NewRelic/Datadog for performance tracking
