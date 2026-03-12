#!/bin/bash

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

source scripts/schema_builder.sh
source scripts/table_utils.sh

function table_menu() {
    local db_name
    db_name=$(basename "$CURRENT_DB")

    while true; do
        echo ""
        echo "  Connected to: $db_name"
        echo "1) Create Table"
        echo "2) List Tables"
        echo "3) Drop Table"
        echo "4) Exit to Main Menu"
        read -r -p "$db_name >> " choice

        case $choice in
            1) create_table ;;
            2) list_tables ;;
            3) drop_table ;;
            4)
                echo -e "${GREEN}Returning to Main Menu...${RESET}"
                return
                ;;
            *)
                echo -e "${RED}Invalid choice, Please select a valid option.${RESET}"
                ;;
        esac
    done
}
