FROM python:3.14-slim
WORKDIR /app/prod-infra

RUN apt-get update && apt-get install -y \
    bash \
    openssl \
    rsync \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir matplotlib
COPY . /app/prod-infra/
RUN chmod +x *.sh

VOLUME ["/app/prod-infra/archive", "/app/prod-infra/remote_backup_staging"]
CMD ["/bin/bash", "./pipeline_sentinel.sh"]
