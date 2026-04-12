#!/bin/bash
set -e

start_services() {
  docker compose up -d
}

stop_services() {
  docker compose stop
}

down_services() {
  docker compose down --volumes --rmi all
}

services_status() {
  local GREEN='\033[0;32m'
  local RED='\033[0;31m'
  local NC='\033[0m'

  RUNNING_SERVICES=$(docker compose ps --filter status=running --format "{{.Name}}")
  EXITED_SERVICES=$(docker compose ps --filter status=exited --format "{{.Name}}")

  if [[ -n "$RUNNING_SERVICES" ]]; then
    echo "$RUNNING_SERVICES" | while read -r service; do
      echo -e "$service - ${GREEN}up${NC}"
    done
  fi

  if [[ -n "$EXITED_SERVICES" ]]; then
    echo "$EXITED_SERVICES" | while read -r service; do
      echo -e "$service - ${RED}down${NC}"
    done
  fi

  if [[ -z "$RUNNING_SERVICES" && -z "$EXITED_SERVICES" ]]; then
    echo "No services found."
  fi
}

case "$1" in
  "up")
    start_services
    ;;
  "stop")
    stop_services
    ;;
  "status")
    services_status
    ;;
  "down")
    down_services
    ;;
  *)
    echo "Usage: $0 [up|stop|status|down]"
    exit 1
    ;;
esac