# AirBnB Clone Advanced SQL Queries

## Overview
This directory (`database-adv-script/`) contains SQL queries demonstrating advanced database operations for the AirBnB Clone project. The queries cover three key areas: complex joins, subqueries, and aggregations/window functions. They operate on the normalized database schema defined in previous tasks, including tables such as `users`, `properties`, `bookings`, and `reviews`.

## Files
- **joins_queries.sql**: SQL queries showcasing INNER JOIN, LEFT JOIN, and FULL OUTER JOIN.
- **subqueries.sql**: SQL queries demonstrating non-correlated and correlated subqueries.
- **aggregations_and_window_functions.sql**: SQL queries using aggregation (COUNT, GROUP BY) and window functions (RANK).
- **README.md**: This file, describing the purpose and contents of all queries in the directory.

## Query Details

### 1. Join Queries (`joins_queries.sql`)
The following queries demonstrate the use of different types of joins:

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

### 2. Subqueries (`subqueries.sql`)
The following queries demonstrate non-correlated and correlated subqueries:

1. **Non-Correlated Subquery**:
   - **Purpose**: Finds all properties where the average rating is greater than 4.0.
   - **Tables**: `properties`, `reviews`.
   - **Subquery**: Computes the average rating per property in the `reviews` table, grouping by `property_id` and filtering for averages > 4.0.
   - **Outer Query**: Selects properties whose `property_id` is in the subquery results.
   - **Output**: Property details (ID, name, price, host ID).
   - **Behavior**: Returns only properties with an average rating above 4.0.

2. **Correlated Subquery**:
   - **Purpose**: Finds users who have made more than 3 bookings.
   - **Tables**: `users`, `bookings`.
   - **Subquery**: Counts the number of bookings in the `bookings` table for each user, referencing the `user_id` from the outer `users` table.
   - **Outer Query**: Selects users where the subquery count exceeds 3.
   - **Output**: User details (ID, name, email, role).
   - **Behavior**: Returns users with more than 3 bookings.

### 3. Aggregations and Window Functions (`aggregations_and_window_functions.sql`)
The following queries demonstrate aggregation and window functions:

1. **Aggregation Query**:
   - **Purpose**: Finds the total number of bookings made by each user.
   - **Tables**: `users`, `bookings`.
   - **Approach**: Uses `COUNT` to tally bookings and `GROUP BY` to group by user. Joins `users` and `bookings` with `LEFT JOIN` to include users with zero bookings.
   - **Output**: User details (ID, name, email) and the total number of bookings.
   - **Behavior**: Returns all users, with booking counts (0 or more).

2. **Window Function Query**:
   - **Purpose**: Ranks properties based on the total number of bookings they have received.
   - **Tables**: `properties`, `bookings`.
   - **Approach**: Aggregates bookings per property using `COUNT` and `GROUP BY`, then applies `RANK()` over the booking count in descending order.
   - **Output**: Property details (ID, name, price), total bookings, and booking rank.
   - **Behavior**: Assigns ranks to properties, with the highest booking count ranked 1.

## Usage
- **Prerequisites**:
  - Use a PostgreSQL database with the schema from `alx-airbnb-database` (e.g., `database-script-0x01/schema.sql`).
  - Ensure the `uuid-ossp` extension is enabled for UUIDs.
  - Populate the database with sample data (e.g., from `database-script-0x02/seed.sql`).
- **Run the Queries**:
  ```bash
  psql -U <username> -d <database> -f joins_queries.sql
  psql -U <username> -d <database> -f subqueries.sql
  psql -U <username> -d <database> -f aggregations_and_window_functions.sql
  ```
- **Verify**: Execute each query individually in a SQL client to view results:
  ```sql
  \i joins_queries.sql
  \i subqueries.sql
  \i aggregations_and_window_functions.sql
  ```

## Notes
- The queries assume PostgreSQL due to its support for UUIDs and the schema design. For other databases, modifications may be needed (e.g., replace UUID with another key type).
- All queries are optimized for readability and performance, using appropriate fields and sorting.
- The schema and sample data from previous tasks ensure realistic results (e.g., bookings linked to users, properties with varying reviews).
- The queries complement each other, providing a comprehensive set of advanced SQL techniques for data analysis.
- For schema details, refer to the `database-script-0x01/` directory in the `alx-airbnb-database` repository.