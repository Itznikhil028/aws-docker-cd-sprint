#!/bin/bash

# Configuration Paths
SOURCE_LOG="/var/log/nginx/prod_telemetry.log"
ARCHIVE_DIR="/home/ubuntu/my-website/prod-infra/archive"
BACKUP_LOG="$ARCHIVE_DIR/central_alerts.log"
ENC_LOG="$ARCHIVE_DIR/central_alerts.enc"

# Secure Cryptographic Passphrase Ingestion from Host Environment Variable
if [ -z "$TELEMETRY_KEY" ]; then
    echo "ERROR: TELEMETRY_KEY environment variable is not defined. Aborting." >> /var/log/nginx/prod_error.log
    exit 1
fi

# Initialize Target Directories
if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir -p "$ARCHIVE_DIR"
fi

# Extract, Deduplicate, and Cryptographically Seal Alert Signals
if [ -f "$SOURCE_LOG" ]; then
    sudo grep "ALERT" "$SOURCE_LOG" >> "$BACKUP_LOG" 2>/dev/null
    
    if [ -f "$BACKUP_LOG" ]; then
        sort -u "$BACKUP_LOG" -o "$BACKUP_LOG"
        
        # Sealed using the dynamically loaded environment secret context
        openssl enc -aes-256-cbc -salt -pbkdf2 -in "$BACKUP_LOG" -out "$ENC_LOG" -pass pass:"$TELEMETRY_KEY"
        
        rm -f "$BACKUP_LOG"
    fi
fi
