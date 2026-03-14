#!/bin/bash
shopt -s extglob

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

function update_table() {
    local table_name
    read -r -p "Enter Table Name to Update: " table_name

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

    if [ ! -s "$CURRENT_DB/$table_name.tbl" ]; then
        echo -e "${RED}No data found in '$table_name'.${RESET}"
        return
    fi

    local pk_value
    read -r -p "Enter the $pk_name (PK) of the row to update: " pk_value

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

    echo ""
    echo "Available columns:"
    for (( i=0; i<${#columns[@]}; i++ )); do
        local parts
        IFS=':' read -r -a parts <<< "${columns[$i]}"
        local col_name="${parts[0]}"
        local col_type="${parts[1]}"
        local col_pk="${parts[2]}"
        if [[ "$col_pk" == "pk" ]]; then
            echo "  $((i + 1))) $col_name ($col_type) [PK]"
        else
            echo "  $((i + 1))) $col_name ($col_type)"
        fi
    done

    local col_num
    read -r -p "Enter column number to update: " col_num

    if [[ ! "$col_num" =~ ^[1-9][0-9]*$ ]] || (( col_num > ${#columns[@]} )); then
        echo -e "${RED}Error: Invalid column number.${RESET}"
        return
    fi

    local target_index=$((col_num - 1))
    local target_parts
    IFS=':' read -r -a target_parts <<< "${columns[$target_index]}"
    local target_name="${target_parts[0]}"
    local target_type="${target_parts[1]}"
    local target_pk="${target_parts[2]}"

    local new_value
    read -r -p "Enter new value for '$target_name': " new_value

    if [[ -z "$new_value" ]]; then
        echo -e "${RED}Error: Value cannot be empty.${RESET}"
        return
    fi

    if [[ "$target_type" == "int" ]]; then
        if [[ ! "$new_value" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Error: '$target_name' must be an integer.${RESET}"
            return
        fi
    fi

    if [[ "$target_pk" == "pk" ]]; then
        if awk -F'|' -v col="$col_num" -v val="$new_value" '$col == val {found=1} END {exit !found}' "$CURRENT_DB/$table_name.tbl" 2>/dev/null; then
            echo -e "${RED}Error: Primary key '$new_value' already exists.${RESET}"
            return
        fi
    fi

    awk -F'|' -v pk_col="$pk_col_num" -v pk_val="$pk_value" -v target_col="$col_num" -v new_val="$new_value" '
    BEGIN { OFS="|" }
    {
        if ($pk_col == pk_val) {
            $target_col = new_val
        }
        print
    }' "$CURRENT_DB/$table_name.tbl" > "$CURRENT_DB/$table_name.tmp"

    mv "$CURRENT_DB/$table_name.tmp" "$CURRENT_DB/$table_name.tbl"

    echo -e "${GREEN}Row with $pk_name = '$pk_value' updated successfully!${RESET}"
    echo -e "${GREEN}Set '$target_name' = '$new_value'.${RESET}"
}
