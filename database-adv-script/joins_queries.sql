-- Query 1: INNER JOIN to retrieve all bookings and their respective users
-- Returns bookings with matching user details, excluding bookings without users
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- Query 2: LEFT JOIN to retrieve all properties and their reviews, including properties with no reviews
-- Returns all properties, with NULL for review fields if no reviews exist
SELECT 
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at DESC;

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings
-- Includes users with no bookings and bookings not linked to users (if any)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM users u
FULL OUTER JOIN bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.created_at DESC;