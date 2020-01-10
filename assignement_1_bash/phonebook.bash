#!/bin/bash

#If no script is run without options
if [ $# -eq 0 ]; then
	echo ""
	echo "bash phonebook.py OPTION [NAME][NUMBERS]"
	echo "A program to add, delete, view your contacts."
	echo ""
	echo "Options:"
	echo "      -i      Insert new contact."
	echo "              Write contact data separated by a space : bash phonebook.py -i NAME NUM1 NUM2"
	echo ""
	echo "      -v      View all saved contacts."
	echo ""
	echo "      -s      Search by contact name."
	echo "              if name is more than 1 word use double-quotes. eg: \"First_Name Last_Name\"."
	echo "              WARNING: Search is case sensitive, but will return every contact containing the search name."
	echo ""
	echo "      -e      Delete all records."
	echo ""
	echo "      -d      Delete only one contact name."
	echo "              if name is more than 1 word use double-quotes. eg: \"First_Name Last_Name\"."
	echo "              WARNING: Delete is case sensitive, and may delete more than 1 contact if they're EXACTLY the same."
	exit 0
fi

#if script is run with options

if [ $1 == -i ]; then
	echo "Inserting new contact . . ."
	if [ $# -lt 3 ]; then
		echo "Not enough inputs for -i. Run script with no options for help."
		exit 1
	else
		echo $* | cut -d ' ' -f 2- >> phonebook.bash
		echo "Inserted successfully!"
	fi
elif [ $1 == -v ]; then
	echo "Viewing contacts . . ."
	lineNum=`grep -n 'PhoneData' phonebook.bash | cut -d: -f1 | tail -1`
	lineNum=$(($lineNum+1))
	cat phonebook.bash | awk 'BEGIN{start=0} {if(NR=="'$lineNum'") start=1} {if(start==1) print $0}' | less
elif [ $1 == -s ]; then
	echo "Searching . . ."
	if [ $# -lt 2 ]; then
		echo "Not enough inputs for -s. Run script with no options for help."
		exit 1
	else
		grep "$2" phonebook.bash
	fi
elif [ $1 == -e ]; then
	echo "Deleting All Contacts . . ."
	lineNum=`grep -n 'PhoneData' phonebook.bash | cut -d: -f1 | tail -1`
	lineNum=$(($lineNum+2))
	sed -i "$lineNum,$ d" phonebook.bash
	echo "" >> phonebook.bash
	echo "Deleted successfully!"
elif [ $1 == -d ]; then
	echo "Deleting One Contact . . ."
	if [ $# -lt 2 ]; then
		echo "Not enough inputs for -d. Run script with no options for help."
		exit 1
	else
		sed -i "/^$2 [[:digit:]]/ d" phonebook.bash
		echo "Deleted successfully!"
	fi
else
	echo "That's not an available option. Run script with no options for help."
	exit 1
fi

exit 0

#(Program never reaches here because of exit command)

PhoneData 

Panda 0100996554
Panda Panda 0110996554
Turtle Panda 013435454
Panda Turtle 013434344
panda Panda 1880875 34355454
Dolphin 0124665656
