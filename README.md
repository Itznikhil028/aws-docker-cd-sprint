# 🚀 Enterprise Multi-Container Infrastructure on AWS (Docker Compose)

A production-ready, automated multi-container web architecture deployed seamlessly on AWS cloud. Built using Docker Compose, featuring custom internal bridge network isolation, active HTTP health checks, dynamic environment overrides, and deterministic dependency ordering.

---

## 🌐 Live Project Preview

The application is fully automated via GitOps principles and successfully serving live traffic from AWS EC2.

<img width="1898" height="1013" alt="image" src="https://github.com/user-attachments/assets/b46fa295-c5e8-489e-821e-b0f0dcfefe6a" />

---

## 🏗️ Architecture & Topology


  +-----------------------------------+
                      |            AWS EC2                |
                      |    (Ubuntu 26.04 / Public IP)     |
                      +-----------------------------------+
                                        |
                                        | Port 8080 (Published)
                                        v
            +-------------------------------------------------------+
            |     Custom Bridge: prod-infra_internal_telemetry_net|
            |                                                       |
            |  +---------------------+     +---------------------+  |
            |  |   app-gateway       |     |  telemetry-sentinel |  |
            |  |   (Nginx Alpine)    |     |  (Core Pipeline)    |  |
            |  |                     |     |                     |  |
            |  |  Health check: OK   |<----+ Depends on Healthy  |  |
            |  +---------------------+     +---------------------+  |
            +-------------------------------------------------------+


---

## ⚡ Key Technical Highlights

* **Custom Isolated Bridge Network (`internal_telemetry_net`):** Enforces private container-to-container communication without exposing internal microservices directly to the public internet.
* **Deterministic Service Startup (`depends_on` + `service_healthy`):** Configured active HTTP probes (`wget` checks) on `app-gateway`. Upstream services dynamically hold initialization until the gateway passes health validation (~6s warmup window).
* **Multi-Environment Orchestration:** Clean separation between core production configurations (`docker-compose.yml`) and local development overrides (`docker-compose.override.yml`).
* **CI/CD & GitOps Integration:** GitHub-driven workflow for automated syntax validation, integration checks, and deployment.

---

## 🛠️ Tech Stack

* **Cloud Infrastructure:** AWS (EC2, Security Groups, VPC)
* **Containerization & Orchestration:** Docker, Docker Compose (V2)
* **Reverse Proxy & Web Server:** Nginx (Alpine)
* **CI/CD Automation:** GitHub Actions & Git workflows
* **OS & Scripting:** Linux / Ubuntu, Bash, YAML

---

## 🚀 Execution Commands

### Production Mode (Strict Config)
```bash
sudo docker compose -f docker-compose.yml up -d


Local / Dev Mode (Merged Overrides)
Bash
sudo docker compose up -d


Health & Stack Status Check
Bash
sudo docker compose ps -a
curl http://localhost:8080


