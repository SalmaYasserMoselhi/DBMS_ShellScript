#!/bin/bash

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

source scripts/schema_builder.sh
source scripts/table_utils.sh
source scripts/insert.sh
source scripts/select.sh
source scripts/update.sh

function table_menu() {
    local db_name
    db_name=$(basename "$CURRENT_DB")

    while true; do
        echo ""
        echo "  Connected to: $db_name"
        echo "1) Create Table"
        echo "2) List Tables"
        echo "3) Drop Table"
        echo "4) Insert into Table"
        echo "5) Select from Table"
        echo "6) Update Table"
        echo "7) Exit to Main Menu"
        read -r -p "$db_name >> " choice

        case $choice in
            1) create_table ;;
            2) list_tables ;;
            3) drop_table ;;
            4) insert_into_table ;;
            5) select_from_table ;;
            6) update_table ;;
            7)
                echo -e "${GREEN}Returning to Main Menu...${RESET}"
                return
                ;;
            *)
                echo -e "${RED}Invalid choice, Please select a valid option.${RESET}"
                ;;
        esac
    done
}
