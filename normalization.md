# AirBnB Database Normalization

This document outlines the steps taken to normalize the AirBnB database schema to the **Third Normal Form (3NF)**. Normalization ensures data integrity, reduces redundancy, and eliminates anomalies during insertions, updates, and deletions.

## Initial Schema Review

The original schema consisted of six tables: **User**, **Property**, **Booking**, **Payment**, **Review**, and **Message**. Each table was analyzed for adherence to the First Normal Form (1NF), Second Normal Form (2NF), and Third Normal Form (3NF).

### 1NF Analysis
- **Criteria**: All attributes must be atomic, and each table must have a primary key.
- **Findings**: All attributes were atomic (e.g., no multi-valued attributes), and each table had a unique primary key (UUIDs).
- **Conclusion**: The schema was already in 1NF.

### 2NF Analysis
- **Criteria**: The schema must be in 1NF, and all non-key attributes must be fully functionally dependent on the entire primary key.
- **Findings**: All tables used single-column primary keys (UUIDs), so there were no composite keys or partial dependencies.
- **Conclusion**: The schema was in 2NF.

### 3NF Analysis
- **Criteria**: The schema must be in 2NF, and there should be no transitive dependencies (non-key attributes depending on other non-key attributes).
- **Issues Identified**:
  1. **Property Table**: The `location` attribute (VARCHAR) likely stored composite data (e.g., street, city, state, country). Components like city or state could be repeated across multiple properties, introducing redundancy and a transitive dependency (e.g., city depends on state, not directly on `property_id`).
  2. **Booking Table**: The `total_price` attribute is likely derived from `pricepernight` (from Property) and the booking duration (`end_date - start_date`). Storing it risks inconsistency if `pricepernight` changes, though this is a denormalization choice rather than a strict transitive dependency.
  3. **Other Tables**: The **User**, **Payment**, **Review**, and **Message** tables showed no transitive dependencies.

## Normalization Steps

To achieve 3NF, the following changes were made:

### 1. Normalize the `location` Attribute
- **Issue**: The `location` attribute in the **Property** table contained composite data, leading to potential redundancy (e.g., repeating city or state names).
- **Solution**:
  - Created a new **Location** table with attributes: `location_id (PK)`, `street_address`, `city (NOT NULL)`, `state`, `country (NOT NULL)`, `postal_code`.
  - Replaced the `location` attribute in the **Property** table with `location_id` (FK to Location).
- **Justification**: This eliminates redundancy by storing each unique location once and ensures that location components (e.g., city, state) depend only on `location_id`, satisfying 3NF.

### 2. Handle `total_price` in the Booking Table
- **Issue**: The `total_price` attribute is derived from `pricepernight` and booking duration. Storing it risks inconsistency if `pricepernight` changes.
- **Solution**:
  - Retained `total_price` for audit and performance purposes (common in real-world applications like AirBnB).
  - Noted that consistency must be enforced via application logic or database triggers (e.g., recalculate `total_price` if `pricepernight` changes).
  - Alternatively, `total_price` could be removed and computed dynamically to strictly adhere to 3NF, but this was not chosen due to practical considerations.
- **Justification**: While storing `total_price` is a controlled denormalization, it does not violate 3NF as it depends on the primary key (`booking_id`) and external data (`pricepernight`). The application must ensure consistency.

### 3. Other Tables
- **User**, **Payment**, **Review**, and **Message** tables were already in 3NF, as their non-key attributes depend only on the primary key and have no transitive dependencies.

## Final Normalized Schema

The normalized schema includes a new **Location** table and a modified **Property** table:

- **User** (unchanged): `user_id (PK)`, `first_name`, `last_name`, `email (UNIQUE)`, `password_hash`, `phone_number`, `role`, `created_at`
- **Location** (new): `location_id (PK)`, `street_address`, `city (NOT NULL)`, `state`, `country (NOT NULL)`, `postal_code`
- **Property** (modified): `property_id (PK)`, `host_id (FK)`, `location_id (FK)`, `name`, `description`, `pricepernight`, `created_at`, `updated_at`
- **Booking** (unchanged): `booking_id (PK)`, `property_id (FK)`, `user_id (FK)`, `start_date`, `end_date`, `total_price`, `status`, `created_at`
- **Payment** (unchanged): `payment_id (PK)`, `booking_id (FK)`, `amount`, `payment_date`, `payment_method`
- **Review)は、(unchanged): `review_id (PK)`, `property_id (FK)`, `user_id (FK)`, `rating`, `comment`, `created_at`
- **Message** (unchanged): `message_id (PK)`, `sender_id (FK)`, `recipient_id (FK)`, `message_body`, `sent_at`

## Conclusion

The database was normalized to 3NF by addressing the transitive dependency in the `location` attribute through the creation of a **Location** table. The `total_price` in the **Booking** table was retained with a note on maintaining consistency, balancing 3NF compliance with practical requirements. The resulting schema minimizes redundancy, ensures data integrity, and supports efficient querying for the AirBnB application.