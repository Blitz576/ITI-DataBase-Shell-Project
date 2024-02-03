#import main functions
source ../../function/other_function.sh


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
      local returnValidateName=$?
      if [ $returnValidateName -eq 1 ]; then
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
        local returnCheckPrimary=$?
        if [ $returnCheckPrimary -eq 1 ]; then
          fields[1]="PRIMARY"
        elif [ $returnCheckPrimary -eq 2 ]; then
          fields[1]="NOT"
        else
          echo $feildConstraint
          echo "there's wrong while typing please check and try again"
          continue
        fi
    fi


    #check if the field data type was entered or not
  if [ $fdatatype -eq 0 ]; then
    read -p "Integer(i) or String(s) : " dataType
        dataIntegrity "$dataType"
        local returnDataIntegrity=$?
      if [ $returnDataIntegrity -eq 1 ]; then
       fields[2]="INT"
      elif [ $returnDataIntegrity -eq 2 ]; then
       fields[2]="STRING"
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

  #increase the iterator
  ((iterator++))

  done
} 


function createTable () {
    local local_tableName="$1"
    if [ -f "$local_tableName" ]; then
        echo "$local_tableName Already Exists. Please Enter Another Name: "
        read local_tableName
    fi

    validateName "$local_dbName" "Tablee"

    if [ $? -eq 1 ]; then
    touch "$PWD/$local_tableName"
    touch "$PWD/${local_tableName}.meta"
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


#crud operations
function insertIntoTable(){
  local local_TableName="$1"
    
    if [ ! -f "$local_TableName" ]; then
        echo "Table Not Found."
        return
    fi
    
    local metaFile="${local_TableName}.meta"
    local File="${locale_TableName}"
    
    
    local fields=($(grep -E 'INT|STRING' $metaFile | awk '{print $1}'))
    local fields_primary=($(grep -E 'INT|STRING' $metaFile | awk '{print $2}'))
    local fields_type=($(grep -E 'INT|STRING' $metaFile | awk '{print $3}'))

    local insertFields=""

    length=${#fields[@]}

for ((i=0; i<$length; i++)); do
    local uniqness=${fields_primary[i]}

    # if [ "$fields_primary" == "Not" ]
    if [[ ${fields_type[i]} == "INT" ]]; then
        while true; do
            read -p "Enter int number for ${fields[i]} ($uniqness): " value

            if [[ "$value" =~ ^[0-9]+$ ]]; then
                break  # Exit the loop if the value is an integer
            else
                echo "Invalid input. You must enter an integer."
            fi

        done
    elif [[ ${fields_type[i]} == "STRING" ]]; then
        while true; do
            read -p "Enter string for ${fields[i]}: " value

            if [[ "$value" =~ ^[a-zA-Z]+$ ]]; then
                break  # Exit the loop if the value is a string
            else
                echo "Invalid input. You must enter a string."
            fi

        done
    fi


        insertFields+="${fields[i]} "
        
        insertFields+="'$value' "

 

    done
    
    # Insert the data into the table
    echo "$insertFields" >> "$local_TableName"
    echo "-------------------" >> "$local_TableName"

    echo "Data inserted successfully into $local_TableName."
}

function updateTable () {
    
    local targetTableName=$1
    local tableFeildsCount=0
    #check if the table was found
     if [ ! -f "$targetTableName" ]; then
        echo "Table Not Found."
        return
    fi
    
    local maximumFeilds=`head -1 $targetTableName | awk '{print NF}'` #intial feilds count
    
    #detect number of feilds we want to update
    
    
    #check if the number of feilds is correct
    while [ true ]; do
      read -p "Enter the number of feilds you want to update" targetFeildsCount
      if [ $maximumFeilds -lt $targetFeildsCount ]; then
      echo "number of feilds is greater than the table feilds please try again."
      continue
      fi
     tableFeildsCount=$targetFeildsCount 
     break
    done

   local feilds=()
   local feildsData=() 
   #input feilds
   local item=0
   while [ $item -lt $tableFeildsCount ];do
   
   read -p "Enter the $((item+1)) feild name" targetFeildName
    
   #check if the feild exist or not 
   
   if [ grep -q "\<$targetFeildName\>" "${targetTableName}.meta" ]
   then
    feilds[$item]=$targetFeildName
    read -p "insert the feild data: " feildData
    
   else
    echo "the entered name is not exist please enter the name again..."
    continue
   fi

   ((item++))
   done
   

}




function selectFromTable()
{
    local local_TableName="$1"
    while true; do

    if [ ! -f "$local_TableName" ]; then
        echo "Table Not Found."
        return
    fi

    local metaFile="${local_TableName}.meta"
    local columns=($(grep -E 'INT|STRING' $metaFile |awk '{print $1}'))


    echo "Available Columns: ${columns[*]}"

    while true; do
    read -p "Enter column name to select (or enter * to select all): " selectedColumn
   
    if [[ $selectedColumn != "*" && ! " ${columns[@]} " =~ " $selectedColumn " ]]; then
        echo "Invalid column name. Please select a valid column."
    else
       break
    fi
    done

    echo "Selected Data from $local_TableName:"

    if [ "$selectedColumn" == "*" ]; then
        cat "$local_TableName"
    
    fi
   done
}