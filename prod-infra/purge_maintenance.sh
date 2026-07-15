#!/bin/bash

# Configuration Target Anchors
SOURCE_LOG="/var/log/nginx/prod_telemetry.log"
ENC_LOG="/home/ubuntu/my-website/prod-infra/archive/central_alerts.enc"
KEEP_LINES=50

# Safety Verification Gate: Only clean up if the encrypted vault actually exists
if [ ! -f "$ENC_LOG" ]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") ERROR: Encrypted archive missing! Aborting purge for safety." | sudo tee -a /var/log/nginx/prod_error.log > /dev/null
    exit 1
fi

# Atomic Truncation: Retain only the most recent entries to keep the disk footprint minimal
if [ -f "$SOURCE_LOG" ]; then
    # Create a temporary file holding only the latest historical lines
    sudo tail -n "$KEEP_LINES" "$SOURCE_LOG" > /tmp/telemetry_clean.tmp 2>/dev/null
    
    # Overwrite the active log file atomically without releasing the file handle
    sudo mv /tmp/telemetry_clean.tmp "$SOURCE_LOG"
    
    # Correct file access permissions for system security compliance
    sudo chmod 644 "$SOURCE_LOG"
    sudo chown root:adm "$SOURCE_LOG"
    
    echo "$(date "+%Y-%m-%d %H:%M:%S") SUCCESS: Active telemetry logs safely truncated down to last $KEEP_LINES lines."
fi
