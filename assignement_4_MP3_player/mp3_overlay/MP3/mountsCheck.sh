#!/bin/sh

songsFile=/Songs/songList

#Check for mounts
for medium in `ls /media`; do
    if [ ! -e "/dev/$medium" ]; then
        umount /media/$medium 2> /dev/null
        rm -r /media/$medium
        find /Songs -name '*.mp3' > $songsFile
    fi
done

partitions="$(ls /dev/sd*)" 2> /dev/null
for partition in $partitions; do                        
    if ! df | grep -q $partition; then
        mountpoint="/media/$(basename $partition)" 
        if [ ! -e "$mountpoint" ]; then                                                 
            mkdir $mountpoint
        fi                                                                             
        mount $partition $mountpoint 2> /dev/null
        find "$mountpoint" -name '*.mp3' >> $songsFile                     
    fi                                
done
