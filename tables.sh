#import table main functions
source ../.././function/tables_function.sh
source ../.././function/other_function.sh
#table page

PS3="$1 > "

echo "welcome to DataBase $1"

select menu in "Create a Table" "List Tables" "Drop Table" "insert Into Table" "Delete From Table" "Update Table" "Select From Table" "Back To DataBase main system"; do
    case $REPLY in
        1)
            read -p "Enter the table name: " tableName
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
            read -p "Enter the table name: " _tableName
            dropDataTable "$_tableName"    
            ;;    
        4)
            read -p "Enter the table name: " _tableName
            insertIntoTable "$_tableName"
            ;;
        5)
            read -p "Enter the table name: " _tableName
            deleteFromTable "$_tableName"
            ;;
        6)
            read -p "Enter the Table name: " _tableName
            selectFromTable "$_tableName" 
            ;;
        7)
            read -p "Enter the Table Name: " _tableName
            updateTable "$_tableName"
            ;;
        8)
           echo "Welcome To your DataBase Again"
           break;
        ;;    
        *)
            echo "Invalid option. Please choose a number between 1 and 5."
            ;;
    esac
done
echo $PWD
cd ..
cd ..
echo $PWD
PS3="Main System > "