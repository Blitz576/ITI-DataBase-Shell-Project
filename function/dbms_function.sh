#import main functions
source ./function/other_function.sh


function createDataBasesDirectory () {
    echo "Welcome to our Bash Sql system. 👋"
    echo "After reading this line, a database directory has been created in your current directory under the name of 'DataBases'."
    echo "If you have used our program before, don't worry 🤗"
    
    if [ ! -d "DataBases" ]; then
        mkdir "DataBases"
    fi
}

function createDataBase () {
    local local_dbName="$1"
    validateName "$local_dbName" "DataBase"
    local isValid=$?
    if [ $isValid -eq 1 ]; then
      while [ -d "DataBases/$local_dbName" ]; do
        read -p "$local_dbName Already Exists. Please Enter Another Name: " local_dbName
    done
    validateName "$local_dbName" "DataBase" 
    if [ $? -eq 1 ]; then
       mkdir -p "DataBases/$local_dbName"
       echo "$local_dbName Created Successfully. ✅"         
    fi  
   fi
}

function connectToDataBase () {
    read -p "Enter the database name: " dbName
    if [ -d "DataBases" ] 
    then
          cd "DataBases"
        while true; do
        if [[ -d $dbName ]]; then
            cd "$dbName"
            ../.././tables.sh "$dbName"
            cd ../..
            break
        else
          echo "DataBase is not exist ❌"
          read -p "Enter the database name: " dbName
        fi
        done
    else
        echo "Missing DataBases directory please create a DataBase ❌"
    fi
    
}
function dropDataBase() {
    local local_dbName="$1"
    while true; do
    if   [ ! -d "DataBases/$local_dbName" ] ; then
        echo "Database Not Found. ❌"
        read -p "Enter the database name: " _dbName
    else
         break
    fi
    done
    rm -r DataBases/$local_dbName
    echo "$local_dbName deleted successfully ✅"
    
}
function listDataBases() {
    local dataBaseDir="DataBases/"

    if [ -d "$dataBaseDir" ]; then
        local databases=("$dataBaseDir"/*)

        echo "Available Databases:"
        for db in "${databases[@]}"; do
            if [ "$(basename "$db")" == "*" ]; then
                echo "Database is empty"
            else
                echo "$(basename "$db")"
            fi
        done
    else
        echo "Database directory not found. ❌"
    fi
}