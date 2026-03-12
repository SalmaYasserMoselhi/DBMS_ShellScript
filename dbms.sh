#!/bin/bash

cd "$(dirname "$0")" || exit 1

source scripts/main_menu.sh

CYAN="\e[0;36m"
WHITE="\e[0;37m"
RESET="\e[0m"

echo ""
echo -e "${CYAN}       DATABASE MANAGER${RESET}"
echo -e "${WHITE}     By Salma & Rana - ITI${RESET}"

main_menu