-- partitioning.sql
-- Implement range partitioning on the bookings table by start_date

-- 1. Create partitioned table structure
CREATE TABLE bookings_partitioned (
    booking_id BIGSERIAL,
    user_id BIGINT NOT NULL,
    property_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (booking_id, start_date)
PARTITION BY RANGE (start_date);

-- 2. Create partitions for different time periods
-- Historical data
CREATE TABLE bookings_historical PARTITION OF bookings_partitioned
    FOR VALUES FROM (MINVALUE) TO ('2023-01-01');

-- 2023 data (quarterly partitions)
CREATE TABLE bookings_2023_q1 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');
CREATE TABLE bookings_2023_q2 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');
CREATE TABLE bookings_2023_q3 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');
CREATE TABLE bookings_2023_q4 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

-- 2024 data (monthly partitions for more granularity)
CREATE TABLE bookings_2024_01 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
CREATE TABLE bookings_2024_02 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
-- ... additional monthly partitions as needed

-- Future bookings partition
CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-03-01') TO (MAXVALUE);

-- 3. Migrate data from original table
INSERT INTO bookings_partitioned
SELECT * FROM bookings;

-- 4. Create indexes on partitioned table
CREATE INDEX idx_bookings_partitioned_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_partitioned_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_partitioned_status ON bookings_partitioned(status);
CREATE INDEX idx_bookings_partitioned_date_range ON bookings_partitioned(start_date, end_date);

-- 5. Test query performance on partitioned table
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE start_date BETWEEN '2023-07-01' AND '2023-09-30'
AND status = 'confirmed';

-- Compare with original table
EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE start_date BETWEEN '2023-07-01' AND '2023-09-30'
AND status = 'confirmed';