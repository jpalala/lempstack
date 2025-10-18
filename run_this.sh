mkdir -p logs
export LOKI_ENDPOINT=http://loki:3100/loki/api/v1/push   # Replace with real one
docker compose up -d

