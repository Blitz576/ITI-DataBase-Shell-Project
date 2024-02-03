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
    if [ $local_choice = "i" -o $local_choice = "int" ]; then
        return 1;
    elif [ $local_choice = "s" -o $local_choice = "string" ]; then
         return 2;
    else
         return 0;
    fi
       
}