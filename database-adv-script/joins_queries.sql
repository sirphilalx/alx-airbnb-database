SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id;


SELECT 
    p.property_id,
    p.property_name,
    p.property_type,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id;


SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.user_id;