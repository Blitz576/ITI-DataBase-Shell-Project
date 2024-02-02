#table page


#########main functions##########
function createTable () {
    local local_tableName="$1"
    if [ -f "$local_tableName" ]; then
        echo "$local_tableName Already Exists. Please Enter Another Name: "
        read local_tableName
    fi

    case $local_tableName in
        [!a-zA-Z]*)
            echo "Table Name Cannot Start With Special Characters Or Numbers."
           ;;
        *" "*)
            echo "Table Name Should Not Have Any Spaces."
            ;;
        *[!a-z0-9A-Z]*)
            echo "Table Name Cannot Have Special Characters."
           ;;
        *)
            mkdir "$local_tableName"
            echo "$local_tableName Created Successfully."
            ;;
    esac
}


function dropTable() {
    
    local local_TableName="$1"
    if [ ! -f "$local_TableName" ]
    then
        echo "Table Not Found."
        return ;
    fi
    rm -r $local_TableName
    echo "$local_TableName deleted successfully"
    
}


PS3="$1 >"

echo "welcome to table $1"

select menu in "Create a Table" "List Tables" "Insert Into Table" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"; do
    case $REPLY in
        1)
            read -p "Enter the database name: " tableName
            createTable "$tableName"
            ;;
        2)
            if [ -n "$(ls -d database/*/)" ]; then
                echo "Available Databases:"
                ls -d $PWD/*/ | sed 's|.*/||'
            else
                echo "There Are No Databases"
            fi
            ;;
        3)
            read -p "Enter the database name: " _tableName
            connectToDataBase "$_tableName"
            ;;
        4)
            read -p "Enter the database name: " _tableName
            dropDataBase "$_tableName"    
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


PS3="Main System > "

