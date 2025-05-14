-- Query 1: Aggregation with COUNT and GROUP BY
-- Finds the total number of bookings made by each user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY total_bookings DESC, u.user_id;

-- Query 2: Window Function with RANK
-- Ranks properties based on the total number of bookings they have received
WITH booking_counts AS (
    SELECT 
        p.property_id,
        p.name AS property_name,
        p.pricepernight,
        COUNT(b.booking_id) AS total_bookings
    FROM properties p
    LEFT JOIN bookings b ON p.property_id = b.property_id
    GROUP BY p.property_id, p.name, p.pricepernight
)
SELECT 
    property_id,
    property_name,
    pricepernight,
    total_bookings,
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM booking_counts
ORDER BY booking_rank, property_id;