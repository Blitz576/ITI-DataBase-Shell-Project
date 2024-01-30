#!/bin/bash


#create a database main menu

PS3="your choice : "

select menu in "Create a DataBase" "List DataBases" "Connect To DataBase" "Drop DataBase" "Exit"
do
case $REPLY in 
1) echo "one is choosen"
;;
2) echo "one is choosen"
;;
3) echo "one is choosen"
;;
4) echo "one is choosen"
;;
5) echo "System Ended"
 break
;;
*) echo "you have choosen a worng number plaese try again"
;;
esac
done

