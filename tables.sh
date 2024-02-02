#table page


#########main functions##########
function setTableAttributes() {

  echo "after entering your table columns please type 'done' to end statement"
  local times=0
  while [ true ]; do
   read -p "Attribute : " attr
   echo $attr 
  done
  
}


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
        " ")
            echo "Table Name Should Not Have Any Spaces."
            ;;
        [!a-z0-9A-Z])
            echo "Table Name Cannot Have Special Characters."
            ;;
        *)
            touch "$local_tableName"
            touch "${local_tableName}.meta"
            setTableAttributes
            ;;
    esac
}



function connectToTable () {
    local tableName="$1"
    
        if [[ -f  tableName ]]; then
            source ../../table.sh "$tableName" "$parentDataBase" 
        else
          echo "Table is not exist"
          cd ..    
        fi
    
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

echo "welcome to DataBase $1"

select menu in "Create a Table" "List Tables" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Drop Table" "Back To DataBase main system"; do
    case $REPLY in
        1)
            read -p "Enter the database name: " tableName
            createTable "$tableName"
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