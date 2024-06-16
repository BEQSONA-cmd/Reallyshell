#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

execute_command_in_client() 
{
    local command="$1"
    local send="bash send.sh $command"
    eval "$send"
}

PORT=8080

PUBLIC_IP=$(curl -s ifconfig.me)

listen_for_signals() 
{
    local PORT="$1"
    echo "ip: $PUBLIC_IP"
    echo "Waiting for signal on port $PORT..."
    while true; do
        read -r line
        if [ -z "$line" ]; then
            continue
        fi
        execute_command_in_client "$line"
        listen_for_signals "$PORT"
    done < <(nc -l -v -p "$PORT")
}

while true; do
    listen_for_signals "$PORT"
done