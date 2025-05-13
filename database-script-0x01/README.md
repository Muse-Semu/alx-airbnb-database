# AirBnB Database Schema

## Overview
This directory (`database-script-0x01`) contains the SQL schema definition for the AirBnB database, designed to support a platform for property rentals. The schema is normalized to the Third Normal Form (3NF) and includes tables, constraints, and indexes for optimal performance.

## Files
- **schema.sql**: Contains SQL `CREATE TABLE` statements to define the database schema, including primary keys, foreign keys, constraints, and indexes.

## Schema Details
The database consists of the following tables:
- **users**: Stores user information (e.g., name, email, role).
- **locations**: Stores location details (e.g., city, country) for properties.
- **properties**: Stores property details (e.g., name, price per night).
- **bookings**: Stores booking details (e.g., start date, total price).
- **payments**: Stores payment details for bookings.
- **reviews**: Stores user reviews for properties.
- **messages**: Stores messages between users.

### Key Features
- **Primary Keys**: UUIDs for unique identification.
- **Foreign Keys**: Enforce referential integrity (e.g., `host_id` in `properties` references `users`).
- **Constraints**: `NOT NULL`, `UNIQUE`, `CHECK` (e.g., rating between 1-5), and date validation.
- **Indexes**: Added on frequently queried columns (e.g., `email`, `property_id`) for performance.
- **Timestamps**: Track creation and update times where applicable.

## Usage
1. **Prerequisites**: Use a PostgreSQL database (the script uses the `uuid-ossp` extension for UUID generation).
2. **Run the Script**:
   ```bash
   psql -U <username> -d <database> -f schema.sql
   ```
3. **Verify**: Check that tables, constraints, and indexes are created correctly using `\dt` and `\di` in `psql`.

## Notes
- The schema assumes PostgreSQL due to its native support for UUIDs and ENUM types. For other databases (e.g., MySQL), modifications may be needed (e.g., replace ENUM with VARCHAR and CHECK constraints).
- The `total_price` in the `bookings` table is stored for audit purposes, with consistency enforced by application logic.
- Foreign key `ON DELETE` actions are set to `CASCADE` or `RESTRICT` based on logical dependencies (e.g., deleting a user cascades to their messages but restricts property deletion).