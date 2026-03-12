#!/bin/bash

LC_COLLATE=C
shopt -s extglob

GREEN="\e[0;32m"
RED="\e[0;31m"
YELLOW="\e[1;33m"
RESET="\e[0m"

source scripts/db_utils.sh

function create_database() {
    read -r -p "Enter Database Name: " db_name

    if [[ -z "$db_name" ]]; then
        echo -e "${RED}Error: Database name cannot be empty.${RESET}"
        return
    fi

    db_name=$(tr ' ' '_' <<< "$db_name")

    case $db_name in
        +([A-Za-z0-9_]))
            if [[ $db_name = [0-9]* ]]; then
                echo -e "${RED}Error: Database name cannot start with a number.${RESET}"
            elif [[ $db_name = _* ]]; then
                echo -e "${RED}Error: Database name cannot start with underscore.${RESET}"
            elif (( ${#db_name} < 2 )) || (( ${#db_name} > 50 )); then
                echo -e "${RED}Error: Database name must be between 2 and 50 characters.${RESET}"
            elif [ -d "databases/$db_name" ]; then
                echo -e "${RED}Error: Database '$db_name' already exists.${RESET}"
            else
                mkdir "databases/$db_name"
                echo -e "${GREEN}Database '$db_name' created successfully!${RESET}"
            fi
        ;;
        *)
            echo -e "${RED}Error: Database name can only contain letters, numbers, and underscores.${RESET}"
        ;;
    esac
}


function main_menu() {
    while true; do
        echo ""
        echo "1) Create Database"
        echo "2) List Databases"
        echo "3) Connect to Database"
        echo "4) Drop Database"
        echo "5) Exit"
        echo -e -n "${YELLOW}DBMS >> ${RESET}"
        read -r choice

        case $choice in
            1) create_database ;;
            2) list_databases ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5)
                echo -e "${GREEN}We Love You :) Goodbye${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice, Please select a valid option.${RESET}"
                ;;
        esac
    done
}
