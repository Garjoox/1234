-- ==========================================================================
-- POSTGRESQL DBA LAB - LAB 04: BACKUP & DISASTER RECOVERY PROCEDURES
-- ==========================================================================

/*
  --------------------------------------------------------------------------
  PART 1: LOGICAL BACKUP COMMANDS (CLI EXECUTION)
  --------------------------------------------------------------------------
  
  1. Plain Text SQL Dump (Schema + Data):
     pg_dump -h localhost -U lab_admin -d dba_lab_db -Fp -f /var/lib/postgresql/backups/dba_lab_backup.sql

  2. Compressed Custom Format Backup (Supports Multi-threaded Parallel Restore):
     pg_dump -h localhost -U lab_admin -d dba_lab_db -Fc -v -f /var/lib/postgresql/backups/dba_lab_backup.dump

  3. Schema-Only Dump:
     pg_dump -h localhost -U lab_admin -d dba_lab_db -s -Fp -f /var/lib/postgresql/backups/dba_lab_schema.sql

  4. Full Database Cluster Dump (Includes Roles and Tablespaces):
     pg_dumpall -h localhost -U lab_admin -f /var/lib/postgresql/backups/cluster_full.sql

  --------------------------------------------------------------------------
  PART 2: RESTORE PROCEDURES
  --------------------------------------------------------------------------

  1. Restore Custom Format Dump using pg_restore with 4 parallel jobs:
     pg_restore -h localhost -U lab_admin -d dba_lab_db -j 4 -v /var/lib/postgresql/backups/dba_lab_backup.dump

  2. Selective Single Table Restore:
     pg_restore -h localhost -U lab_admin -d dba_lab_db -t orders /var/lib/postgresql/backups/dba_lab_backup.dump

  --------------------------------------------------------------------------
  PART 3: POINT-IN-TIME RECOVERY (PITR) STEP-BY-STEP
  --------------------------------------------------------------------------
  1. Base Backup creation via pg_basebackup:
     pg_basebackup -h localhost -U replicator -D /var/lib/postgresql/base_backups/base_01 -Fp -Xs -P

  2. Create signal file for recovery target in standby.signal or recovery.conf:
     restore_command = 'cp /var/lib/postgresql/wal_archive/%f "%p"'
     recovery_target_time = '2026-08-11 12:00:00'
     recovery_target_action = 'promote'
*/

-- Verification Query: Check WAL Archiving Status
SELECT 
    archived_count,
    last_archived_wal,
    last_archived_time,
    failed_count,
    last_failed_wal
FROM pg_stat_archiver;
