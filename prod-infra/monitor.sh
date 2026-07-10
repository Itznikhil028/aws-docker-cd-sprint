#!/bin/bash

# Configuration Boundaries
THRESHOLD=70
LOG_FILE="/var/log/nginx/prod_telemetry.log"

# Harvest Host Telemetry Metrics
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

# Write Structured Data Matrix to Host Logs
echo "[$TIMESTAMP] METRICS - CPU: ${CPU_USAGE}% | MEM: ${MEM_USAGE}% | DISK: ${DISK_USAGE}%" | sudo tee -a $LOG_FILE > /dev/null

# Evaluate Alert Boundaries
if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )) || [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "[$TIMESTAMP] ALERT - High System Resource Utilization Detected!" | sudo tee -a $LOG_FILE > /dev/null
fi
