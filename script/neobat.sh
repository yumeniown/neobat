#!/bin/bash

# project's folder 
PROJECT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

# ASCII art path
NEOBAT_ART="$PROJECT_DIR/src/ascii_art/neobat.txt"
ASCII_ART="$PROJECT_DIR/src/ascii_art/logo.txt"

# get info about battery
BAT=$(upower -i $(upower -e | grep battery) | grep -E "percentage|state|time to empty|capacity" | awk '
/percentage/ { percentage = $0 }
/state/ { state = $0 }
/time to empty/ { time_to_empty = $0 }
/capacity/ { capacity = $0 }
END {
    if (percentage) print percentage;
    if (state) print state;
    if (time_to_empty) print time_to_empty;
    if (capacity) print capacity;
}')  

# colors
PURPLE="\033[1;35m"
RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

# prepare the lines
mapfile -t ART_LINES < "$ASCII_ART"
mapfile -t INFO_LINES < <(echo "$BAT")
mapfile -t NEOBAT_LINES < "$NEOBAT_ART"

# define the width rigth alignment
ART_WIDTH=0
for line in "${ART_LINES[@]}"; do
    len=${#line}
    (( len > ART_WIDTH )) && ART_WIDTH=$len
done

# max row count
max_lines=$((${#ART_LINES[@]} > (${#INFO_LINES[@]} + ${#NEOBAT_LINES[@]}) ? ${#ART_LINES[@]} : (${#INFO_LINES[@]} + ${#NEOBAT_LINES[@]})))


# output everything
NEOBAT_LEN=${#NEOBAT_LINES[@]}
INFO_LEN=${#INFO_LINES[@]}

for ((i=0; i<max_lines; i++)); do
    art_line="${ART_LINES[i]:-}"
    
    if (( i < NEOBAT_LEN )); then
        right_line="${NEOBAT_LINES[i]}"
        printf "${PURPLE}%-${ART_WIDTH}s %s${RESET}\n" "$art_line" "$right_line"
    elif (( i>= NEOBAT_LEN && i < NEOBAT_LEN + INFO_LEN )); then
        info_line="${INFO_LINES[i - NEOBAT_LEN]}"   
        if [[ "$info_line" == *"percentage"* ]]; then
            key="percentage" 
            value="${info_line#*percentage: }"
            printf "${PURPLE}%-${ART_WIDTH}s ${RED}%s:${RESET} ${GREEN}%s${RESET}\n" "$art_line" "$key" "$value"
        elif [[ "$info_line" == *"state"* ]]; then
            key="state"   
            value="${info_line#*state: }"
            printf "${PURPLE}%-${ART_WIDTH}s ${RED}%s:${RESET} ${GREEN}%s${RESET}\n" "$art_line" "$key" "$value"
        elif [[ "$info_line" == *"capacity"* ]]; then
            key="capacity" 
            value="${info_line#*capacity: }"
            printf "${PURPLE}%-${ART_WIDTH}s ${RED}%s:${RESET} ${GREEN}%s${RESET}\n" "$art_line" "$key" "$value"
        elif [[ "$info_line" == *"time to empty"* ]]; then
            key="time to empty"  
            value="${info_line#*time to empty: }"
            printf "${PURPLE}%-${ART_WIDTH}s ${RED}%s:${RESET} ${GREEN}%s${RESET}\n" "$art_line" "$key" "$value"
        else 
            printf "${PURPLE}%-${ART_WIDTH}s %s${RESET}\n" "$art_line" "$info_line"
        fi
    else
        printf "${PURPLE}%s${RESET}\n" "$art_line"
    fi
done
