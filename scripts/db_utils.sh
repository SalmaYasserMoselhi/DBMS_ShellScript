#!/bin/bash
shopt -s extglob

GREEN="\e[0;32m"
RED="\e[0;31m"
RESET="\e[0m"

function list_databases(){
    echo ""
    echo "=============================="
    echo "       Available Databases"
    echo "=============================="
    if [ -z "$(ls databases/ 2>/dev/null)" ]; then
        echo -e "${RED}No databases found.${RESET}"
        return
    fi
    count=1
    for db_path in databases/*; do
        if [ -d "$db_path" ]; then
            db=$(basename "$db_path")
            echo "$count) $db"
            count=$((count + 1))
        fi
    done
}

function drop_database(){
    read -r -p "Enter Database Name to Drop: " db_name

    if [[ -z "$db_name" ]]; then
        echo -e "${RED}Error: Database name cannot be empty.${RESET}"
        return
    fi

    db_name=$(tr ' ' '_' <<< "$db_name")

    case $db_name in
        +([A-Za-z0-9_]))
            if [ ! -d "databases/$db_name" ]; then
                echo -e "${RED}Error: Database '$db_name' does not exist.${RESET}"
            else
                read -r -p "Are you sure you want to drop '$db_name'? (y/n): " confirm
                if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
                    rm -r -- "databases/$db_name"
                    echo -e "${GREEN}Database '$db_name' dropped successfully.${RESET}"
                else
                    echo -e "${RED}Drop cancelled.${RESET}"
                fi
            fi
        ;;
        *)
            echo -e "${RED}Error: Database name can only contain letters, numbers, and underscores.${RESET}"
        ;;
    esac
}

function connect_to_database(){
    read -r -p "Enter Database Name to Connect: " db_name

    if [[ -z "$db_name" ]]; then
        echo -e "${RED}Error: Database name cannot be empty.${RESET}"
        return
    fi

    db_name=$(tr ' ' '_' <<< "$db_name")

    case $db_name in
        +([A-Za-z0-9_]))
            if [ ! -d "databases/$db_name" ]; then
                echo -e "${RED}Error: Database '$db_name' does not exist.${RESET}"
            else
                export CURRENT_DB="databases/$db_name"
                echo -e "${GREEN}Connected to database '$db_name' successfully.${RESET}"

                if [ ! -f scripts/table_menu.sh ]; then
                    echo -e "${RED}Error: Table menu not found.${RESET}"
                    return
                fi

                source scripts/table_menu.sh
                table_menu
            fi
        ;;
        *)
            echo -e "${RED}Error: Database name can only contain letters, numbers, and underscores.${RESET}"
        ;;
    esac
}