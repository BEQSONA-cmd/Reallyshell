#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

HISTSIZE=1000
exit_cmd="exit"
HISTFILESIZE=1000
HISTFILE=~/.minishell_history

# receiver_host="127.0.0.1"
# receiver_host="54.242.110.206"
# receiver_port="8080"

execute_command_in_bash() 
{
    local command="$1"
    eval "$command"
}

execute_command_in_client() 
{
    message="$1"
    response="HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{\"message\": \"$message\"}"
    echo -ne "$response" | nc -l -p 8080 -q 0
}

while true; 
do
    Bash="Reallyshell~"
    path=$(pwd | sed "s|/home/$(whoami)||")
    prompt="$(echo -e ${GREEN}$Bash${NC})$path$ "
    read -ep "$prompt" command
    if [ "$command" == "$exit_cmd" ]; then
        break
    fi
    execute_command_in_client "$command" "$receiver_host" "$receiver_port"
    sleep 0.0001
    execute_command_in_bash "$command"
    history -s "$command"
    history -w
done
