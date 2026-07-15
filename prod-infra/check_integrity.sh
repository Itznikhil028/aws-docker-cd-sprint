#!/bin/bash

# Configuration Targets
ARCHIVE_DIR="/home/ubuntu/my-website/prod-infra/archive"
HASH_FILE="$ARCHIVE_DIR/central_alerts.sha256"

if [ ! -f "$HASH_FILE" ]; then
    echo "CRITICAL ERROR: Baseline integrity validation signature file missing!"
    exit 1
fi

echo "=== LOG INTEGRITY AUDIT DISPATCH ==="
echo "Status: Running SHA-256 Checksum Matching Verification..."
echo "--------------------------------------------------------"

# Run internal core verification check
sha256sum -c "$HASH_FILE" --status

if [ $? -eq 0 ]; then
    echo "-> INTEGRITY PROFILE: PASSED"
    echo "-> Forensic Status: SECURE (Zero unauthorized file changes detected)."
else
    echo "-> INTEGRITY PROFILE: !!! FAILED !!!"
    echo "-> Forensic Status: TAMPERED / CORRUPTED (Telemetry archive modified out-of-band)."
fi
echo "--------------------------------------------------------"
