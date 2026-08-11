<#
.SYNOPSIS
    Automated PostgreSQL Backup & Retention Automation Script for Windows / Docker Lab
.DESCRIPTION
    Performs compressed pg_dump exports, rotates old backup files older than 14 days, and logs execution.
#>

$BackupDir = "C:\Users\hp\Desktop\fure\postgresql-dba-lab\backups"
$DateStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = "$BackupDir\dba_lab_backup_$DateStamp.dump"
$LogFile = "$BackupDir\backup_log.txt"

# Ensure Backup Directory Exists
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
}

"[" + (Get-Date) + "] Starting PostgreSQL Automated Dump..." | Out-File -Append -FilePath $LogFile

try {
    # Execute pg_dump inside Docker container
    docker exec postgres_primary_lab pg_dump -U lab_admin -d dba_lab_db -Fc -v -f "/var/lib/postgresql/data/dba_lab_backup_$DateStamp.dump"
    
    "[" + (Get-Date) + "] SUCCESS: Backup created - dba_lab_backup_$DateStamp.dump" | Out-File -Append -FilePath $LogFile
} catch {
    "[" + (Get-Date) + "] ERROR: Backup failed - $_" | Out-File -Append -FilePath $LogFile
}

# Rotate Backups Older Than 14 Days
$RetentionDays = 14
Get-ChildItem -Path $BackupDir -Filter "*.dump" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item -Force
"[" + (Get-Date) + "] Retention Cleanup Completed." | Out-File -Append -FilePath $LogFile
