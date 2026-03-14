#!/bin/bash
shopt -s extglob

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

function select_from_table() {

    read -r -p "Enter Table Name: " table_name
    if [[ -z "$table_name" ]]; then
        echo -e "${RED}Error: Table name cannot be empty.${RESET}"
        return
    fi

    table_name=$(tr ' ' '_' <<< "$table_name")
    case $table_name in
        +([A-Za-z0-9_]))
            if [ ! -f "$CURRENT_DB/$table_name.meta" ]; then
                echo -e "${RED}Error: Table '$table_name' does not exist.${RESET}"
                return
            fi
        ;;
        *)
            echo -e "${RED}Error: Table name can only contain letters, numbers, and underscores.${RESET}"
            return
        ;;
    esac

    local meta_line
    meta_line=$(cat "$CURRENT_DB/$table_name.meta")
    local header=""
    IFS='|' read -r -a columns <<< "$meta_line"
    for col_def in "${columns[@]}"; do
        IFS=':' read -r -a parts <<< "$col_def"
        local col_name="${parts[0]}"
        if [[ -z "$header" ]]; then
            header="$col_name"
        else
            header="$header|$col_name"
        fi
    done

    if [ ! -s "$CURRENT_DB/$table_name.tbl" ]; then
        echo -e "${RED}No data found in '$table_name'.${RESET}"
        return
    fi
   
    echo ""
    echo "=============================="
    echo "     Table: $table_name"
    echo "=============================="
    (echo "$header"; cat "$CURRENT_DB/$table_name.tbl") | column -t -s '|'

}