-- ==========================================================================
-- POSTGRESQL DBA LAB - LAB 05: DATABASE MONITORING & DIAGNOSTICS
-- ==========================================================================

-- --------------------------------------------------------------------------
-- 1. ACTIVE CONNECTIONS & QUERY DURATION MONITORING
-- --------------------------------------------------------------------------
SELECT 
    pid,
    usename AS user_name,
    client_addr AS client_ip,
    state,
    NOW() - query_start AS duration,
    query
FROM pg_stat_activity
WHERE state != 'idle'
  AND pid != pg_backend_pid()
ORDER BY duration DESC;

-- --------------------------------------------------------------------------
-- 2. LOCK CONFLICTS & BLOCKED QUERIES IDENTIFICATION
-- --------------------------------------------------------------------------
SELECT 
    blocked_locks.pid     AS blocked_pid,
    blocked_activity.usename  AS blocked_user,
    blocking_locks.pid    AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query    AS blocked_statement,
    blocking_activity.query   AS blocking_statement
FROM  pg_catalog.pg_locks         blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks         blocking_locks 
    ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
    AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
    AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
    AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
    AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
    AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
    AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
    AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

-- --------------------------------------------------------------------------
-- 3. CACHE HIT RATIO DIAGNOSTIC (Target > 99%)
-- --------------------------------------------------------------------------
SELECT 
    sum(heap_blks_read) as heap_read,
    sum(heap_blks_hit)  as heap_hit,
    sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) * 100.0 AS cache_hit_ratio
FROM pg_statio_user_tables;

-- --------------------------------------------------------------------------
-- 4. TABLE BLOAT & DEAD TUPLES MONITORING (Autovacuum Health)
-- --------------------------------------------------------------------------
SELECT 
    schemaname,
    relname AS table_name,
    n_live_tup AS live_tuples,
    n_dead_tup AS dead_tuples,
    round(100.0 * n_dead_tup / nullif(n_live_tup + n_dead_tup, 0), 2) AS dead_tuple_ratio,
    last_vacuum,
    last_autovacuum,
    last_analyze
FROM pg_stat_user_tables
WHERE schemaname = 'sales'
ORDER BY dead_tuples DESC;

-- --------------------------------------------------------------------------
-- 5. TOP SLOW QUERIES (pg_stat_statements)
-- --------------------------------------------------------------------------
SELECT 
    substring(query, 1, 60) AS short_query,
    calls,
    total_exec_time / 1000 AS total_sec,
    mean_exec_time AS avg_ms,
    rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
