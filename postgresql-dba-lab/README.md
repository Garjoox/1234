# PostgreSQL Database Administration Lab

A practical, production-grade PostgreSQL environment focused on relational database administration, role-based access control (RBAC), security policies, full & point-in-time backup/recovery, indexing strategies, query tuning, and active database monitoring.

---

## Lab Architecture & Tech Stack
- **Database Engine**: PostgreSQL 16 (Alpine)
- **Deployment**: Docker Compose (Primary Instance + Standby Replica + pgAdmin 4 Dashboard)
- **Primary Database**: `dba_lab_db`
- **Default Superuser**: `lab_admin` (Port `5432`)
- **Replica Instance**: Standby Node (Port `5433`)
- **Management Dashboard**: pgAdmin 4 (`http://localhost:8080`)

---

## Directory Structure
```
postgresql-dba-lab/
├── docker-compose.yml              # Multi-container orchestration (Primary, Replica, pgAdmin)
├── README.md                       # Complete step-by-step lab manual
├── config/
│   ├── postgresql.conf             # Tuned server configuration parameters
│   └── pg_hba.conf                 # Security client authentication & subnet restrictions
└── scripts/
    ├── 01_user_and_role_management.sql # RBAC, permissions hierarchy & Row-Level Security (RLS)
    ├── 02_schema_and_sample_data.sql    # Enterprise relational schema & 100k benchmark records
    ├── 03_indexing_and_optimization.sql # B-Tree, GIN, Composite indexes & EXPLAIN ANALYZE queries
    ├── 04_backup_and_recovery.sql       # Logical backups, PITR procedures & WAL archiving
    ├── 05_monitoring_and_diagnostics.sql # Active connection tracking, lock waits & cache hit ratios
    └── backup_automation.ps1           # Automated PowerShell backup rotation script
```

---

## Quick Start Guide

### 1. Launch the Lab Environment
From the `postgresql-dba-lab/` directory, execute:
```bash
docker-compose up -d
```
Verify that all 3 containers are running:
```bash
docker-compose ps
```

### 2. Connect to the Primary Instance
```bash
docker exec -it postgres_primary_lab psql -U lab_admin -d dba_lab_db
```

---

## Lab Modules

### Module 01: User & Role Management (RBAC)
Run the security script to create NOLOGIN roles (`role_read_only`, `role_data_analyst`, `role_app_developer`), assign user accounts, configure schema permissions, and enforce Row-Level Security (RLS):
```bash
docker exec -i postgres_primary_lab psql -U lab_admin -d dba_lab_db < scripts/01_user_and_role_management.sql
```

### Module 02: Schema Creation & Benchmark Data
Build the `sales` enterprise schema and generate 100,000 order records using `generate_series()` for query optimization:
```bash
docker exec -i postgres_primary_lab psql -U lab_admin -d dba_lab_db < scripts/02_schema_and_sample_data.sql
```

### Module 03: Indexing Strategies & Query Optimization
Execute `EXPLAIN (ANALYZE, BUFFERS)` benchmarks before and after creating B-Tree, Composite, Partial, and JSONB GIN indexes:
```bash
docker exec -i postgres_primary_lab psql -U lab_admin -d dba_lab_db < scripts/03_indexing_and_optimization.sql
```

### Module 04: Backup & Recovery Procedures
Execute a compressed custom-format logical backup using `pg_dump`:
```bash
docker exec postgres_primary_lab pg_dump -U lab_admin -d dba_lab_db -Fc -v -f /var/lib/postgresql/data/dba_lab_backup.dump
```
Restore the database using `pg_restore`:
```bash
docker exec postgres_primary_lab pg_restore -U lab_admin -d dba_lab_db -j 4 -v /var/lib/postgresql/data/dba_lab_backup.dump
```

### Module 05: Database Monitoring & Lock Diagnostics
Inspect active connections, locked sessions, deadlocks, table bloat, and cache hit ratios:
```bash
docker exec -i postgres_primary_lab psql -U lab_admin -d dba_lab_db < scripts/05_monitoring_and_diagnostics.sql
```

---

## License & Author
- **Author**: Ahmed Mahamud Ahmed
- **Identity**: Cloud Database Administrator | PostgreSQL | SQL Server
