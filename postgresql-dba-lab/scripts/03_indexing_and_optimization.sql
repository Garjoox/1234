-- ==========================================================================
-- POSTGRESQL DBA LAB - LAB 03: INDEXING STRATEGIES & QUERY OPTIMIZATION
-- ==========================================================================

-- --------------------------------------------------------------------------
-- 1. EXPLAIN ANALYZE BEFORE INDEXING (Sequential Scan Benchmark)
-- --------------------------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT * FROM sales.orders 
WHERE status = 'COMPLETED' 
  AND region = 'NORTH' 
  AND order_date >= NOW() - INTERVAL '30 days';

-- --------------------------------------------------------------------------
-- 2. CREATE OPTIMIZED B-TREE & COMPOSITE INDEXES
-- --------------------------------------------------------------------------

-- Composite Index for Status & Region Queries
CREATE INDEX IF NOT EXISTS idx_orders_status_region 
ON sales.orders (status, region);

-- Partial Index for Pending Orders (saves space by indexing active subset)
CREATE INDEX IF NOT EXISTS idx_orders_pending_active 
ON sales.orders (order_date) 
WHERE status = 'PENDING';

-- Foreign Key Index on Customer ID (accelerates JOINs)
CREATE INDEX IF NOT EXISTS idx_orders_customer_id 
ON sales.orders (customer_id);

-- GIN Index on JSONB Metadata (accelerates JSON field lookups)
CREATE INDEX IF NOT EXISTS idx_customers_metadata_gin 
ON sales.customers USING GIN (metadata);

-- --------------------------------------------------------------------------
-- 3. EXPLAIN ANALYZE AFTER INDEXING (Index Scan Verification)
-- --------------------------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT * FROM sales.orders 
WHERE status = 'COMPLETED' 
  AND region = 'NORTH' 
  AND order_date >= NOW() - INTERVAL '30 days';

-- Test JSONB GIN Index Query Performance
EXPLAIN ANALYZE
SELECT first_name, last_name, metadata->>'tier' AS tier
FROM sales.customers
WHERE metadata @> '{"tier": "GOLD"}';

-- --------------------------------------------------------------------------
-- 4. REINDEX AND INDEX MAINTENANCE COMMANDS
-- --------------------------------------------------------------------------
-- Rebuild index concurrently without locking writes
REINDEX INDEX CONCURRENTLY sales.idx_orders_status_region;

-- Check Index Bloat & Usage Efficiency
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan AS index_scans_count,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM pg_stat_user_indexes
WHERE schemaname = 'sales'
ORDER BY idx_scan DESC;
