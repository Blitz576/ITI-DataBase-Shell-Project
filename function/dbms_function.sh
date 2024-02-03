#import main functions
source ./function/other_function.sh


function createDataBasesDirectory () {
    echo "Welcome to our Bash Sql system."
    echo "After reading this line, a database directory has been created in your current directory under the name of 'DataBases'."
    echo "If you have used our program before, don't worry ..."
    
    if [ ! -d "DataBases" ]; then
        mkdir "DataBases"
    fi
}

function createDataBase () {
    local local_dbName="$1"
    while [ -d "DataBases/$local_dbName" ]; do
        echo "$local_dbName Already Exists. Please Enter Another Name: "
        read local_dbName
    done

    validateName "$local_dbName" "DataBase"
    if [ $? -eq 1 ]; then
       mkdir -p "DataBases/$local_dbName"
       echo "$local_dbName Created Successfully."         
    fi
}

function connectToDataBase () {
    local dbName="$1"
    
    if [ -d "DataBases" ] 
    then
          cd "DataBases"
        if [[ -d $dbName ]]; then
            echo $PWD
            cd "$dbName"
            echo $PWD
            ../.././tables.sh "$dbName"
        else
          echo "DataBase is not exist"
          cd ..    
        fi
    else
        echo "Missing DataBases directory please create a DataBase"
    fi
    
}

function dropDataBase() {
    
    if [ ! -d "DataBases/$local_dbName" ]
    then
        echo "Database Not Found."
        return ;
    fi
    local local_dbName="$1"
    rm -r DataBases/$local_dbName
    echo "$local_dbName deleted successfully"
    
}
function listDataBases(){
   local dataBaseCount=`ls  DataBases/ 2>/dev/null | wc -l`
    if [ $dataBaseCount -gt 0 ]; then
                echo "Available Databases:"
                ls  DataBases/ | sed 's/DataBases\///'
            else
                echo "There Are No Databases"
            fi
}
