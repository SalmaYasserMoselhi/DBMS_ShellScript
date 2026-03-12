#!/bin/bash

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

# List and Drop tables inside the connected database

function list_tables() {
    echo ""
    echo "=============================="
    echo "     Tables in $(basename "$CURRENT_DB")"
    echo "=============================="

    local found=false
    local count=1

    for tbl_file in "$CURRENT_DB"/*.tbl; do
        if [ ! -f "$tbl_file" ]; then
            break
        fi
        found=true
        local tbl_name
        tbl_name=$(basename "$tbl_file" .tbl)
        echo "$count) $tbl_name"
        count=$((count + 1))
    done

    if [[ "$found" == false ]]; then
        echo -e "${RED}No tables found.${RESET}"
    fi
}

function drop_table() {
    read -r -p "Enter Table Name to Drop: " table_name

    if [[ -z "$table_name" ]]; then
        echo -e "${RED}Error: Table name cannot be empty.${RESET}"
        return
    fi

    table_name=$(tr ' ' '_' <<< "$table_name")

    case $table_name in
        +([A-Za-z0-9_]))
            if [ ! -f "$CURRENT_DB/$table_name.tbl" ]; then
                echo -e "${RED}Error: Table '$table_name' does not exist.${RESET}"
            else
                read -r -p "Are you sure you want to drop '$table_name'? (y/n): " confirm
                if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
                    rm -f -- "$CURRENT_DB/$table_name.meta"
                    rm -f -- "$CURRENT_DB/$table_name.tbl"
                    echo -e "${GREEN}Table '$table_name' dropped successfully.${RESET}"
                else
                    echo -e "${RED}Drop cancelled.${RESET}"
                fi
            fi
        ;;
        *)
            echo -e "${RED}Error: Table name can only contain letters, numbers, and underscores.${RESET}"
        ;;
    esac
}
