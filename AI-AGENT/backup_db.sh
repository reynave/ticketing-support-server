#!/bin/bash
BACKUP_DIR="/home/crma2118/backupDb/ticket"
DB_NAME="crma2118_support_ticket"
DB_USER="crma2118_thinktank"
DB_PASS="Np?ebpkL?dDQ=w~H"
DATE=$(date +%F)

mysqldump -u"$DB_USER" -p"$DB_PASS" --single-transaction --routines "$DB_NAME" | gzip > "$BACKUP_DIR/${DB_NAME}_$DATE.sql.gz"

# hapus backup lebih dari 60 hari
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +60 -delete