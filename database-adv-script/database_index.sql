-- =============================================
-- Users Table Indexes
-- =============================================

-- Index for email lookups (unique constraint)
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Index for name-based searches and sorting
CREATE INDEX idx_users_name_composite ON users(last_name, first_name);

-- Index for user analytics by signup date
CREATE INDEX idx_users_created_at ON users(created_at);


-- =============================================
-- Bookings Table Indexes
-- =============================================

-- Composite index for user booking history queries
CREATE INDEX idx_bookings_user_date ON bookings(user_id, start_date DESC);

-- Composite index for property booking analysis
CREATE INDEX idx_bookings_property_date ON bookings(property_id, start_date DESC);

-- Index for date range queries (availability checks)
CREATE INDEX idx_bookings_date_range ON bookings(start_date, end_date);

-- Index for booking status filtering
CREATE INDEX idx_bookings_status ON bookings(status)
WHERE status IN ('confirmed', 'pending', 'cancelled');


-- =============================================
-- Properties Table Indexes
-- =============================================

-- Index for host management queries
CREATE INDEX idx_properties_host ON properties(host_id);

-- Composite index for property search filters
CREATE INDEX idx_properties_search ON properties(property_type, price_per_night, rating DESC);

-- Index for price-based sorting and filtering
CREATE INDEX idx_properties_price ON properties(price_per_night);

-- Index for rating-based sorting
CREATE INDEX idx_properties_rating ON properties(rating DESC);

-- Partial index for active properties
CREATE INDEX idx_properties_active ON properties(property_id)
WHERE is_active = true;


-- =============================================
-- Reviews Table Indexes
-- =============================================

-- Composite index for property review analysis
CREATE INDEX idx_reviews_property_rating ON reviews(property_id, rating DESC);

-- Index for recent reviews display
CREATE INDEX idx_reviews_recent ON reviews(created_at DESC);



-- Example 1: User booking history (before index)
EXPLAIN ANALYZE 
SELECT * FROM bookings 
WHERE user_id = 456 
ORDER BY start_date DESC;

-- Example 2: Property search (before index)
EXPLAIN ANALYZE
SELECT * FROM properties
WHERE property_type = 'Apartment'
  AND price_per_night BETWEEN 50 AND 150
  AND rating >= 4.0
ORDER BY rating DESC;

-- After creating indexes, run the same queries to compare performance