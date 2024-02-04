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
  local priamryChecker=0
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
    local feildConstraint=0
    if [ $fpconstraint -eq 0 ]; then
    if [ $priamryChecker -eq 0 ]; then 
        read -p "Primary(p) or Not(n) : " feildConstraint
      else
        feildConstraint="Not"  
    fi
            
        checkPrimary "$feildConstraint"
        local returnCheckPrimary=$?
        if [ $returnCheckPrimary -eq 1 ]; then
          fields[1]="PRIMARY"
          priamryChecker=1
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
   fname=0
   fpconstraint=0
   fdatatype=0

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
                if [[ ${fields_primary[i]} == "PRIMARY" ]]; then
                check_primary_key "$value" "${fields[@]}" 
                fi
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
      if [ $maximumFeilds -lt $targetFeildsCount -o $targetFeildsCount -eq 0 -o $targetFeildsCount -lt 0]; then
      echo "wrong number of feilds it may be greater than the table feilds please try again."
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
    read -p "insert the new feild data: " feildData

    #check data primary
    
    #check data integrity
    dataIntegrity `awk -v pattern="$targetFeildName" '$1 == pattern {print $3}' "${targetTableName}.meta"
`
   

  local feildIndex=`awk -v pattern="$targetFeildName" '$1 == pattern {print NR}' "${targetTableName}.meta"
`


   local validData=0
   local returnDataIntegrity=$?
   
   if [ $returnDataIntegrity -eq 1 ]; then
     
     if [[ $data =~ ^[0-9]+$ ]]
     then
        validData=1
     else
        validData=0
     fi
     
   elif [ $returnDataIntegrity -eq 2 ]; then
     validData=1
   else
     validData=0
   fi
   
   
   if [ validData -eq 1 ]
   then
      read -p "enter the data you want to replace with: " oldData
      
      #check if the data Exist or not 
      if [ grep -q "\<$oldData\>" "${targetTableName}" ]; then
        read -p "enter id or data on where to reaplce( if you do not want that option press '0' ): " specificData
        
        if [ specificData -eq 0 ]; then
           # Replace oldData with feildData within the feild feildIndex
           awk -v fieldIndex="$feildIndex" -v newData="$feildData" -v oldData="$oldData" '{{for (i=1; i<=NF; i++) {if ($i==oldData && fieldIndex==i) $i=newData} print }} ' "$targetTableName" > temp && mv temp "$targetTableName" 
        elif [ grep -q "\<$specificData\>" "${targetTableName}" ]; then
          #find the index of the row
          local rowIndex=`awk -v pattern="$specificData" '{for (i=1; i<=NF; i++) {if ($i == pattern) {print NR; exit}}}' $targetTableName`
              
          # Replace oldData with feildData within the feild feildIndex on the row of Specific Data
            awk -v rowIndex=$rowIndex -v fieldIndex="$feildIndex" -v newData="$feildData" -v oldData="$oldData" '{if (rowIndex==NR){for (i=1; i<=NF; i++) {if ($i==oldData && fieldIndex==i) $i=newData} print }} ' "$targetTableName" |cat > $targetTableName
        else
           echo "the data you entered is not exist plaese try the steps from the begining..."
           continue;
        fi
        
        
        else
        echo "the data you entered is not exist plaese try the steps from the begining..."
        continue;    
      fi

   else
    echo "the data you entered is not exist plaese try the steps from the begining..."
    continue;
   fi
        
   else
    echo "the entered data is not exist please enter the name again..."
    continue
   fi


   ((item++))
   done
   

}



function deleteFromTable () {
    local targetTableName=$1  

    # Check if the table exists or not 
    if [ -f "$targetTableName" ]; then
        local choice=0
        read -p "Delete all (press 0) or enter specific id (press 1): " choice

        # Delete all
        if [ $choice -eq 0 ]; then
            echo -n "" > "$targetTableName"
            echo "Deleted successfully"
        elif [ $choice -eq 1 ]; then
            # Delete by id
            local pk=0
            read -p "Enter the primary key for the row you want to delete from: " pk
            
            # Use sed to delete the row where the primary key exists
            sed -i "/$pk/d" "$targetTableName"
            echo "Deleted row with primary key $pk"
        else
            echo "Wrong choice. Please enter a correct number."
        fi
    
    else
        echo "Table does not exist. Please try again ..."
    fi
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


