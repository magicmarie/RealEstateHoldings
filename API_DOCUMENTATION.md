# API Documentation

## Base URL
```
http://localhost:3000/api/v1
```

## Authentication
No authentication required (per requirements).

## Endpoints

### Buildings

#### List All Buildings
```http
GET /buildings
```

**Query Parameters:**
- `page` (optional): Page number for pagination (default: 1)
- `per_page` (optional): Items per page (default: 20)

**Response:**
```json
{
  "buildings": [
    {
      "id": 1,
      "client_id": 1,
      "client_name": "ABC Real Estate",
      "address": "123 Main St",
      "city": "Boston",
      "state": "MA",
      "zip_code": "02101",
      "custom_fields": {
        "square_footage": "5000",
        "year_built": "1990",
        "property_type": "Commercial"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 100,
    "per_page": 20
  }
}
```

#### Get Single Building
```http
GET /buildings/:id
```

**Response:**
```json
{
  "id": 1,
  "client_id": 1,
  "client_name": "ABC Real Estate",
  "address": "123 Main St",
  "city": "Boston",
  "state": "MA",
  "zip_code": "02101",
  "custom_fields": {
    "square_footage": "5000"
  }
}
```

**Error Response (404):**
```json
{
  "error": "Client or building not found"
}
```

#### Create Building
```http
POST /buildings
```

**Request Body:**
```json
{
  "building": {
    "client_id": 1,
    "address": "456 Oak Ave",
    "city": "Cambridge",
    "state": "MA",
    "zip_code": "02139",
    "custom_fields": {
      "square_footage": "3000",
      "year_built": "2005"
    }
  }
}
```

**Success Response (201):**
```json
{
  "id": 2,
  "client_id": 1,
  "client_name": "ABC Real Estate",
  "address": "456 Oak Ave",
  "city": "Cambridge",
  "state": "MA",
  "zip_code": "02139",
  "custom_fields": {
    "square_footage": "3000",
    "year_built": "2005"
  }
}
```

**Error Response (404):**
```json
{
  "error": "Client or building not found"
}
```

**Error Response (422):**
```json
{
  "errors": [
    "Address can't be blank",
    "State must be 2-letter state code"
  ]
}
```

#### Update Building
```http
PATCH /buildings/:id
PUT /buildings/:id
```

**Request Body:**
```json
{
  "building": {
    "address": "457 Oak Ave",
    "custom_fields": {
      "square_footage": "3500"
    }
  }
}
```

**Success Response (200):**
```json
{
  "id": 2,
  "client_id": 1,
  "client_name": "ABC Real Estate",
  "address": "457 Oak Ave",
  "city": "Cambridge",
  "state": "MA",
  "zip_code": "02139",
  "custom_fields": {
    "square_footage": "3500",
    "year_built": "2005"
  }
}
```

### Clients

#### List All Clients
```http
GET /clients
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "ABC Real Estate",
    "custom_field_definitions": [
      {
        "id": 1,
        "field_name": "square_footage",
        "field_type": "number",
        "enum_options": null
      },
      {
        "id": 2,
        "field_name": "property_type",
        "field_type": "enum_type",
        "enum_options": ["Commercial", "Residential", "Mixed Use"]
      }
    ]
  }
]
```

#### Get Single Client
```http
GET /clients/:id
```

**Response:**
```json
{
  "id": 1,
  "name": "ABC Real Estate",
  "custom_field_definitions": [
    {
      "id": 1,
      "field_name": "square_footage",
      "field_type": "number",
      "enum_options": null
    }
  ]
}
```

## Custom Field Types

### Number
- Accepts numeric values (integers or decimals)
- Example: `"2.5"`, `"1000"`
- Validation: Must be a valid number

### Freeform
- Accepts any string value
- Example: `"Blue"`, `"Historic building"`
- No special validation

### Enum
- Accepts one value from a predefined list
- Example: `"Commercial"` (where options are `["Commercial", "Residential"]`)
- Validation: Must be one of the allowed enum options

## Error Codes

- `200 OK`: Successful GET/PUT/PATCH request
- `201 Created`: Successful POST request
- `404 Not Found`: Resource not found (client or building)
- `422 Unprocessable Entity`: Validation errors

## Validation Rules

### Building
- `address`: Required, max 255 characters, unique per location
- `city`: Max 100 characters
- `state`: Required, must be 2-letter US state code
- `zip_code`: Required, must be valid format (12345 or 12345-6789)
- `client_id`: Required, must reference existing client

### Custom Fields
- Must match field type (number, freeform, or enum)
- Enum values must be from allowed options
- Unknown field names are ignored

## Performance Considerations

- Responses use eager loading to prevent N+1 queries
- Clients list is cached for 1 hour
- Pagination recommended for large datasets
- Database indexes on frequently queried fields
