# AirBnB Clone Index Performance Analysis

This document summarizes the performance impact of adding indexes to the AirBnB Clone project database, as implemented in `database_index.sql`. The `database_index.sql` file includes `EXPLAIN ANALYZE` commands to measure the performance of two representative queries before and after adding indexes. This file provides an overview of the expected performance improvements and guidance on interpreting the results.

## Database Schema
The relevant tables are:
- **users**: `user_id` (PK, UUID), `email`, `first_name`, `last_name`, etc.
- **properties**: `property_id` (PK, UUID), `host_id` (FK), `pricepernight`, etc.
- **bookings**: `booking_id` (PK, UUID), `user_id` (FK), `property_id` (FK), `start_date`, `end_date`, `created_at`, etc.

## Indexes Created
The following indexes are created in `database_index.sql`:
1. `idx_users_email` (UNIQUE on `users.email`): Optimizes login/registration queries.
2. `idx_properties_host_id` (on `properties.host_id`): Speeds up host filtering.
3. `idx_properties_pricepernight` (on `properties.pricepernight`): Enhances price range searches.
4. `idx_bookings_user_id` (on `bookings.user_id`): Improves joins and booking history.
5. `idx_bookings_property_id` (on `bookings.property_id`): Optimizes joins and availability checks.
6. `idx_bookings_dates` (on `bookings(start_date, end_date)`): Supports date range queries.
7. `idx_bookings_created_at` (on `bookings.created_at`): Optimizes sorting.

## Performance Measurement
The `database_index.sql` file includes `EXPLAIN ANALYZE` commands for two queries, executed before and after adding indexes. To measure performance:
1. Run `database_index.sql` in a PostgreSQL client:
   ```bash
   psql -U <username> -d <database> -f database_index.sql
   ```
2. Review the `EXPLAIN ANALYZE` output for each query, focusing on:
   - **Planning Time**: Time to plan the query (ms).
   - **Execution Time**: Time to execute the query (ms).
   - **Cost**: Estimated query cost (arbitrary units).
   - **Scan Types**: Sequential scans (slower) vs. index scans (faster).
   - **Rows**: Number of rows processed.

### Query 1: INNER JOIN (Bookings and Users)
**Query**:
```sql
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
```
- **Indexes Used**:
  - `idx_bookings_user_id`: Optimizes the join on `bookings.user_id`.
  - `idx_bookings_created_at`: Speeds up sorting by `created_at`.
- **Expected Improvement**:
  - **Before**: Sequential scans on `bookings` and `users`, with high cost for joining and sorting (e.g., execution time ~150 ms for 10,000 bookings).
  - **After**: Index scans on `bookings.user_id` and `bookings.created_at`, reducing execution time (e.g., ~50 ms, ~66% improvement).
  - **Reason**: Indexes eliminate full table scans and optimize join and sort operations.

### Query 2: LEFT JOIN (Properties and Bookings with Price Filter)
**Query**:
```sql
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
```
- **Indexes Used**:
  - `idx_properties_pricepernight`: Optimizes the `WHERE p.pricepernight < 200.00` filter.
  - `idx_bookings_property_id`: Speeds up the join on `bookings.property_id`.
- **Expected Improvement**:
  - **Before**: Sequential scans on `properties` and `bookings`, with high cost for filtering and joining (e.g., execution time ~200 ms for 4,000 properties).
  - **After**: Index scans on `properties.pricepernight` and `bookings.property_id`, reducing execution time (e.g., ~80 ms, ~60% improvement).
  - **Reason**: Indexes enable efficient filtering and joining, reducing processing time.

## Interpreting Results
- **Planning Time**: Should decrease slightly after indexing due to simpler query plans.
- **Execution Time**: Expect 50-70% reduction for queries using indexed columns.
- **Cost**: Lower costs indicate more efficient plans (e.g., index scans vs. sequential scans).
- **Scan Types**: Look for "Index Scan" instead of "Seq Scan" in the `EXPLAIN ANALYZE` output.
- **Rows**: Fewer rows processed after indexing indicates better filtering.

## Summary
- **Performance Impact**: Indexes significantly reduce execution time for joins, filters, and sorting by enabling index scans.
- **Trade-offs**: Indexes increase storage and slow `INSERT`/`UPDATE` operations. Monitor with `pg_stat_user_indexes` to ensure usage.
  