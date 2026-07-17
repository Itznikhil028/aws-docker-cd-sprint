#!/bin/bash

# Path Settings
ENC_LOG="/home/ubuntu/my-website/prod-infra/archive/central_alerts.enc"
DISPATCH_LOG="/home/ubuntu/my-website/prod-infra/archive/critical_breach.log"

if [ -z "$TELEMETRY_KEY" ]; then
    echo "ERROR: TELEMETRY_KEY variable environment state invalid."
    exit 1
fi

echo "=== ALERT AGGREGATION PIPELINE ==="
echo "Decrypting and filtering high-severity records..."

# In-memory stream decryption
DECRYPTED_STREAM=$(openssl enc -aes-256-cbc -d -pbkdf2 -in "$ENC_LOG" -pass pass:"$TELEMETRY_KEY" 2>/dev/null)

if [ ! -z "$DECRYPTED_STREAM" ]; then
    # Filter critical strings and append the latest unique events to dispatch log
    echo "$DECRYPTED_STREAM" | grep "ALERT" | tail -n 5 > "$DISPATCH_LOG"
    echo "SUCCESS: Latest critical vectors isolated inside $DISPATCH_LOG"
else
    echo "FAIL: Cryptographic stream empty or decryption broke."
    exit 1
fi
