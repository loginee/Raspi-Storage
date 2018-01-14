##!/usr/bin/env bash

## IMPORTANT:
## Run the raspi-storage-install.sh script first
## to install the required packages and configure the system.

## Programm is starting
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 800 > /sys/class/leds/led0/delay_on"  
 
 
## Specify devices and their mount points
STORAGE_MOUNT_POINT="/home/pi/Desktop/Storage"
NAS_MOUNT_POINT="/home/pi/Desktop/NAS/Backup_Storage"
CARD_MOUNT_POINT="/home/pi/Desktop/USB"
CARD_DEV="sda1"
 
 
## Auto-Backup Nr.1 to NAS
  ##waiting for connection

#sleep 15

    ## Backup to NAS only if NAS mounted
if ! [ -f "/home/pi/Desktop/NAS/nomount.nas" ] ; then
sudo sh -c "echo 100 > /sys/class/leds/led0/delay_off"
rsync -ah --exclude=.recyclebin --exclude='System Volume Information' --exclude=CARD_ID $STORAGE_MOUNT_POINT/ $NAS_MOUNT_POINT
fi



## Set the ACT LED to heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

## Shutdown after 7 minutes if no device is connected.
sudo shutdown -h 7 "Shutdown is activated. Cancel with: sudo shutdown -c"


## Wait for a card reader
CARD_READER=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
until [ ! -z $CARD_READER ]
  do
  sleep 1
  CARD_READER=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
done

## If the card reader is detected, mount it and obtain its UUID
if [ ! -z $CARD_READER ]; then
  mount /dev/$CARD_DEV $CARD_MOUNT_POINT

## Cancel of shutdown
sudo shutdown -c
  
  ## Set the ACT LED to blink to indicate that the card has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1500 > /sys/class/leds/led0/delay_on"  
sudo sh -c "echo 500 > /sys/class/leds/led0/delay_off"

    ## Create the CARD_ID file containing a random 8-digit identifier if doesn't exist
  if [ ! -f $CARD_MOUNT_POINT/CARD_ID ]; then
    < /dev/urandom tr -cd 0-9 | head -c 8 > $CARD_MOUNT_POINT/CARD_ID
  fi


## Read the 8-digit identifier number from the CARD_ID file on the card
## and use it as a directory name in the backup path
read -r ID < $CARD_MOUNT_POINT/CARD_ID
BACKUP_PATH=$STORAGE_MOUNT_POINT/"$ID"
  
## Perform backup using rsync
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"  
sudo sh -c "echo 1500 > /sys/class/leds/led0/delay_off"
rsync -ah $CARD_MOUNT_POINT/ $BACKUP_PATH

## Rights for User PI
sudo chown -R pi:pi $STORAGE_MOUNT_POINT

## Auto-Backup Nr.2 to NAS
## Backup to NAS only if NAS mounted
if ! [ -f "/home/pi/Desktop/NAS/nomount.nas" ] ; then
sudo sh -c "echo 100 > /sys/class/leds/led0/delay_off"
rsync -ah --exclude=.recyclebin --exclude='System Volume Information' --exclude=CARD_ID $STORAGE_MOUNT_POINT/ $NAS_MOUNT_POINT
fi


## Turn off the ACT LED to indicate that the backup is completed
sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"
fi

## Shutdown
sync
shutdown -h now
