-- ==========================================================================
-- POSTGRESQL DBA LAB - LAB 01: USER & ROLE MANAGEMENT (RBAC)
-- ==========================================================================

-- 1. Create Functional Role Groups
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'role_read_only') THEN
        CREATE ROLE role_read_only NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'role_data_analyst') THEN
        CREATE ROLE role_data_analyst NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'role_app_developer') THEN
        CREATE ROLE role_app_developer NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'role_db_admin') THEN
        CREATE ROLE role_db_admin NOLOGIN CREATEDB CREATEROLE;
    END IF;
END $$;

-- 2. Create Specific Database Users and Assign Passwords (SCRAM-SHA-256)
CREATE USER read_user_alice WITH PASSWORD 'AliceSecurePass2026!';
CREATE USER analyst_bob WITH PASSWORD 'BobAnalystPass2026!';
CREATE USER dev_charlie WITH PASSWORD 'CharlieDevPass2026!';

-- 3. Grant Role Membership
GRANT role_read_only TO read_user_alice;
GRANT role_data_analyst TO analyst_bob;
GRANT role_app_developer TO dev_charlie;

-- 4. Create Schemas
CREATE SCHEMA IF NOT EXISTS sales;
CREATE SCHEMA IF NOT EXISTS hr;
CREATE SCHEMA IF NOT EXISTS audit;

-- 5. Assign Privileges Hierarchy
-- Read-Only Privileges
GRANT USAGE ON SCHEMA sales, hr TO role_read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA sales, hr TO role_read_only;

-- Analyst Privileges (Read + Temp Tables)
GRANT role_read_only TO role_data_analyst;
GRANT CREATE ON SCHEMA sales TO role_data_analyst;

-- App Developer Privileges (Read, Write, DML)
GRANT USAGE, CREATE ON SCHEMA sales, hr TO role_app_developer;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sales, hr TO role_app_developer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA sales, hr TO role_app_developer;

-- Set Default Privileges for Future Tables
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT ON TABLES TO role_read_only;
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO role_app_developer;

-- 6. Row-Level Security (RLS) Configuration Example
ALTER TABLE IF EXISTS sales.orders ENABLE ROW LEVEL SECURITY;

-- Create Security Policy: Analysts only view orders in their region
DROP POLICY IF EXISTS region_security_policy ON sales.orders;
CREATE POLICY region_security_policy ON sales.orders
    FOR SELECT
    TO role_data_analyst
    USING (region = CURRENT_SETTING('app.current_region', true));

-- Output Verification
SELECT r.rolname, r.rolsuper, r.rolcreaterole, r.rolcreatedb, r.rolcanlogin
FROM pg_roles r
WHERE r.rolname IN ('role_read_only', 'role_data_analyst', 'role_app_developer', 'read_user_alice', 'analyst_bob');
