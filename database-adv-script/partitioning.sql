-- Create the parent bookings table (no data, partitioned by range on start_date)
CREATE TABLE bookings (
    booking_id UUID DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT bookings_pk PRIMARY KEY (booking_id, start_date),
    CONSTRAINT bookings_property_id_fk FOREIGN KEY (property_id) REFERENCES properties (property_id),
    CONSTRAINT bookings_user_id_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT bookings_dates_check CHECK (start_date <= end_date)
) PARTITION BY RANGE (start_date);

-- Create child tables for yearly partitions (2023, 2024, 2025, and future)
CREATE TABLE bookings_2023 PARTITION OF bookings
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01')
    WITH (CONSTRAINT bookings_2023_start_date_check CHECK (start_date >= '2023-01-01' AND start_date < '2024-01-01'));

CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01')
    WITH (CONSTRAINT bookings_2024_start_date_check CHECK (start_date >= '2024-01-01' AND start_date < '2025-01-01'));

CREATE TABLE bookings_2025 PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01')
    WITH (CONSTRAINT bookings_2025_start_date_check CHECK (start_date >= '2025-01-01' AND start_date < '2026-01-01'));

CREATE TABLE bookings_future PARTITION OF bookings
    FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- Create indexes on each partition
-- bookings_2023
CREATE INDEX idx_bookings_2023_user_id ON bookings_2023 (user_id);
CREATE INDEX idx_bookings_2023_property_id ON bookings_2023 (property_id);
CREATE INDEX idx_bookings_2023_dates ON bookings_2023 (start_date, end_date);

-- bookings_2024
CREATE INDEX idx_bookings_2024_user_id ON bookings_2024 (user_id);
CREATE INDEX idx_bookings_2024_property_id ON bookings_2024 (property_id);
CREATE INDEX idx_bookings_2024_dates ON bookings_2024 (start_date, end_date);

-- bookings_2025
CREATE INDEX idx_bookings_2025_user_id ON bookings_2025 (user_id);
CREATE INDEX idx_bookings_2025_property_id ON bookings_2025 (property_id);
CREATE INDEX idx_bookings_2025_dates ON bookings_2025 (start_date, end_date);

-- bookings_future
CREATE INDEX idx_bookings_future_user_id ON bookings_future (user_id);
CREATE INDEX idx_bookings_future_property_id ON bookings_future (property_id);
CREATE INDEX idx_bookings_future_dates ON bookings_future (start_date, end_date);

-- Migrate data from the original bookings table to the partitioned table
-- Assuming the original table is named bookings_old
INSERT INTO bookings
SELECT * FROM bookings_old;

-- Drop the original table after migration (ensure data is backed up)
-- DROP TABLE bookings_old;

-- Test query: Fetch bookings for a specific date range to demonstrate partition pruning
EXPLAIN
SELECT 
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,
    status
FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY start_date;