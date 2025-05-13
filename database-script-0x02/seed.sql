-- Ensure UUID extension is enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Insert Users (2 guests, 2 hosts, 1 admin)
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
    (uuid_generate_v4(), 'Alice', 'Smith', 'alice.smith@example.com', 'hash123', '+1-555-0101', 'guest', '2025-01-01 10:00:00'),
    (uuid_generate_v4(), 'Bob', 'Johnson', 'bob.johnson@example.com', 'hash456', '+1-555-0102', 'guest', '2025-01-02 12:00:00'),
    (uuid_generate_v4(), 'Charlie', 'Brown', 'charlie.brown@example.com', 'hash789', '+1-555-0103', 'host', '2025-01-03 14:00:00'),
    (uuid_generate_v4(), 'Diana', 'Wilson', 'diana.wilson@example.com', 'hash012', '+44-20-1234-5678', 'host', '2025-01-04 16:00:00'),
    (uuid_generate_v4(), 'Emma', 'Davis', 'emma.davis@example.com', 'hash345', '+1-555-0105', 'admin', '2025-01-05 18:00:00');

-- Insert Locations (3 distinct locations)
INSERT INTO locations (location_id, street_address, city, state, country, postal_code)
VALUES
    (uuid_generate_v4(), '123 Main St', 'New York', 'NY', 'USA', '10001'),
    (uuid_generate_v4(), '456 Market St', 'San Francisco', 'CA', 'USA', '94105'),
    (uuid_generate_v4(), '789 Oxford St', 'London', NULL, 'UK', 'W1A 1AA');

-- Insert Properties (4 properties by 2 hosts, linked to locations)
INSERT INTO properties (property_id, host_id, location_id, name, description, pricepernight, created_at, updated_at)
VALUES
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'charlie.brown@example.com'),
        (SELECT location_id FROM locations WHERE city = 'New York'),
        'Cozy NYC Apartment',
        'A modern apartment in the heart of Manhattan.',
        150.00,
        '2025-02-01 09:00:00',
        '2025-02-01 09:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'charlie.brown@example.com'),
        (SELECT location_id FROM locations WHERE city = 'San Francisco'),
        'Sunny SF Loft',
        'Spacious loft with great views of the city.',
        200.00,
        '2025-02-02 10:00:00',
        '2025-02-02 10:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'diana.wilson@example.com'),
        (SELECT location_id FROM locations WHERE city = 'London'),
        'Charming London Flat',
        'A cozy flat near central London attractions.',
        180.00,
        '2025-02-03 11:00:00',
        '2025-02-03 11:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'diana.wilson@example.com'),
        (SELECT location_id FROM locations WHERE city = 'London'),
        'Luxury London Studio',
        'Elegant studio with modern amenities.',
        220.00,
        '2025-02-04 12:00:00',
        '2025-02-04 12:00:00'
    );

-- Insert Bookings (6 bookings by guests, linked to properties)
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Cozy NYC Apartment'),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        '2025-06-01',
        '2025-06-04',
        150.00 * 3, -- 3 nights
        'confirmed',
        '2025-05-01 08:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Sunny SF Loft'),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        '2025-07-10',
        '2025-07-15',
        200.00 * 5, -- 5 nights
        'pending',
        '2025-05-02 09:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Charming London Flat'),
        (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com'),
        '2025-08-01',
        '2025-08-03',
        180.00 * 2, -- 2 nights
        'confirmed',
        '2025-05-03 10:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Luxury London Studio'),
        (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com'),
        '2025-09-05',
        '2025-09-08',
        220.00 * 3, -- 3 nights
        'canceled',
        '2025-05-04 11:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Cozy NYC Apartment'),
        (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com'),
        '2025-10-01',
        '2025-10-05',
        150.00 * 4, -- 4 nights
        'confirmed',
        '2025-05-05 12:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Sunny SF Loft'),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        '2025-11-15',
        '2025-11-18',
        200.00 * 3, -- 3 nights
        'confirmed',
        '2025-05-06 13:00:00'
    );

-- Insert Payments (4 payments for confirmed bookings)
INSERT INTO payments (payment_id, booking_id, amount, payment_date, payment_method)
VALUES
    (
        uuid_generate_v4(),
        (SELECT booking_id FROM bookings WHERE start_date = '2025-06-01' AND user_id = (SELECT user_id FROM users WHERE email = 'alice.smith@example.com')),
        450.00,
        '2025-05-01 09:00:00',
        'credit_card'
    ),
    (
        uuid_generate_v4(),
        (SELECT booking_id FROM bookings WHERE start_date = '2025-08-01' AND user_id = (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com')),
        360.00,
        '2025-05-03 11:00:00',
        'paypal'
    ),
    (
        uuid_generate_v4(),
        (SELECT booking_id FROM bookings WHERE start_date = '2025-10-01' AND user_id = (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com')),
        600.00,
        '2025-05-05 13:00:00',
        'stripe'
    ),
    (
        uuid_generate_v4(),
        (SELECT booking_id FROM bookings WHERE start_date = '2025-11-15' AND user_id = (SELECT user_id FROM users WHERE email = 'alice.smith@example.com')),
        600.00,
        '2025-05-06 14:00:00',
        'credit_card'
    );

-- Insert Reviews (3 reviews for properties by guests)
INSERT INTO reviews (review_id, property_id, user_id, rating, comment, created_at)
VALUES
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Cozy NYC Apartment'),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        4,
        'Great location, very clean and comfortable!',
        '2025-06-05 10:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Charming London Flat'),
        (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com'),
        5,
        'Amazing stay, host was very responsive.',
        '2025-08-04 11:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM properties WHERE name = 'Sunny SF Loft'),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        3,
        'Nice place, but a bit noisy at night.',
        '2025-11-19 12:00:00'
    );

-- Insert Messages (4 messages between users)
INSERT INTO messages (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        (SELECT user_id FROM users WHERE email = 'charlie.brown@example.com'),
        'Is the NYC apartment available for June 1-4?',
        '2025-04-25 08:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'charlie.brown@example.com'),
        (SELECT user_id FROM users WHERE email = 'alice.smith@example.com'),
        'Yes, it’s available! I’ll reserve it for you.',
        '2025-04-25 09:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com'),
        (SELECT user_id FROM users WHERE email = 'diana.wilson@example.com'),
        'Can I book the London flat for August 1-3?',
        '2025-04-26 10:00:00'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM users WHERE email = 'diana.wilson@example.com'),
        (SELECT user_id FROM users WHERE email = 'bob.johnson@example.com'),
        'Confirmed, looking forward to hosting you!',
        '2025-04-26 11:00:00'
    );