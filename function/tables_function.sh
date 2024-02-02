#import main functions
source ./other_function.sh


function setTableAttributes() {
  local tableMetaData=$1

  feilds("Feild Name" "Constraint" "Data Type");
  echo ${feilds[*]} >> $tableMetaData
  read -p "Enter the number of feilds: " feild
 for ((item=1; item<=$field; item++)); do
    read -p "column name : " columnName
    validateName "$columnName" "Feild"
    if [ $? -eq 1 ]; then
        feilds[0]=$columnName  
      else
        continue
    fi
    read -p "Primary(press p) or Not(press n) : "
          
    read -p "Integer(press i) or String(press s) : " columnName
        
  done
} 


function createTable () {
    local local_tableName="$1"
    if [ -f "$local_tableName" ]; then
        echo "$local_tableName Already Exists. Please Enter Another Name: "
        read local_tableName
    fi

    validateName "$local_dbName" "DataBase"

    if [ $? -eq 1 ]; then
    touch "$local_tableName"
    touch "${local_tableName}.meta"
    setTableAttributes "${local_tableName}.meta"
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

