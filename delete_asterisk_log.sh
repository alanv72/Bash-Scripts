#/bin/bash

############## VERSION 1.0 ON 17th,FEB,2019 #################
# I generate this script to delete large asterisk log file
# in case that the file system has no spare space and the 
# database software Mariadb cannot work properly.
#############################################################


LOGFILE=/var/log/asterisk/full
SIZE_1M_BYTES=1048576

if [ -f $LOGFILE ] ; then
	LOGFILE_SIZE=`du -b $LOGFILE | awk '{print $1}'`
	if [ $(($LOGFILE_SIZE/$SIZE_1M_BYTES)) -gt 500 ]; then
		echo "Asterisk log file is greater than 500M:" $LOGFILE
		rm -f $LOGFILE
		if [ ! -e $LOGFILE ]; then
			echo "Large asterisk log file is removed."
		fi
	fi
else
	echo "No such asterisk log file:" $LOGFILE
fi 
