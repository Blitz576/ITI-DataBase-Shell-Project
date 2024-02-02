function validateName(){
   local localName=$1
   local localType="$2" 
    case $localName in
        [!a-zA-Z]*)
            echo "$localType Name Cannot Start With Special Characters Or Numbers."
            ;;
        " ")
            echo "$localType Name Should Not Have Any Spaces."
            ;;
        [!a-z0-9A-Z])
            echo "$localType Name Cannot Have Special Characters."
            ;;
        *)
            return 1;  
            ;;
    esac
}

function checkPrimary(){
    local local_choice=$1
    
    if [ $local_choice = "p" -o $local_choice = "P" ]; then
        return 1;
    elif [ $local_choice = "n" -o $local_choice = "N" ]; then
         return 2;
    else
         return 0;
    fi   
}