#import table main functions
echo "$PWD"
source ../.././function/tables_function.sh
source ../.././function/other_function.sh
#table page


echo $PWD

PS3="$1 >"

echo "welcome to DataBase $1"

select menu in "Create a Table" "List Tables" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Drop Table" "Back To DataBase main system"; do
    case $REPLY in
        1)
            read -p "Enter the database name: " tableName
            createTable "$tableName" "Table"
            ;;
        2)
            if [ -n "$(ls $PWD/*)" ]; then
                echo "Available Tables:"
                ls $PWD
            else
                echo "There Are No Databases"
            fi
            ;;
        3)
            read -p "Enter the database name: " _tableName
            connectToTable "$_tableName"
            ;;
        4)
            read -p "Enter the database name: " _tableName
            dropDataTable "$_tableName"    
            ;;
        5)
            echo "Welcome to system ."
            break
            ;;
        *)
            echo "Invalid option. Please choose a number between 1 and 5."
            ;;
    esac
done

PS3="Main System > "