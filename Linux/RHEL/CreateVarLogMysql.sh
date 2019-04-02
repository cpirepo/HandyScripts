#!/usr/bin/bash
#
#
NUMMB=7000
LVNAME=mysqllog
VG=appvg
MOUNT=/var/log/mysql
FSTYPE=xfs 
FSTAB=/etc/fstab

#if [[ $# != 3 ]]; then
#printf "Need args. $PWD/$0 LVname VGname Size in MB \n" 
#printf "Be sure you have space via sudo lvs and sudo pvscan \a\n" 
##exit
#fi
#sudo lvs;sudo pvscan
printf "Creating LV $LVNAME in VG $VG sized at $NUMMB MB \n"


CreateLVFS ()	
	{
sudo lvcreate -L ${NUMMB}M -n $LVNAME $VG
sudo mkfs.xfs  /dev/$VG/$LVNAME
	}


echo "Mount with noatime for Maria and perf mounts in fstab noatime "

CreateMount ()
	{
mkdir -p $MOUNT
if [[ $? != '0' ]];then
echo "Mountpoint creation failed \a\a\n"
exit 
fi
	}
CreateFSTabEntry ()
	{
echo "/dev/mapper/${VG}-${LVNAME} $MOUNT $FSTYPE defaults 0 0" >>$FSTAB

printf "\n\n\n\a `date` \n"
tail $FSTAB
mount $MOUNT 
echo "$?"
sleep 10
df -h $MOUNT

	}

	
#################
CreateMount;
CreateLVFS;
CreateFSTabEntry;
