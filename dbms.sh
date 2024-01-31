#!/bin/bash
#create a database main menu

PS3="your choice : "
export LC_COLLATE=C
shopt -s extglob

#change the select prompt
PS3="Your choice: "


    select menu in "Create a Database" "List Databases" "Connect To Database" "Drop Database" "Exit"; do
        case $REPLY in
            1)
                echo "Enter the database name: "
                read dbName

                while [ -d database/$dbName ]; do
                    echo "$dbName Already Exists. Please Enter Another Name: "
                    read dbName
                done

                case $dbName in
                    [0-9]*)
                        echo "Database Name Cannot Start With Numbers."
                        ;;
                    ' '|*' '*|' '*|*' ')
                    echo "Database Name Should Not have any Spaces"
                    ;;
                    
                    +([a-zA-Z]*))
                        mkdir -p database/$dbName
                        echo "$dbName Created Successfully."
                        ;;
		            *)
                        echo "Database Name Cannot Have Special Characters."
                        ;;

                esac
                ;;
            2)
                if [ -n "$(ls database/)" ]; then
                echo Available Databases:
                ls -F database/ | grep /
          	
                else
	            echo "There Are No Databases"
                fi
                ;;
            3)
                echo "Option 3 is chosen"
                ;;
            4)
                echo "Option 4 is chosen"
                ;;
            5)
                echo "System ended."
                break;
                ;;
            *)
                echo "Invalid option. Please choose a number between 1 and 5."
                ;;
        esac
    done
