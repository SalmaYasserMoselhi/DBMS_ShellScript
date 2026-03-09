#!/bin/bash

function list_databases(){
    echo ""
    echo "=============================="
    echo "       Available Databases"
    echo "=============================="
    if [ -z "$(ls databases/ 2>/dev/null)" ]; then
        echo "No databases found."
        return  
    fi
    count=1
    for db in $(ls databases | sort); do
        echo "$count) $db"
        count=$((count + 1))
    done
}

function drop_database(){
    read -p "Enter Database Name to Drop: " db_name
    if [[ "$db_name" == "" ]]; then
        echo "Error: Database name cannot be empty."
        return
    fi
    if [ ! -d "databases/$db_name" ]; then
        echo "Error: Database '$db_name' does not exist."
        return
    fi
   read -p "Are you sure you want to drop '$db_name'? (y/n): " confirm
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        rm -r -- "databases/$db_name"
        echo "Database '$db_name' dropped successfully."
    else
        echo "Drop cancelled."
    fi
}

function connect_to_database(){
    read -p "Enter Database Name to Connect: " db_name

    if [[ "$db_name" == "" ]]; then
        echo "Error: Database name cannot be empty."
        return
    fi

    if [ ! -d "databases/$db_name" ]; then
        echo "Error: Database '$db_name' does not exist."
        return
    fi

    export CURRENT_DB="databases/$db_name"
    echo "Connected to database '$db_name' successfully."

    if [ ! -f scripts/table_menu.sh ]; then
        echo "Error: Table menu not found."
        return
    fi

    source scripts/table_menu.sh
    table_menu

    
}