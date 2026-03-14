#!/bin/bash
shopt -s extglob

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

function delete_from_table() {
    local table_name
    read -r -p "Enter Table Name to Delete from: " table_name

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

    if [ ! -s "$CURRENT_DB/$table_name.tbl" ]; then
        echo -e "${RED}No data found in '$table_name'.${RESET}"
        return
    fi

    local meta
    meta=$(cat "$CURRENT_DB/$table_name.meta")

    local columns
    IFS='|' read -r -a columns <<< "$meta"

    local pk_index=-1
    local pk_name=""
    local pk_type=""

    local i
    for (( i=0; i<${#columns[@]}; i++ )); do
        local parts
        IFS=':' read -r -a parts <<< "${columns[$i]}"
        if [[ "${parts[2]}" == "pk" ]]; then
            pk_index=$i
            pk_name="${parts[0]}"
            pk_type="${parts[1]}"
            break
        fi
    done

    if [[ $pk_index -eq -1 ]]; then
        echo -e "${RED}Error: No Primary Key defined for this table.${RESET}"
        return
    fi

    local pk_value
    read -r -p "Enter the $pk_name (PK) of the row to delete: " pk_value

    if [[ -z "$pk_value" ]]; then
        echo -e "${RED}Error: Primary Key value cannot be empty.${RESET}"
        return
    fi

    if [[ "$pk_type" == "int" ]]; then
        if [[ ! "$pk_value" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Error: '$pk_name' must be an integer.${RESET}"
            return
        fi
    fi

    local pk_col_num=$((pk_index + 1))
    if ! awk -F'|' -v col="$pk_col_num" -v val="$pk_value" '$col == val {found=1} END {exit !found}' "$CURRENT_DB/$table_name.tbl" 2>/dev/null; then
        echo -e "${RED}Error: No row found with $pk_name = '$pk_value'.${RESET}"
        return
    fi

    local confirm
    read -r -p "Are you sure you want to delete row with $pk_name = '$pk_value'? (y/n): " confirm

    if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
        echo -e "${RED}Delete cancelled.${RESET}"
        return
    fi

    awk -F'|' -v col="$pk_col_num" -v val="$pk_value" '$col != val' "$CURRENT_DB/$table_name.tbl" > "$CURRENT_DB/$table_name.tmp"

    mv "$CURRENT_DB/$table_name.tmp" "$CURRENT_DB/$table_name.tbl"

    echo -e "${GREEN}Row with $pk_name = '$pk_value' deleted successfully!${RESET}"
}