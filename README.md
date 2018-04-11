# Readme

This script is used to ban malicious IPs trying to login your Linux server vis ssh or other ways.

Usage:

Download the script file into your server, enter the path and execute the following commands.

``` shell
# chmod +x ssh_autoban.sh
# echo "*/5 * * * * sh /your_path/ssh_autoban.sh" >> /var/spool/cron/root
```
> * Do change the path string where your ssh_autoban file locates 
> * You can change the crontab line to configure script run interval
> * To view the banned hackers' IPs in the script path:
>   `# cat hacker.iplist`
>   or
>   `# cat /etc/hosts.deny`

That's it.
