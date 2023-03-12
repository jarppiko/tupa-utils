#!/bin/bash
set -o nounset 		## Error if undefined variable referred (which default to "") 
set -o errexit 		## Do not ignore failing commands

ENCRYPTED_DEV=securebackup
CHKSUM=.checksum.b3
EXCLUDE_FILE=".exclude.rsync"
TEMP="`mktemp  /tmp/BACKUP_USB.XXXXXX`"
DATE=`date '+%F'`; readonly DATE
LOG=~/backup_log_${DATE}.log
BACKUP_DISK=/dev/sdd
BACKUP_PART=/dev/sdd1
TUPA_UTILS="/usr/local/bin"

######################## EDIT ###################################################

source ${TUPA_UTILS}/backup-data.lib

######################## MAIN() #################################################

BACKUP_MNT=NONE
check_backup_mount
if [[ $BACKUP_MNT == "NONE" ]]; then
	mount_backup_disk
fi

if [[ $BACKUP_MNT == "NONE" ]]; then
	echo "ERROR. No backup media mounted into /mnt/backup OR /mnt/sbackup" | tee -a $TEMP
	exit 1
fi

BACKUP_ROOT="$BACKUP_MNT/B"
BACKUP_DIR="$BACKUP_ROOT/current"

if [[ ! -d $BACKUP_DIR ]]; then
	echo "Backup directory hierarchy changed. Please update the backup roots under $BACKUP_DIR" > /dev/stderr
	exit 1
fi

echo "-------------------------------------------------------------" | tee -a $TEMP
echo "|  Backup to EXTERNAL HDD                                   |" | tee -a $TEMP
echo "-------------------------------------------------------------" | tee -a $TEMP

######################## What to backup #########################################

# do_backup_remote jarno@tupajumi:/home/stuff/Flac Flac
# do_backup /mnt/d/Pics Pics

# umount_backup

###################### MAIL LOG ########################
#echo "Mailing log ..." | tee -a $TEMP
#mailx root@localhost -s "$(hostname): USB Backup LOG $(date +%Y-%m-%d)"  < $TEMP
cp $TEMP $LOG
rm -f $TEMP
