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
 
  while [ $feildCount -lt 1 ]; do
    echo "wrong number, enter a valid number again..."
    read -p "Enter the number of fields: " feildCount
done
  while [ $iterator -lt $feildCount ]; do
   #check if the field name was entered or not
    if [ $fname -eq 0 ]; then
      read -p "column name : "   columnName
      validateName "$columnName" "Feild"
      local returnValidateName=$?
      if [ $returnValidateName -eq 1 ]; then
         searchElementInColumn "1" "$columnName" "$tableMetaData"
         local returnSearchElementInColumn=$?

         if [ $returnSearchElementInColumn -eq 1 ]; then
          echo "the column name is already found in your table...."
          continue
         fi


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
    validateName "$local_tableName" "Table"
    local isValid=$?
    

    if [ $isValid -eq 1 ];then

    if [ -f "$local_tableName" ]; then
        echo "$local_tableName Already Exists. Please Enter Another Name: "
        read local_tableName
    fi


    touch "$PWD/$local_tableName"
    touch "$PWD/${local_tableName}.meta"
    setTableAttributes "${local_tableName}.meta"
    fi
}

function listTables() {
  if [ -n "$(ls $PWD)" ]; then
      echo "Available Tables:"
      ls $PWD | grep -v 'meta$'
  else
        echo "There Are No Tables"
  fi
}

function dropTable() {
    
    local local_TableName="$1"
    while true; do
    if [ ! -f "$local_TableName" ]
    then
        echo "Table Not Found."
        read -p "Enter the table name: " local_TableName
    else 
        break
    fi
    done
    rm $local_TableName
    rm ${local_TableName}.meta
    echo "$local_TableName deleted successfully"
    
}


function insertIntoTable() {
    local local_TableName="$1"

    while true; do
    if [ ! -f "$local_TableName" ]
    then
        echo "Table Not Found."
        read -p "Enter the table name: " local_TableName
    else 
        break
    fi
    done

    local metaFile="${local_TableName}.meta"

    local fields=($(grep -E 'INT|STRING' "$metaFile" | awk '{print $1}'))
    local fields_primary=($(grep -E 'INT|STRING' "$metaFile" | awk '{print $2}'))
    local fields_type=($(grep -E 'INT|STRING' "$metaFile" | awk '{print $3}'))

    local my_array=()
    local length=${#fields[@]}
    local inserted=0

    for ((i=0; i<$length; i++)); do
        local uniqness=${fields_primary[i]}

        if [[ ${fields_type[i]} == "INT" ]]; then
            while true; do
              read -p "Enter int number for ${fields[i]} ($uniqness): " value
              if [[ "$value" =~ ^[0-9]+$ ]]; then
                if [[ ${fields_primary[i]} == "PRIMARY" ]]; then 
                    searchElementInColumn $((i + 1)) "$value" "$local_TableName"
                    
                    if [ $? -eq 1 ]; then
                        echo "Primary key must be unique, and this value already exists. Please enter another value."

                    else
                        inserted=1
                        break 
                    fi
                    else
                       inserted=1
                       break
                fi
                    
              else
                    echo "Invalid input. You must enter positive number ."
              fi
            done
        elif [[ ${fields_type[i]} == "STRING" ]]; then
            while true; do
                read -p "Enter string for ${fields[i]} ($uniqness) : " value
                if [[ "$value" =~ ^[a-zA-Z]+$ ]]; then
                if [[ ${fields_primary[i]} == "PRIMARY" ]]; then 
                    searchElementInColumn $((i + 1)) "$value" "$local_TableName"
                    
                    if [ $? -eq 1 ]; then
                        echo "Primary key must be unique, and this value already exists. Please enter another value."
                    else
                        inserted=1
                        break
                    fi
                else
                      inserted=1
                      break
                fi
                else
                    echo "Invalid input. You must enter a string."
                fi
            done
        fi

        my_array+=("$value")
    done
    
    # Insert the data into the table
    echo "${my_array[*]}" >> "$local_TableName"

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
    if [ ! -s "$targetTableName" ]; then
        echo "The table is empty."
        return
    fi
    
   
   read -p "Enter the feild name: " targetFeildName
    
   #check if the feild exist or not 
   
   if  grep -q "\<$targetFeildName\>" "${targetTableName}.meta" ;
   then
    feilds[$item]=$targetFeildName
    local feildData=0
    #check data primary
    getPrimaryFeildIndex "$targetTableName"
    local pkColumn=$? 
    #check data integrity
    
    dataIntegrity $(awk -v pattern="$targetFeildName" '$1 == pattern {print $3}' "${targetTableName}.meta")
    local returnDataIntegrity=$?
    local validData=0
    
    getFeildIndex "$targetTableName" "$targetFeildName"
    local feildIndex=$? 
    
    local promptDataType="String"
    local promptPrimaryKey="Not Primary"
    

    local isPrimary=0
    if [ "$feildIndex" -eq "$pkColumn" ]; then
    isPrimary=1
    fi

    if [[ $returnDataIntegrity -eq 1 ]]; then
      promptDataType="Int"
    fi

    if [[ $isPrimary -eq 1 ]]; then
      promptPrimaryKey="Primary"
    fi

    read -p "insert the new data (${promptDataType}) (${promptPrimaryKey}) : " feildData 

   
   if [ $returnDataIntegrity -eq 1 ]; then
     
     if [[ $feildData =~ ^[0-9]+$ ]]
     then
        # echo "yes"
        validData=1
     else
       echo "no"
        validData=0
    fi    
   fi
     
   if [ $returnDataIntegrity -eq 2 ]; then
     if [ ${#feildData} -lt 1 ];then
     validData=0
   else
     validData=1
     fi
   fi
   
  local feildIndex=$(awk -v pattern="$targetFeildName" '$1 == pattern {print NR}' "${targetTableName}.meta")
   
   if [ $validData -eq 1 ]
   then
      #check if the data Exist or not 
        read -p "enter id or pirmary key data( if you do not want that option press '.' ): " specificData
        
        if [ $specificData = "." ]; then
           # Replace oldData with feildData within the feild feildIndex
          ((feildIndex--))
          
          touch ${targetTableName}.meta_temp
          awk -v feildIndex="$feildIndex" -v newData="$feildData" '{
              for (i=1; i<=NF; i++) { 
                  if (i == feildIndex )
                      $i=newData
              }
              print
          }' "$targetTableName" > ${targetTableName}.meta_temp
          cat ${targetTableName}.meta_temp > ${targetTableName}
          rm ${targetTableName}.meta_temp

           echo "updated sucessfully"
        else
          #check if the data integrity for the primary data entered
          dataIntegrity `awk -v pattern="PRIMARY" '$2 == pattern {print $3; exit}' "${targetTableName}.meta"` 
          local primaryKeyDataType=$?
          local specificValidData=0
               #validate Data
               if [ $primaryKeyDataType -eq 1 ]; then
     
              if [[ $specificData =~ ^[0-9]+$ ]]
              then
                  specificValidData=1
              else
                  specificValidData=0
              fi
              
            elif [ $primaryKeyDataType -eq 2 ]; then
              specificValidData=1
            else
              specificValidData=0
            fi
            if [ $specificValidData -eq 1 ];then
              local pkRow=$(awk -v feildIndex="$pkColumn" -v specificData="$specificData" '{
                for (i=1; i<=NF; i++) { 
                    
                    if ($i == specificData) {
                        print NR
                        exit
                    }
                }
             } ' "$targetTableName")  
              
             ((feildIndex--))
             touch ${targetTableName}.meta_temp
             awk -v feildIndex="$feildIndex" -v pkRow="$pkRow" -v newData="$feildData" '{
                for (i=1; i<=NF; i++) { 
                    
                    if (i == feildIndex && pkRow == NR) {
                        $i=newData
                    }
                }
            print } ' "$targetTableName" > ${targetTableName}.meta_temp
            cat ${targetTableName}.meta_temp > "$targetTableName"
            rm  ${targetTableName}.meta_temp
           echo "sucessfully updated"
     

          else
            echo "Data Mis Match With The Primary Key Please Try Again"
          fi
                        
        
        fi
        
        
        else
        echo "the data you entered is not exist plaese try the steps from the begining..."    
      fi     
   else
    echo "the entered data is not exist please enter the name again..."
   fi

   

}


function deleteFromTable () {
    local targetTableName=$1  
    if [ ! -s "$targetTableName" ]; then
        echo "The Table is empty."
        return
    fi

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
            read -p "Enter the primary key for the row you want to delete from: " pkData
            local pkColumn= getPrimaryFeildIndex "$targetTableName"
            dataIntegrity `awk -v pattern="PRIMARY" '$2 == pattern {print $3; exit}' "${targetTableName}.meta"`
            local primaryKeyDataType=$?
            local specificValidData=0
               #validate Data
               
               if [ $primaryKeyDataType -eq 1 ]; then
     
              if [[ $pkData =~ ^[0-9]+$ ]]
              then
                  specificValidData=1
              else
                  specificValidData=0
              fi
              
            elif [ $primaryKeyDataType -eq 2 ]; then
              specificValidData=1
            else
              specificValidData=0
            fi
             
            if [ $specificValidData -eq 1 ];then

                  #get the primary key index
                  local pkRow=$(awk -v feildIndex="$pkColumn" -v specificData="$pkData" '
                  {
                      for (i=1; i<=NF; i++) { 
                          if ($i == specificData) {
                              found=NR
                          }
                      }
                  }
                  END {
                      if (found == 0)
                          print 0
                      else
                         print found
                  }
              ' "$targetTableName" ) 


                if [ $pkRow -eq 0 ] 
                then
                  echo "data you entered is not found in the primary key"
                  return
                fi  
                #Delete By Id
                touch "${targetTableName}.meta_temp"
                awk -v pkRow="$pkRow" '{
                  if(NR != pkRow)
                   print
                }' "$targetTableName" > ${targetTableName}.meta_temp
               cat ${targetTableName}.meta_temp > ${targetTableName}
               rm ${targetTableName}.meta_temp
                echo "Suceccfully Deleted"  
             else 
               echo "you Entered Wrong Data Can't delete"

            fi    
            # Use sed to delete the row where the primary key exists
            
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

    if [ ! -f "$local_TableName" ]; then
        echo "Table Not Found."
        return
    fi

    if [ ! -s "$local_TableName" ]; then
        echo "The Table is empty."
        return
    fi

    local metaFile="${local_TableName}.meta"
    local columns=($(grep -E 'INT|STRING' $metaFile |awk '{print $1}'))
    getPrimaryFeildIndex "$local_TableName"
    local primaryKey=$?

    echo "Available Columns: ${columns[*]}"

    while true; do
    read -p "Enter (column) name to select or enter (*) to select all or enter (.) to select row : " selectedColumn
   
    if [[ $selectedColumn != "*" && ! " ${columns[@]} " =~ " $selectedColumn " && $selectedColumn != "." ]]; then
    echo "Invalid column name. Please select a valid column."
    else
      break
    fi
    done


    if [ "$selectedColumn" == "*" ]; then
        echo "Selected Data from $local_TableName:"
        echo "${columns[*]}"
        cat "$local_TableName"
    elif [ "$selectedColumn" == "." ];
    then
     read -p "enter ${columns} value to select from: " primaryKeyValue
     local isFound=0
   awk -v primaryKey="$primaryKeyValue" -v primaryKeyColumn="$primaryKey" '
    {
        if ($primaryKeyColumn == primaryKey){
            print  
            isFound=1
            exit
        }
    }
    END {
        if (isFound == 0)
            print "Data is not found table"
    }
' "$local_TableName"

    else
      echo "Selected $selectedColumn from $local_TableName:"
      echo "$selectedColumn"
      getFeildIndex "$local_TableName" "$selectedColumn"
      awk -v col="$?" '{print $col}' $local_TableName
    
    fi
   
}



