-- Query 1: Non-Correlated Subquery
-- Finds all properties where the average rating is greater than 4.0
-- Uses a subquery to compute the average rating per property
SELECT 
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    p.host_id
FROM properties p
WHERE p.property_id IN (
    SELECT 
        r.property_id
    FROM reviews r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
ORDER BY p.property_id;

-- Query 2: Correlated Subquery
-- Finds users who have made more than 3 bookings
-- Uses a correlated subquery to count bookings per user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM users u
WHERE (
    SELECT COUNT(*) 
    FROM bookings b 
    WHERE b.user_id = u.user_id
) > 3
ORDER BY u.user_id;