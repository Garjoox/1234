-- ==========================================================================
-- POSTGRESQL DBA LAB - LAB 02: ENTERPRISE SCHEMA & MOCK DATA GENERATION
-- ==========================================================================

CREATE SCHEMA IF NOT EXISTS sales;
CREATE SCHEMA IF NOT EXISTS audit;

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS sales.customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    region VARCHAR(30) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB
);

CREATE TABLE IF NOT EXISTS sales.orders (
    order_id BIGSERIAL PRIMARY KEY,
    customer_id INT REFERENCES sales.customers(customer_id),
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED')),
    total_amount NUMERIC(12, 2) NOT NULL,
    region VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS sales.order_items (
    item_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES sales.orders(order_id) ON DELETE CASCADE,
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS audit.system_logs (
    log_id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    event_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

-- 2. Populate 1,000 Customers
INSERT INTO sales.customers (first_name, last_name, email, region, created_at, metadata)
SELECT 
    'Customer_' || i,
    'LastName_' || i,
    'user_' || i || '@enterprise.org',
    (ARRAY['NORTH', 'SOUTH', 'EAST', 'WEST', 'CENTRAL'])[floor(random() * 5 + 1)],
    NOW() - (random() * 365 || ' days')::INTERVAL,
    jsonb_build_object('tier', (ARRAY['BRONZE', 'SILVER', 'GOLD', 'PLATINUM'])[floor(random() * 4 + 1)], 'active', true)
FROM generate_series(1, 1000) s(i)
ON CONFLICT (email) DO NOTHING;

-- 3. Populate 100,000 Orders for Benchmark Testing
INSERT INTO sales.orders (customer_id, order_date, status, total_amount, region)
SELECT 
    floor(random() * 1000 + 1)::int,
    NOW() - (random() * 730 || ' days')::INTERVAL,
    (ARRAY['PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED'])[floor(random() * 4 + 1)],
    (random() * 950 + 50)::numeric(12,2),
    (ARRAY['NORTH', 'SOUTH', 'EAST', 'WEST', 'CENTRAL'])[floor(random() * 5 + 1)]
FROM generate_series(1, 100000) s(i);

-- 4. Gather Initial Table Statistics
ANALYZE sales.customers;
ANALYZE sales.orders;

-- Verify Record Count
SELECT 'customers' AS table_name, COUNT(*) FROM sales.customers
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) FROM sales.orders;
