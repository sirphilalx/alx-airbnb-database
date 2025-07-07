-- performance.sql
-- Optimized booking query with all required SQL clauses

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    p.property_id,
    p.property_name,
    p.property_type,
    pay.amount,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN LATERAL (
    SELECT 
        amount,
        payment_status
    FROM 
        payments
    WHERE 
        booking_id = b.booking_id
    ORDER BY 
        payment_date DESC
    LIMIT 1
) pay ON true
WHERE 
    b.start_date >= CURRENT_DATE - INTERVAL '6 months'
    AND b.status = 'confirmed'
    AND p.is_active = true
ORDER BY 
    b.start_date DESC
LIMIT 1000;

-- Performance analysis commands
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    p.property_id,
    p.property_name,
    p.property_type,
    pay.amount,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN LATERAL (
    SELECT 
        amount,
        payment_status
    FROM 
        payments
    WHERE 
        booking_id = b.booking_id
    ORDER BY 
        payment_date DESC
    LIMIT 1
) pay ON true
WHERE 
    b.start_date >= CURRENT_DATE - INTERVAL '6 months'
    AND b.status = 'confirmed'
    AND p.is_active = true
ORDER BY 
    b.start_date DESC
LIMIT 1000;

-- Supporting indexes for optimized query
CREATE INDEX idx_bookings_dates ON bookings(start_date DESC, end_date);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_property ON bookings(property_id);
CREATE INDEX idx_payments_booking ON payments(booking_id, payment_date DESC);