#!/bin/bash
set -eu
apt update
apt install -y nginx php-fpm php-mysql mysql-server
echo "OTEL endpoint is ${OTEL_EXPORTER_OTLP_ENDPOINT}" > /var/log/otel.log
