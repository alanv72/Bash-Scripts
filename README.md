# Readme

This script is used to ban malicious IPs trying to login your Linux server vis ssh or other ways.

Download this script into your directory.

Usage:

``` shell
# chmod +x ssh_autoban
# echo "*/5 * * * * sh /your_path/ssh_autoban.sh" /var/spool/cron/root
```
> * Do change the path string where your ssh_autoban file locates 
> * You can change the crontab line to configure script run interval
> * To view the banned hackers' IPs in the script path:
>   `# cat hacker.iplist`

That's it.
