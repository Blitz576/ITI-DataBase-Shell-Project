function validateName(){
   local localName=$1
   local localType="$2" 
    case $localName in
        [!a-zA-Z]*)
            echo "$localType Name Cannot Start With Special Characters Or Numbers."
            ;;
        *" "*)
            echo "$localType Name Should Not Have Any Spaces."
            ;;
        *[!a-z0-9A-Z]*)
            echo "$localType Name Cannot Have Special Characters."
            ;;
        *)
            return 1;  
            ;;
    esac
}

function checkPrimary(){
    local local_choice=$1
    local_choice=`echo "$local_choice" | tr '[:upper:]' '[:lower:]'`
    if [ $local_choice = "p" -o $local_choice = "primary" ]; then
        return 1;
    elif [ $local_choice = "n" -o $local_choice = "not" ]; then
         return 2;
    else
         return 0;
    fi   
}

function dataIntegrity(){
    local dataType=$1
    dataType=`echo "$dataType" | tr '[:upper:]' '[:lower:]'`
    if [ $dataType = "i" -o $dataType = "int" ]; then
        return 1;
    elif [ $dataType = "s" -o $dataType = "string" ]; then
         return 2;
    else
         return 0;
    fi
       
}

check_primary_key() {

    local primary_key="$1"
    local arr=("$@")   
    unset arr[0]  

    # Check if the primary key exists in the file
    for element in "${arr[@]}"; do

          if [ "$element" == "$primary_key" ]; then
                 echo "Primary key '$primary_key' exists."
         else
                 echo "Primary key '$primary_key' does not exist ."
          fi
    done
}

function getFeildIndex ()
{
   local targetTableName=$1
   local feildName=$2
   local feildIndex=`awk -v pattern="$feildName" '$1 == pattern {print NR; exit}' "${targetTableName}.meta"`
   feildIndex=$((feildIndex - 1))
   return $feildIndex;
}


function getPrimaryFeildIndex(){
   local targetTableName=$1
   local primaryFeildName=`awk -v pattern="PRIMARY" '$2 == pattern {print $1; exit}' "${targetTableName}.meta"` 
   getFeildIndex "$targetTableName" "$primaryFeildName"
   return $? 
}

function searchElementInColumn() {
    local column_number=$1
    local element_to_search=$2
    local data_file=$3
    local found=0 
    awk -v col="$column_number" -v search="$element_to_search" '{ if($col == search) {found=1; exit} }' "$data_file"
    echo $found
    return $found
}
