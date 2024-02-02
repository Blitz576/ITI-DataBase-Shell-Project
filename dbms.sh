#!/bin/bash
#DataBase Main System


##########saving currnet directory########
currentDir=$PWD



# change the select prompt
PS3="Main System > "
export LC_COLLATE=C
shopt -s extglob

#######main functions #######
function validateName(){
   local localName=$1
   local localType="$2" 
    case $localName in
        [!a-zA-Z]*)
            echo "$localType Name Cannot Start With Special Characters Or Numbers."
            ;;
        " ")
            echo "$localType Name Should Not Have Any Spaces."
            ;;
        [!a-z0-9A-Z])
            echo "$localType Name Cannot Have Special Characters."
            ;;
        *)
            return 1;  
            ;;
    esac
}

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

    validateName "$local_dbName"
    if [ $? -eq 1 ]; then
       mkdir -p "DataBases/$local_dbName"
       echo "$local_dbName Created Successfully."         
    fi
}

function connectToDataBase () {
    local dbName="$1"
    
    if [ -d "DataBases" ] 
    then
          cd "DataBases"
        if [[ -d $dbName ]]; then
            cd "$dbName"
            cd ../..
            ./tables.sh "$dbName"
        else
          echo "DataBase is not exist"
          cd ..    
        fi
    else
        echo "Missing DataBases directory please create a DataBase"
    fi
    
}

function dropDataBase() {
    
    if [ ! -d "DataBases/$local_dbName" ]
    then
        echo "Database Not Found."
        return ;
    fi
    local local_dbName="$1"
    rm -r DataBases/$local_dbName
    echo "$local_dbName deleted successfully"
    
}
function listDataBases(){
    if [ -n "$(ls -d DataBases/*/)" ]; then
                echo "Available Databases:"
                ls -d DataBases/*/ | sed 's|.*/||'
            else
                echo "There Are No Databases"
            fi
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
            listDataBases
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
            cd $currentDir
            break
            ;;
        *)
            echo "Invalid option. Please choose a number between 1 and 5."
            ;;
    esac
done
