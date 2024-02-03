#!/bin/bash

echo "the file path is" 
echo "######"
echo $PWD
echo "#####"

#import data base functions
source ./function/dbms_function.sh
source ./function/other_function.sh



#DataBase Main System


#saving currnet directory
currentDir=$PWD



# change the select prompt
PS3="Main System > "
export LC_COLLATE=C
shopt -s extglob


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
