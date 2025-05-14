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