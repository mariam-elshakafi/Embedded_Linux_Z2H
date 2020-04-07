#!/bin/sh

driverLoadedFlag=`lsmod | grep snd_bcm2835 | wc -w`
if [ $driverLoadedFlag -eq 0 ]; then
  modprobe snd-bcm2835
fi

songsFile=/Songs/songList
find / -name '*.mp3' > $songsFile

songNum=1

start_flag=0
stop_on_next_click=0
next_flag=0
prev_flag=0
restart_flag=0

prevButtonPressed=0
prevTimeCount=0

#Initializing buttons
echo "2" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio2/direction 2> /dev/null

echo "3" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio3/direction 2> /dev/null

echo "4" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio4/direction 2> /dev/null


#Super Loop :D
while :
do

#Check for mounts
if ! df | grep -q "/dev/sd"; then
  partitions="$(ls /dev/sd* |  awk '/^\/dev\/sd/ {print $1}')" 2> /dev/null
  for partition in $partitions; do
    mountpoint="/media/$(basename $partition)"
    mkdir -p $mountpoint
    mount $partition $mountpoint
    find "$mountpoint" -name '*.mp3' >> $songsFile
  done
fi



#Reading Buttons
 if [ $(cat /sys/class/gpio/gpio2/value) -eq 0 ]; then
   if [ $stop_on_next_click -eq 1 ]; then
     killall -STOP madplay
     echo "Song Paused"
     stop_on_next_click=0 
   elif [ $start_flag -eq 0 ]; then
     start_flag=1
     stop_on_next_click=1
   fi
 elif [ $(cat /sys/class/gpio/gpio3/value) -eq 0 ]; then
   next_flag=1
   if [ $songNum -ne `cat $songsFile | wc -l` ]; then
     songNum=$((songNum+1))
   else
     songNum=1
   fi
 elif [ $(cat /sys/class/gpio/gpio4/value) -eq 0 ]; then
   if [ $prevButtonPressed -eq 0 ]; then
     prevButtonPressed=1
   elif [ $prevTimeCounter -lt 5 ]; then
       prevButtonPressed=0
       prevTimeCounter=0
       prev_flag=1
       if [ $songNum -ne 1 ]; then
         songNum=$((songNum-1))
       else
         songNum=`cat $songsFile | wc -l`
       fi
   fi
 fi

if [ $prevButtonPressed -eq 1 ]; then                
   prevTimeCounter=$((prevTimeCounter+1))
   if [ $prevTimeCounter -ge 5 ]; then
       prevButtonPressed=0                              
       prevTimeCounter=0                                
       restart_flag=1 
   fi  
fi

#Performing Action
songName=`cat $songsFile | sed -n "$songNum"p`
if [ $start_flag -eq 1 ]; then
  start_flag=0
  processFound=`pidof madplay | wc -w`
  if [ $processFound -eq 1 ]; then
    killall -CONT madplay 
  else
    (madplay -q $songName) &
  fi
  echo "NOW PLAYING:   `basename $songName`"
elif [ $restart_flag -eq 1 ]; then
  restart_flag=0
  killall madplay
  (madplay -Q $songName) &
  echo "NOW PLAYING:   `basename $songName`" 
elif [ $next_flag -eq 1 ]; then
  next_flag=0
  killall madplay
  (madplay -Q $songName) &
  echo "NOW PLAYING:   `basename $songName`" 
elif [ $prev_flag -eq 1 ]; then
  prev_flag=0
  killall madplay
  (madplay -Q $songName) &
  echo "NOW PLAYING:   `basename $songName`" 
fi

sleep 0.2

done
