#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'

HISTSIZE=1000
exit_cmd="exit"
pidfile="pid.txt"
HISTFILESIZE=1000
trap 'send_pid 0' EXIT
trap handle_signal SIGUSR1
HISTFILE=~/.minishell_history

send_pid() 
{
    local pid="$1"
    echo "$pid" > "$pidfile"
}
current_pid=$$
send_pid "$current_pid"

execute_command_in_bash() 
{
    local command="$1"
    eval "$command"
}


handle_signal() 
{
    if [[ -f /tmp/signal_data.txt ]]; 
    then
        signal_command=$(cat /tmp/signal_data.txt)
        execute_command_in_bash echo " "
        execute_command_in_bash "$signal_command"
        print_prompt 
        rm /tmp/signal_data.txt
    fi
}

print_prompt() 
{
    Bash="Client_Bash~"
    path=$(pwd | sed "s|/home/$(whoami)||")
    prompt="$(echo -e ${GREEN}$Bash${NC})$path$ "
    read -ep "$prompt" command
    execute_command_in_bash "$command"
    print_prompt
    history -s "$command"
    history -w
}

while true; 
do
    print_prompt
done
