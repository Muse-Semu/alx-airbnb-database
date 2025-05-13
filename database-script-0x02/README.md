# AirBnB Database Seed Data

## Overview
This directory (`database-script-0x02`) contains the SQL script to populate the AirBnB database with sample data. The data reflects real-world usage, including multiple users, properties, bookings, payments, reviews, and messages, and is designed to work with the schema defined in `database-script-0x01/schema.sql`.

## Files
- **seed.sql**: Contains SQL `INSERT` statements to add sample data to all tables.
- **README.md**: This file, describing the seed script and its usage.

## Seed Data Details
The seed data populates the following tables:
- **users**: 5 users (2 guests, 2 hosts, 1 admin) with realistic names, emails, and roles.
- **locations**: 3 locations (New York, San Francisco, London) with full address details.
- **properties**: 4 properties owned by the 2 hosts, linked to locations, with varied prices and descriptions.
- **bookings**: 6 bookings by guests, with different dates, statuses (pending, confirmed, canceled), and total prices.
- **payments**: 4 payments for confirmed bookings, using different payment methods (credit_card, paypal, stripe).
- **reviews**: 3 reviews by guests for properties, with ratings (1-5) and comments.
- **messages**: 4 messages between users (e.g., guest-host inquiries and confirmations).

### Key Features
- **Realistic Data**: Dates are set in 2025, prices are reasonable, and relationships (e.g., foreign keys) are maintained.
- **UUIDs**: Generated using `uuid_generate_v4()` for primary keys.
- **Consistency**: `total_price` in `bookings` is calculated based on `pricepernight` and booking duration.
- **Diversity**: Includes various user roles, booking statuses, and payment methods to simulate real-world usage.

## Usage
1. **Prerequisites**:
   - Use a PostgreSQL database with the `uuid-ossp` extension enabled.
   - Ensure the schema from `database-script-0x01/schema.sql` is applied.
2. **Run the Script**:
   ```bash
   psql -U <username> -d <database> -f seed.sql
   ```
3. **Verify**: Check the data using SQL queries, e.g.:
   ```sql
   SELECT * FROM users;
   SELECT * FROM bookings;
   ```

## Notes
- The script assumes PostgreSQL due to its support for UUIDs and `CHECK` constraints. For other databases, modifications may be needed (e.g., replace ENUM with VARCHAR).
- Foreign key constraints ensure data integrity (e.g., bookings reference valid properties and users).
- The data is designed for testing and development, with a small but representative dataset.