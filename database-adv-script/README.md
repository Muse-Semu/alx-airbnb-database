# AirBnB Clone Complex Join Queries

## Overview
This directory (`database-adv-script/`) contains SQL queries demonstrating the use of different types of joins for the AirBnB Clone project database. The queries operate on the normalized database schema defined in previous tasks, using INNER JOIN, LEFT JOIN, and FULL OUTER JOIN to retrieve data from the `users`, `properties`, `bookings`, and `reviews` tables.

## Files
- **joins_queries.sql**: Contains three SQL queries showcasing complex joins.
- **README.md**: This file, describing the purpose and contents of the directory.

## Query Details
The `joins_queries.sql` file includes the following queries:

1. **INNER JOIN Query**:
   - **Purpose**: Retrieves all bookings and the respective users who made those bookings.
   - **Tables**: `bookings`, `users`.
   - **Join**: `INNER JOIN` on `bookings.user_id = users.user_id`.
   - **Output**: Booking details (ID, property, dates, price, status) and user details (ID, name, email).
   - **Behavior**: Only returns bookings with matching users.

2. **LEFT JOIN Query**:
   - **Purpose**: Retrieves all properties and their reviews, including properties with no reviews.
   - **Tables**: `properties`, `reviews`.
   - **Join**: `LEFT JOIN` on `properties.property_id = reviews.property_id`.
   - **Output**: Property details (ID, name, price) and review details (ID, rating, comment), with NULL for reviews if none exist.
   - **Behavior**: Includes all properties, even those without reviews.

3. **FULL OUTER JOIN Query**:
   - **Purpose**: Retrieves all users and all bookings, including users with no bookings and bookings not linked to users.
   - **Tables**: `users`, `bookings`.
   - **Join**: `FULL OUTER JOIN` on `users.user_id = bookings.user_id`.
   - **Output**: User details (ID, name, email, role) and booking details (ID, property, dates, price, status), with NULL where no match exists.
   - **Behavior**: Includes all users and bookings, even unmatched ones.

## Usage
- **Prerequisites**:
  - Use a PostgreSQL database with the schema from `alx-airbnb-database` (e.g., `database-script-0x01/schema.sql`).
  - Ensure the `uuid-ossp` extension is enabled for UUIDs.
  - Populate the database with sample data (e.g., from `database-script-0x02/seed.sql`).
- **Run the Queries**:
  ```bash
  psql -U <username> -d <database> -f joins_queries.sql
  ```
- **Verify**: Execute each query individually in a SQL client to view results:
  ```sql
  \i joins_queries.sql
  ```

## Notes
- The queries assume PostgreSQL due to its support for UUIDs and the schema design. For other databases, modifications may be needed (e.g., replace UUID with another key type).
- The queries are optimized for readability and performance, using appropriate fields and sorting.
