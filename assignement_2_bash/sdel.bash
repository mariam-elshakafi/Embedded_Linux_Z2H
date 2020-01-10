#!/bin/bash

#Check to ensure a unique TRASH per user
if [ ! -d ~/TRASH ]; then
	mkdir ~/TRASH
fi


#Check for files older than 48 hours
for f in `find ~/TRASH -mmin +2880`
do
	if [ -d "$f" ]; then
		continue
	fi
	
	rm "$f"
done

#If script is run without arguments, just exit after checking TRASH
if [ $# -eq 0 ]; then
	exit 0
fi

#Moving files/folders to TRASH
for f in $*
do
	if [ ! -e "$f" ]; then
		echo "$f: No such file or directory!"
		continue
	fi

	filetype=`file --mime-type "$f" | cut -d: -f2`
	if [ $filetype == "application/gzip" ]; then
		mv "$f" ~/TRASH
	else
		tar czf ~/TRASH/"$f".tar.gz "$f"
		rm -r "$f"
	fi
done
