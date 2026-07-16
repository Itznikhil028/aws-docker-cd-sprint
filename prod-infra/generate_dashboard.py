import os
import subprocess
import matplotlib.pyplot as plt
from datetime import datetime

# Path Configurations
SOURCE_LOG = "/var/log/nginx/prod_telemetry.log"
OUTPUT_IMAGE = "/home/ubuntu/my-website/prod-infra/archive/system_health.png"

# Step 1: Parse plaintext metric records out of the telemetry log
timestamps = []
cpu_metrics = []
mem_metrics = []

try:
    # Read the active telemetry repository
    raw_logs = subprocess.check_output(f"sudo cat {SOURCE_LOG}", shell=True, text=True)
    for line in raw_logs.strip().split("\n"):
        if "METRICS" in line:
            # Expected format: [2026-07-16 12:00:01] METRICS - CPU: 4.5% | MEM: 39.2%
            try:
                parts = line.split("] METRICS - ")
                time_str = parts[0].strip("[")
                metrics_part = parts[1]
                
                cpu = float(metrics_part.split("CPU: ")[1].split("%")[0])
                mem = float(metrics_part.split("MEM: ")[1].split("%")[0])
                
                timestamps.append(datetime.strptime(time_str, "%Y-%m-%d %H:%M:%S"))
                cpu_metrics.append(cpu)
                mem_metrics.append(mem)
            except Exception:
                continue
except Exception as e:
    print(f"ERROR: Metrics gathering failed: {e}")
    exit(1)

if not timestamps:
    print("No metric historical rows parsed. Charting sequence cancelled.")
    exit(1)

# Step 2: Plot data lines cleanly using Matplotlib
plt.figure(figsize=(10, 5))
plt.plot(timestamps, cpu_metrics, label="CPU Usage (%)", color="cyan", linewidth=2)
plt.plot(timestamps, mem_metrics, label="Memory Usage (%)", color="magenta", linewidth=2)

plt.title("Production System Performance Monitoring Dashboard", fontsize=14, color="white", pad=15)
plt.xlabel("Execution Timeline", fontsize=12, color="white")
plt.ylabel("Utilization Percentage (%)", fontsize=12, color="white")
plt.grid(True, linestyle="--", alpha=0.3)
plt.legend(loc="upper left")

# Set Dark Theme Workspace Styling
plt.gcf().patch.set_facecolor("#121212")
plt.gca().set_facecolor("#1e1e1e")
plt.gca().tick_params(colors="white")
plt.gca().xaxis.label.set_color("white")
plt.gca().yaxis.label.set_color("white")
plt.xticks(rotation=15)
plt.tight_layout()

# Save analytical chart graph to storage archive
plt.savefig(OUTPUT_IMAGE, facecolor=plt.gcf().get_facecolor(), edgecolor='none')
print(f"SUCCESS: System Performance Trends Rendered to {OUTPUT_IMAGE}")
