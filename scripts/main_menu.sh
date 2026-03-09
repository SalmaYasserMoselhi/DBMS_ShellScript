#!/bin/bash
source scripts/db_utils.sh

function create_database() {
    read -p "Enter Database Name: " db_name
    
    if [[ $db_name == "" ]]; then
        echo "Error: Database name cannot be empty."
        return
    fi

    if (( ${#db_name} < 2 )) || (( ${#db_name} > 50 )); then
        echo "Error: Database name must be between 2 and 50 characters."
        return
    fi

    if [[ ! "$db_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Error: Database name must start with a letter or underscore, and can only contain letters, numbers, and underscores."
        return
    fi
    
    if [ -d "databases/$db_name" ]; then
        echo "Error: Database '$db_name' already exists."
        return
    fi
    
    mkdir "databases/$db_name"
    echo "Database '$db_name' created successfully!"
}


function main_menu() {
    while true; do
        echo ""
        echo "=============================="
        echo "      DBMS MAIN MENU"
        echo "=============================="
        echo "1) Create Database"
        echo "2) List Databases"
        echo "3) Connect to Database"
        echo "4) Drop Database"
        echo "5) Exit"
        echo "=============================="
        read -p "Enter your choice (1-5): " choice
        
        case $choice in
            1) create_database ;;
            2) list_databases ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5) 
               echo "We Love You :) Goodbye"
               exit 0 
               ;;
            *) echo "Invalid choice, Please select between 1 and 5." ;;
        esac
    done
}
