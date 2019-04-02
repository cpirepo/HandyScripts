#!/bin/bash
#
# name: CreateProxyMounts.sh
# date: 6/9/2017
# author: mgc
# purpose: create user and filesystems needed for the mariadb installs
# Code: https://downloads.mariadb.org/f/mariadb-10.1.22/bintar-linux-x86_64/mariadb-10.1.22-linux-x86_64.tar.gz
################################################
SQLUSER=sqlite3
OWNER=zabbix
FSTAB=/etc/fstab
MYSQLUSERGROUP=$SQLUSER
#MYSQLUID=1000
SQLITE3LV=zabsqlite3lv
#HOMEMYSQLLV=homemysqllv
#HOMEMYSQLSIZE=9G
SQLITE3SIZE=1G
VGNAME=appvg
SQLITE3DIR=/var/lib/sqlite
TEAM=Zabbix
###########
# Functions
###########

CreateLVs ()
{

# to create mysql home dir
#sudo lvcreate -L $HOMEMYSQLSIZE -n $HOMEMYSQLLV $VGNAME
sudo lvcreate -L $SQLITE3SIZE -n $SQLITE3LV $VGNAME
SQLCREATERC=$?

#printf " If worky, create the entries in fstab "
CREATERC=0
if [[ $SQLCREATERC -eq  $CREATERC ]];
 then
printf "LV Create worked \n"
else
printf "LV creation failed. Create return codes are: SQLCREATERC: $SQLCREATERC \n"
exit
fi
echo $SQLCREATERC

        }

CreateFS ()
        {
sudo mkfs.xfs  /dev/$VGNAME/$SQLITE3LV
MKFSOPTRC=$?

printf " If worky, create the entries in fstab \n"
if [[ $MKFSOPTRC -eq  $CREATERC  ]]; then
printf "Create filesystem worked \n"
else
printf "Filesystem creation failed. Create return codes are: MKFSOPTRC: $MKFSOPTRC MKDATARC: $MKDATARC \n"
exit
fi
echo $MKFSOPTRC

        }

CreateMountFS ()
        {

printf "Create directories for the mounts"
printf "mkdir -p $SQLITE3DIR" && chown $OWNER $SQLITE3DIR
#backup fstab
cp /etc/fstab /etc/fstab.bak
#Add to  fstab
echo "/dev/mapper/$VGNAME-$SQLITE3LV $SQLITE3DIR xfs defaults 0 0" >>$FSTAB
printf "Mount the Filesystems"
mount $SQLITE3DIR
SQLITEFSRC=$?

printf " If worky, create the entries in fstab "
if [[ $SQLITEFSRC -eq $CREATERC ]]; then
printf "Mounts worked"
else "Filesystem creation failed. Create return codes are: SQLITEFSRC: $SQLITEFSRC \n"
exit
fi
        }


########################

printf "Create logical volumes \n"
printf "Running CreateLVs; \n"
CreateLVs;
##
printf "Create filesystems  \n"
printf "Running CreateFS; \n"
CreateFS;
###
###
printf "Create and Mount XFS Filesystems"
printf "Running CreateMountFS; \n"
CreateMountFS;
