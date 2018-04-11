#!/bin/bash

# Denven modified this script on March 13, 2018

#cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2 "\t" "tried times: "$1;}' > /root/ssh_secure/failed_iplist

# divide this commands combiantion into several lines
# 1、strip the IP from the log message and sort the same ip lines together
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort > ip.sorted.tmp

# 2、count the ip lines from the same source and formated it into single line
#    Format is: xxx.xx.xxx.xx tried times: yyy 
#               x and y are digits
cat ip.sorted.tmp | uniq -c|awk '{print $2 "\t" "tried times: "$1;}' > ip.attempttimes.tmp

# 3、sort the lines by count of attempt from the same ip (from greater-->less)
sort -nrk 2 -t: ip.attempttimes.tmp > hacker.iplist 

################################################################################
## if the hacker attempted 5 times at least, we will block his IP
##
TRIED_TIMES="5"

sed s/[[:space:]]//g hacker.iplist > hacker.iplist.tmp
for i in `cat hacker.iplist.tmp`
do
    IP=`echo $i |awk -F"\t" '{print $1}'`
    NUM=`echo $i |awk -F: '{print $2}'`
    if [ $NUM -gt $TRIED_TIMES ]; then
        grep $IP /etc/hosts.deny > /dev/null
        if [ $? -gt 0 ]; then
            echo "sshd:$IP:deny" >> /etc/hosts.deny
        fi
    fi
done
###############################################################################

# 4、remove the temp files
rm -f *.tmp

# to clear mail file content in case of errors accumulation
echo > /var/spool/mail/root
