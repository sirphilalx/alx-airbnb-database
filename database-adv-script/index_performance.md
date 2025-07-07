## 1. High-Usage Columns Identification

### Users Table

- Primary Key: user_id (already indexed)

- High-usage columns:

  - email (frequent WHERE clauses for login/lookup)

  - last_name (common in ORDER BY clauses)

- created_at (often used in date range filters)

### Bookings Table

- Primary Key: booking_id (already indexed)

- High-usage columns:

  - user_id (foreign key for JOINs)

  - property_id (foreign key for JOINs)

  - start_date (common in WHERE clauses for date ranges)

  - end_date (used with start_date in availability checks)

  - status (frequent filtering by booking status)

### Properties Table

- Primary Key: property_id (already indexed)

- High-usage columns:

  - host_id (foreign key to Users table)

  - property_type (common filtering criteria)

  - price_per_night (range queries for price filters)

  - location (geospatial queries)

  - rating (sorting and filtering)

## 2. SQL Index Creation Commands (database_index.sql)

```sql
-- Users Table Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_last_name ON users(last_name);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Bookings Table Indexes
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_dates ON bookings(start_date, end_date);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Properties Table Indexes
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_type ON properties(property_type);
CREATE INDEX idx_properties_price ON properties(price_per_night);
CREATE INDEX idx_properties_rating ON properties(rating);

-- Composite Index for common search patterns
CREATE INDEX idx_properties_search ON properties(property_type, price_per_night, rating);
```

## 3. Performance Measurement Examples

### Before Indexing

```sql
EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE user_id = 123 AND status = 'confirmed';
```

### After Indexing

```sql
EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE user_id = 123 AND status = 'confirmed';
```
