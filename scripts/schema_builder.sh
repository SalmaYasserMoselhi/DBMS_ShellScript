#!/bin/bash

# Table creation with meta schema 

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

function create_table() {
    read -r -p "Enter Table Name: " table_name

    if [[ -z "$table_name" ]]; then
        echo -e "${RED}Error: Table name cannot be empty.${RESET}"
        return
    fi

    table_name=$(tr ' ' '_' <<< "$table_name")

    case $table_name in
        +([A-Za-z0-9_]))
            if [[ $table_name = [0-9]* ]]; then
                echo -e "${RED}Error: Table name cannot start with a number.${RESET}"
                return
            elif [[ $table_name = _* ]]; then
                echo -e "${RED}Error: Table name cannot start with underscore.${RESET}"
                return
            fi
        ;;
        *)
            echo -e "${RED}Error: Table name can only contain letters, numbers, and underscores.${RESET}"
            return
        ;;
    esac

    if [ -f "$CURRENT_DB/$table_name.meta" ]; then
        echo -e "${RED}Error: Table '$table_name' already exists.${RESET}"
        return
    fi

    read -r -p "Enter number of columns: " col_count

    if [[ ! "$col_count" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "${RED}Error: Column count must be a positive number.${RESET}"
        return
    fi

    schema=""
    pk_column=""
    col_names=()

    for (( i=1; i<=col_count; i++ )); do
        echo "--- Column $i of $col_count ---"

        read -r -p "  Column name: " col_name

        if [[ -z "$col_name" ]]; then
            echo -e "  ${RED}Error: Column name cannot be empty.${RESET}"
            return
        fi

        col_name=$(tr ' ' '_' <<< "$col_name")

        case $col_name in
            +([A-Za-z0-9_]))
                if [[ $col_name = [0-9]* ]]; then
                    echo -e "  ${RED}Error: Column name cannot start with a number.${RESET}"
                    return
                elif [[ $col_name = _* ]]; then
                    echo -e "  ${RED}Error: Column name cannot start with underscore.${RESET}"
                    return
                fi
            ;;
            *)
                echo -e "  ${RED}Error: Column name can only contain letters, numbers, and underscores.${RESET}"
                return
            ;;
        esac

        for existing in "${col_names[@]}"; do
            if [[ "$existing" == "$col_name" ]]; then
                echo -e "  ${RED}Error: Column '$col_name' already exists.${RESET}"
                return
            fi
        done
        col_names+=("$col_name")

        read -r -p "  Data type (int/str): " col_type

        if [[ "$col_type" != "int" && "$col_type" != "str" ]]; then
            echo -e "  ${RED}Error: Data type must be 'int' or 'str'.${RESET}"
            return
        fi

        if [[ -z "$schema" ]]; then
            schema="$col_name:$col_type"
        else
            schema="$schema|$col_name:$col_type"
        fi
    done

    echo ""
    echo "Available columns: ${col_names[*]}"
    read -r -p "Enter Primary Key column name: " pk_column

    pk_found=false
    for name in "${col_names[@]}"; do
        if [[ "$name" == "$pk_column" ]]; then
            pk_found=true
            break
        fi
    done

    if [[ "$pk_found" == false ]]; then
        echo -e "${RED}Error: '$pk_column' is not a valid column name.${RESET}"
        return
    fi

    schema=$(echo "$schema" | sed -E "s/(^|\|)($pk_column:[a-z]+)/\1\2:pk/")

    echo "$schema" > "$CURRENT_DB/$table_name.meta"

    touch "$CURRENT_DB/$table_name.tbl"

    echo -e "${GREEN}Table '$table_name' created successfully!${RESET}"
    echo -e "${GREEN}Schema: $schema${RESET}"
}
