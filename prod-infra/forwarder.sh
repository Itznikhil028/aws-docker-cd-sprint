#!/bin/bash

# Configuration Paths
SOURCE_LOG="/var/log/nginx/prod_telemetry.log"
ARCHIVE_DIR="/home/ubuntu/my-website/prod-infra/archive"
BACKUP_LOG="$ARCHIVE_DIR/central_alerts.log"

# Initialize Secure Archival Target Directory
if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir -p "$ARCHIVE_DIR"
fi

# Extract and Ship Only Critical Breach Signals
if [ -f "$SOURCE_LOG" ]; then
    # Filter lines containing ALERT and append them to the central log file cleanly
    sudo grep "ALERT" "$SOURCE_LOG" >> "$BACKUP_LOG" 2>/dev/null
    
    # Optional: Deduplicate entries so the central file stays completely clean
    if [ -f "$BACKUP_LOG" ]; then
        sort -u "$BACKUP_LOG" -o "$BACKUP_LOG"
    fi
fi
