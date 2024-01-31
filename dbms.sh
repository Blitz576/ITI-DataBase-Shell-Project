#!/bin/bash
#DataBase Main System

# change the select prompt
PS3="Main System > "
export LC_COLLATE=C
shopt -s extglob

#######main functions #######

function createDataBasesDirectory () {
    echo "Welcome to our Bash Sql system."
    echo "After reading this line, a database directory has been created in your current directory under the name of 'DataBases'."
    echo "If you have used our program before, don't worry ..."
    
    if [ ! -d "DataBases" ]; then
        mkdir "DataBases"
    fi
}

function createDataBase () {
    local local_dbName="$1"
    while [ -d "DataBases/$local_dbName" ]; do
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
            mkdir -p "DataBases/$local_dbName"
            echo "$local_dbName Created Successfully."
            ;;
    esac
}

function connectToDataBase () {
    local dbName="$1"
    
    if [ -d "DataBases" ] 
    then
          cd "DataBases"
        if [[ -d $dbName ]]; then
            cd "$dbName"
            source ../../tables.sh "$dbName"
        else
          echo "DataBase is not exist"
          cd ..    
        fi
    else
        echo "Missing DataBases directory please create a DataBase"
    fi
    
}

function dropDataBase() {
    
    if [ ! -d "databases/$local_dbName" ]
    then
        echo "Database Not Found."
    fi
    local local_dbName="$1"
    while [ -d "DataBases/$local_dbName" ]; do
        rm -r Databases/$local_dbName
        echo "$local_dbName deleted successfully"

    done
    
}


# create a directory for ueabases
createDataBasesDirectory


select menu in "Create a Database" "List Databases" "Connect To Database" "Drop Database" "Exit"; do
    case $REPLY in
        1)
            read -p "Enter the database name: " dbName
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
            read -p "Enter the database name: " _dbName
            connectToDataBase "$_dbName"
            ;;
        4)
            read -p "Enter the database name: " _dbName
            dropDataBase "$_dbName"    
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

