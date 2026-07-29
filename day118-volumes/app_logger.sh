#!/bin/bash
mkdir -p /var/log/app_data

echo "=== App Logger Initialized: $(date) ===" >> /var/log/app_data/production.log

while true; do
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] TRANSACTION_ID=$RANDOM STATUS=SUCCESS DATA_PAYLOAD=OK" >> /var/log/app_data/production.log
  sleep 5
done
