-- Performance measurement before adding indexes
-- Query 1: INNER JOIN to retrieve bookings and users, using bookings.user_id and created_at
EXPLAIN ANALYZE
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

-- Query 2: LEFT JOIN to retrieve properties and booking counts with price filter
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    COUNT(b.booking_id) AS booking_count
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
WHERE p.pricepernight < 200.00
GROUP BY p.property_id, p.name, p.pricepernight
ORDER BY booking_count DESC;

-- Create indexes to optimize high-usage columns
-- Index on users.email for login and registration queries
CREATE UNIQUE INDEX CONCURRENTLY idx_users_email ON users (email);

-- Index on properties.host_id for filtering properties by host
CREATE INDEX CONCURRENTLY idx_properties_host_id ON properties (host_id);

-- Index on properties.pricepernight for price range searches
CREATE INDEX CONCURRENTLY idx_properties_pricepernight ON properties (pricepernight);

-- Index on bookings.user_id for joins and booking history queries
CREATE INDEX CONCURRENTLY idx_bookings_user_id ON bookings (user_id);

-- Index on bookings.property_id for joins and availability checks
CREATE INDEX CONCURRENTLY idx_bookings_property_id ON bookings (property_id);

-- Composite index on bookings.start_date and bookings.end_date for availability checks
CREATE INDEX CONCURRENTLY idx_bookings_dates ON bookings (start_date, end_date);

-- Index on bookings.created_at for sorting by creation date
CREATE INDEX CONCURRENTLY idx_bookings_created_at ON bookings (created_at);

-- Performance measurement after adding indexes
-- Query 1: Repeat INNER JOIN to compare performance
EXPLAIN ANALYZE
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

-- Query 2: Repeat LEFT JOIN to compare performance
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.name AS property_name,
    p.pricepernight,
    COUNT(b.booking_id) AS booking_count
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
WHERE p.pricepernight < 200.00
GROUP BY p.property_id, p.name, p.pricepernight
ORDER BY booking_count DESC;