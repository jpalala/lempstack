#!/usr/bin/env sh
set -eu

export OTEL_EXPORTER_OTLP_ENDPOINT=$(echo $OTEL_EXPORTER_OTLP_ENDPOINT | sed 's/http:\/\///g')

envsubst '${OTEL_EXPORTER_OTLP_ENDPOINT}' < /etc/nginx/nginx.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
