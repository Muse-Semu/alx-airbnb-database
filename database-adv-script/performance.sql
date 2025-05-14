-- Initial Query: Retrieve bookings with user, property, and payment details
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_status,
    pay.payment_date
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Create index on payments.booking_id to optimize join
CREATE INDEX CONCURRENTLY idx_payments_booking_id ON payments (booking_id);

-- Refactored Query: Optimized to reduce execution time
EXPLAIN
WITH recent_bookings AS (
    SELECT 
        booking_id,
        user_id,
        property_id,
        start_date,
        end_date,
        total_price,
        status,
        created_at
    FROM bookings
    WHERE created_at >= CURRENT_DATE - INTERVAL '1 year'
)
SELECT 
    rb.booking_id,
    rb.start_date,
    rb.end_date,
    rb.total_price,
    rb.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_status,
    pay.payment_date
FROM recent_bookings rb
INNER JOIN users u ON rb.user_id = u.user_id
INNER JOIN properties p ON rb.property_id = p.property_id
LEFT JOIN payments pay ON rb.booking_id = pay.booking_id
WHERE rb.status = 'confirmed'
ORDER BY rb.created_at DESC;