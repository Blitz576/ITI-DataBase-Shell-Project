#import main functions
source ./other_function.sh


function setTableAttributes() {
  
  local tableMetaData=$1
  local iterator=0 
  #feilds defination
  fields=("Feild_Name" "Primary_Constraint" "Data_Type")

  #write them down to meta data file
  echo ${fields[*]} >> $tableMetaData
   
  #Define feild checkers
  local fname=0
  local fpconstraint=0
  local fdatatype=0

  read -p "Enter the number of feilds: " feildCount
 
  while [ $iterator -lt $feildCount ]; do
   #check if the field name was entered or not
    if [ $fname -eq 0 ]; then
      read -p "column name : " columnName
      validateName "$columnName" "Feild"
      if [ $? -eq 1 ]; then
          fields[0]=$columnName
          fname=1  
        else
          echo "there's wrong while typing please check and try again"
          continue
      fi
    fi

    #check if the field Primary constraint was entered or not
    if [ $fpconstraint -eq 0 ]; then

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
    fi


    #check if the field data type was entered or not
  if [ $fdatatype -eq 0 ]; then
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
  fi

  #append data to meta data file
  echo ${fields[*]} >> $tableMetaData
  
  #reset the values of checkers
  local fname=0
  local fpconstraint=0
  local fdatatype=0



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

