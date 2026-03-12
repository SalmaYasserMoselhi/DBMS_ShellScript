#!/bin/bash

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

function insert_into_table(){
    read -r -p "Enter Table Name to Insert into: " table_name

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

    IFS='|' read -r -a columns <<< "$meta_line"
    local values=()
    local pk_index=-1
    local pk_value=""

    for (( i=0; i<${#columns[@]}; i++ )); do
        local col_def="${columns[$i]}"

        IFS=':' read -r -a parts <<< "$col_def"
        local col_name="${parts[0]}"
        local col_type="${parts[1]}"
        local col_pk="${parts[2]}"

        local is_pk=false
        if [[ "$col_pk" == "pk" ]]; then
            is_pk=true
            pk_index=$i
        fi

        if [[ "$is_pk" == true ]]; then
            read -r -p "  $col_name ($col_type) [PK]: " value
        else
            read -r -p "  $col_name ($col_type): " value
        fi

        if [[ -z "$value" ]]; then
            echo -e "${RED}Error: Value for '$col_name' cannot be empty.${RESET}"
            return
        fi

        if [[ "$col_type" == "int" ]]; then
            if [[ ! "$value" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}Error: '$col_name' must be an integer.${RESET}"
                return
            fi
        fi

        if [[ "$is_pk" == true ]]; then
            local pk_col_num=$((i + 1))
            if awk -F'|' -v col="$pk_col_num" -v val="$value" '$col == val {found=1} END {exit !found}' "$CURRENT_DB/$table_name.tbl" 2>/dev/null; then
                echo -e "${RED}Error: Primary key '$value' already exists.${RESET}"
                return
            fi
            pk_value="$value"
        fi
        values+=("$value")
    done

    local row=""
    for (( i=0; i<${#values[@]}; i++ )); do
        if [[ -z "$row" ]]; then
            row="${values[$i]}"
        else
            row="$row|${values[$i]}"
        fi
    done
    echo "$row" >> "$CURRENT_DB/$table_name.tbl"
    echo -e "${GREEN}Row inserted successfully!${RESET}"

}