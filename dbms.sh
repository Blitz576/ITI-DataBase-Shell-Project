#!/bin/bash
#DataBase Main System

# change the select prompt
PS3="Main System > "
export LC_COLLATE=C
shopt -s extglob

# main functions

function create_main_DataBase_directory () {
    echo "Welcome to our Bash Sql system."
    echo "After reading this line, a database directory has been created in your current directory under the name of 'DataBases'."
    echo "If you have used our program before, don't worry ..."
    
    if [ ! -d "DataBases" ]; then
        mkdir "DataBases"
    fi
}

function createDataBase () {
    local local_dbName="$1"
    while [ -d "database/$local_dbName" ]; do
        echo "$local_dbName Already Exists. Please Enter Another Name: "
        read local_dbName
    done

    case $local_dbName in
        [0-9]*)
            echo "Database Name Cannot Start With Numbers."
            ;;
        *" "*)
            echo "Database Name Should Not Have Any Spaces."
            ;;
        *[!a-zA-Z]*)
            echo "Database Name Cannot Have Special Characters."
            ;;
        *)
            mkdir -p "database/$local_dbName"
            echo "$local_dbName Created Successfully."
            ;;
    esac
}

# create a directory for user databases
create_main_DataBase_directory


select menu in "Create a Database" "List Databases" "Connect To Database" "Drop Database" "Exit"; do
    case $REPLY in
        1)
            echo "Enter the database name: "
            read dbName
            createDataBase "$dbName"
            ;;
        2)
            if [ -n "$(ls -d database/*/)" ]; then
                echo "Available Databases:"
                ls -d database/*/ | sed 's|.*/||'
            else
                echo "There Are No Databases"
            fi
            ;;
        3)
            echo "Option 3 is chosen"
            ;;
        4)
            echo "Option 4 is chosen"
            ;;
        5)
            echo "System ended."
            break
            ;;
        *)
            echo "Invalid option. Please choose a number between 1 and 5."
            ;;
    esac
done
