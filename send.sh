#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
pidfile="pid.txt"
PID=$(cat "$pidfile")
MESSAGE=$*

usage() 
{
    echo -e "${RED}Usage: $0 <message>${NC}"
    exit 1
}

if [ $# -lt 1 ]; 
then
    usage
fi


if [ ! -f "$pidfile" ]; 
then
    echo "PID file not found: $pidfile"
    exit 1
fi

if [ "$PID" -eq 0 ]; 
then
    echo -e "${RED}Minishell is not running${NC}"
    exit 1
fi

if ! kill -0 "$PID" 2>/dev/null; 
then
    echo -e "${RED}PID $PID is not running${NC}"
    exit 1
fi

echo "$MESSAGE" > /tmp/signal_data.txt

kill -USR1 "$PID"
