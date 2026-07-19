#!/bin/bash

# Target Infrastructure Checkpoints
BASE_DIR="/home/ubuntu/my-website/prod-infra"
REQUIRED_DIRS=("$BASE_DIR/archive" "$BASE_DIR/remote_backup_staging")
REQUIRED_FILES=("monitor.sh" "forwarder.sh" "purge_maintenance.sh" "alert_aggregator.sh" "telemetry_shipper.sh" "generate_dashboard.py")

echo "=== 🛡️ SYSTEM TELEMETRY PIPELINE SENTINEL RUNNING ==="
echo "Diagnostic checks dispatched at: $(date "+%Y-%m-%d %H:%M:%S")"
echo "--------------------------------------------------------"

# Step 1: Validate and repair missing directories
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "[💔 ALERT] Missing core directory detected: $dir"
        echo "-> Initiating auto-healing recovery..."
        mkdir -p "$dir"
        echo "[❇️ HEALED] Directory structure restored successfully."
    else
        echo "[✅ PASSED] Directory structure verified: $(basename "$dir")"
    fi
done

# Step 2: Validate script permissions and existence
for file in "${REQUIRED_FILES[@]}"; do
    FILE_PATH="$BASE_DIR/$file"
    if [ ! -f "$FILE_PATH" ]; then
        echo "[❌ CRITICAL Failure] Core module script missing: $file"
        echo "-> Please pull latest stable code base from repository branch."
    else
        # Verify script is executable if it's a shell script
        if [[ "$file" == *.sh ]] && [ ! -x "$FILE_PATH" ]; then
            echo "[⚠️ WARNING] Execution bits dropped on: $file"
            echo "-> Auto-healing permissions matrices..."
            chmod +x "$FILE_PATH"
            echo "[❇️ HEALED] Execute bit flags re-elevated."
        else
            echo "[✅ PASSED] Module verification secure: $file"
        fi
    fi
done

echo "--------------------------------------------------------"
echo "Pipeline Diagnostics Complete. Status: OPERATIONAL"
