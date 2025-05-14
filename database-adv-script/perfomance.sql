-- Initial Query: Retrieve all bookings with user, property, and payment details
-- This query joins multiple tables and may have performance issues due to broad scope
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_status
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Refactored Query: Optimized for performance
-- Filters by recent bookings and confirmed status, selects fewer columns, and leverages indexes
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_status
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id
WHERE b.created_at > CURRENT_DATE - INTERVAL '1 year'
  AND b.status = 'confirmed'
ORDER BY b.created_at DESC;