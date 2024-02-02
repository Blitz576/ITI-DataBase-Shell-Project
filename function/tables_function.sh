#import main functions
source ./other_function.sh


function setTableAttributes() {
  
  local tableMetaData=$1
  local iterator=0 
  #feilds defination
  fields=("Feild_Name" "Primary_Constraint" "Data_Type")

  #write them down to meta data file
  echo ${fields[*]} >> $tableMetaData

  read -p "Enter the number of feilds: " feildCount
 
  while [ $iterator -lt $feildCount ]; do
  #input feild name
    read -p "column name : " columnName
    validateName "$columnName" "Feild"
    if [ $? -eq 1 ]; then
        fields[0]=$columnName  
      else
        echo "there's wrong while typing please check and try again"
        continue
    fi
    #input field Primary constraint
    read -p "Primary(p) or Not(n) : " feildConstraint


     checkPrimary "$feildConstraint"
     if [ $? -eq 1 ]; then
       fields[1]="PRIMARY"
     elif [ $? -eq 2 ]; then
       fields[1]="NOT"
     else
       echo "there's wrong while typing please check and try again"
       continue
     fi
        
    read -p "Integer(press i) or String(press s) : " dataType
        dataIntegrity "$dataType"
      if [ $? -eq 1 ]; then
       fields[1]="INT"
      elif [ $? -eq 2 ]; then
       fields[1]="STRING"
      else
       echo "there's wrong while typing please check and try again"
       continue
     fi
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
    rm $local_TableName
    echo "$local_TableName deleted successfully"
    
}

