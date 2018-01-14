## !/usr/bin/env bash

## New Raspberry password
echo ''
echo ''
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+                                               +'
echo '+       -= Password for Raspberry PI =-         +'
echo '+                                               +'
echo '+                                               +'
echo '+    Please change Raspberry-Password for:      +'
echo '+                                               +'
echo '+    User = pi                                  +'
echo '+                                               +'
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo ''
echo ''
sudo passwd pi
echo ''
echo ''
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+                                               +'
echo '+       -= Password for Raspberry PI =-         +'
echo '+                                               +'
echo '+                                               +'
echo '+    Please change Raspberry-Password for:      +'
echo '+                                               +'
echo '+    User = root                                +'
echo '+                                               +'
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo ''
echo ''
sudo passwd root


############################

sudo apt update && sudo apt dist-upgrade -yf && sudo apt install acl git-core screen rsync exfat-fuse exfat-utils ntfs-3g gphoto2 xrdp samba -yf


############################

## Samba "smb.conf" - Backup
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf_original
## New Configuration
sudo mv /boot/smb.conf /etc/samba/smb.conf

## Samba Server - New password
echo ''
echo ''
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+                                               +'
echo '+       -= Password for Samba-Server =-         +'
echo '+                                               +'
echo '+                                               +'
echo '+    Please change the Samba-Password for:      +'
echo '+                                               +'
echo '+    User = pi                                  +'
echo '+                                               +'
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo ''
echo ''
sudo smbpasswd -a pi


###########################

## Program Files
mkdir /home/pi/Desktop/USB
mkdir /home/pi/Desktop/NAS
mkdir /home/pi/Desktop/Storage
mkdir /home/pi/Raspi_Storage
sudo mv /boot/backup.sh /home/pi/Raspi_Storage/backup.sh
sudo touch /home/pi/Desktop/NAS/nomount.nas
sudo chmod -R 775 /home/pi/Desktop/Storage
sudo setfacl -Rdm g:pi:rw /home/pi/Desktop/Storage
sudo chown -R pi:pi /home/pi/Desktop/Storage


crontab -l | { cat; echo "@reboot sudo /home/pi/Raspi_Storage/backup.sh >> /home/pi/Raspi_Storage/Raspi_Storage.log 2>&1"; } | crontab


############################

## NAS - mount
#sudo bash -c "echo ""//NAS_IP_Adresse/Raspi /home/pi/Desktop/NAS cifs username=UsErNaMe,password=UsErPaSsWoRd,uid=pi,gid=pi 0 0"" >> /etc/fstab"

## or(!) Windows mount
#sudo bash -c "echo ""//PC_IP_Adresse/Users/Public/ /home/pi/Desktop/NAS cifs username=UsErNaMe,password=UsErPaSsWoRd,uid=pi,gid=pi 0 0"" >> /etc/fstab"


############################

## Wait for Network (NAS / Win - mount)
echo ''
echo ''
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+                                               +'
echo '+    Please activate the network on startup:    +'
echo '+                                               +'
echo '+   (3)  Boot Options              -> Enter     +'
echo '+   (B2) Wait for Network at Boot  -> Enter     +'
echo '+        Choose <Yes>              -> Enter     +'
echo '+        <Ok>                      -> Enter     +'
echo '+        <Finish> or Esc                        +'
echo '+                                               +'
echo '+++++++++++++++++++++++++++++++++++++++++++++++++'
echo ''
echo ''
#read -rn1 -p "Press any key when ready" ; echo
#sudo raspi-config


############################

## Cleaning
sudo rm -r /boot/raspi-storage-install.sh


############################

## Finish
echo ''
echo '++++++++++++++++++++++++++++++++++'
echo '+                                +'
echo '+          All done!             +'
echo '+                                +'
echo '+    Reboot after 1 minute       +'
echo '+                                +'
echo '++++++++++++++++++++++++++++++++++'
echo ''
sudo shutdown -r 1
echo ''
echo ''