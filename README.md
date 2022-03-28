## docker-compose-backup.sh
Script to backup docker-compose project. Make sure to setup your docker-compose project to store all the configuration and volume data under one directory.

### Installation
Download the script and make it as executable
```bash
ubuntu@adguardhome:~$ chmod +x docker-compose-backup.sh
ubuntu@adguardhome:~$ ./docker-compose-backup.sh
Missing input!

Bash script to backup docker-compose container.
Make sure setup your docker-compose to store all configuration
and volume data in the same directory.

Syntax: docker-compose-backup.sh DOCKER-COMPOSE-FOLDER_NAME [-h|V]
options:
h     Print this Help.
V     Print software version and exit.
```
### Configuration
Edit the script to customize the backup
```bash
bk_source="/home/ubuntu" # Location of your docker-compose project
bk_dest="/home/ubuntu/backup" # Directory to store the backup
bk_retention="1" # Backup retention for housekeeping
dc_down_wait="20" # Allow time before docker-compose shutdown
dc_up_wait="40" # Allow time before docker-compose startup
```

### Backup exclude .git folder or file
Change or modify the script if want to exclude folders or files
```bash
# archive docker container and volume data
cd ${bk_source} && tar -zcvf ${bk_dest}/$1_${bk_date}.tar.gz $1
# archive docker container and volume data with file exclude
#cd ${bk_source} && tar -zcvf ${bk_dest}/$1_${bk_date}.tar.gz --exclude-vcs --exlude="*.md" $1
```

### Reboot and reset tarball permission
If you enable [iptables_ddns_update.sh](https://github.com/hat3ph/docker-adguard-unbound/blob/main/iptables_ddns_update.sh), might want to reboot the docker host to reset the iptables rules.
I have add command to reset iptables DOCKER chain so this step is no longer needed. But you can opt to enable it to be safe.
```bash
#Optional to reboot the host
#/usr/sbin/reboot
```

### Backup retention
Enable below if want to housekeep the docker-compose backup tarball.
```bash
bk_retention="1" # Backup retention for housekeeping
# keep how many of backup copy
# example +1 will keep latest 2 copies of backup
# uncomment below to enable backup housekeeping
#find ${bk_dest} -name "*.tar.gz" -type f -mtime +${bk_retention}
#find ${bk_dest} -name "*.tar.gz" -type f -mtime +${bk_retention} -delete
```

### Cron schedule backup
Create `/etc/cron.d/docker-compose-backup` and set the time to auto run the script.
Only require root if you are not running docker as non-root or need root access to backup/execute command.
```bash
MAILTO=""
0 1 * * * root /path/docker-compose-backup.sh "$docker-compose-folder-name$" > /dev/null 2>&1
```

### View tarball contents
Use below command to view the tarball contents
```BASH
ubuntu@adguardhome:~/backup$ tar -tvf docker-adguard-unbound_2022-03-19T21_00_01.tar.gz
drwxrwxr-x ubuntu/ubuntu     0 2022-03-14 00:00 docker-adguard-unbound/
drwxr-xr-x root/root         0 2022-03-13 21:05 docker-adguard-unbound/adguard/
drwxr-xr-x root/root         0 2022-03-19 20:38 docker-adguard-unbound/adguard/opt-adguard-conf/
-rw-r--r-- root/root      3262 2022-03-19 20:38 docker-adguard-unbound/adguard/opt-adguard-conf/AdGuardHome.yaml
drwxr-xr-x root/root         0 2022-03-13 21:05 docker-adguard-unbound/adguard/opt-adguard-work/
drwxr-xr-x root/root         0 2022-03-14 00:16 docker-adguard-unbound/adguard/opt-adguard-work/data/
-rw-r--r-- root/root    262144 2022-03-19 21:00 docker-adguard-unbound/adguard/opt-adguard-work/data/stats.db
drwxr-xr-x root/root         0 2022-03-19 08:32 docker-adguard-unbound/adguard/opt-adguard-work/data/filters/
-rw-r--r-- root/root    295608 2022-03-19 08:32 docker-adguard-unbound/adguard/opt-adguard-work/data/filters/1647187024.txt
-rw-r--r-- root/root     72910 2022-03-19 08:32 docker-adguard-unbound/adguard/opt-adguard-work/data/filters/1647187026.txt
-rw-r--r-- root/root    263683 2022-03-19 08:32 docker-adguard-unbound/adguard/opt-adguard-work/data/filters/2.txt
-rw-r--r-- root/root    866808 2022-03-19 08:32 docker-adguard-unbound/adguard/opt-adguard-work/data/filters/1.txt
-rw-r--r-- root/root   1184851 2022-03-19 08:32 docker-adguard-unbound/adguard/opt-adguard-work/data/filters/1647187025.txt
-rw-r--r-- root/root     32768 2022-03-16 17:18 docker-adguard-unbound/adguard/opt-adguard-work/data/sessions.db
-rw-r--r-- root/root  33405544 2022-03-17 21:26 docker-adguard-unbound/adguard/opt-adguard-work/data/querylog.json
-rwxrwxr-x ubuntu/ubuntu   350 2022-03-13 20:53 docker-adguard-unbound/letsencrypt_renewal_post_hook.sh
-rw-rw-r-- ubuntu/ubuntu  4317 2022-03-13 20:53 docker-adguard-unbound/README.md
-rwxrwxr-x ubuntu/ubuntu  1306 2022-03-14 00:00 docker-adguard-unbound/iptables_ddns_update.sh
drwxrwxr-x ubuntu/ubuntu     0 2022-03-19 10:37 docker-adguard-unbound/unbound/
-rw-rw-r-- ubuntu/ubuntu  3762 2022-03-19 10:37 docker-adguard-unbound/unbound/unbound.conf
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/
-rw-rw-r-- ubuntu/ubuntu   112 2022-03-13 20:53 docker-adguard-unbound/.git/packed-refs
-rw-rw-r-- ubuntu/ubuntu   273 2022-03-13 20:53 docker-adguard-unbound/.git/config
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/
-rwxrwxr-x ubuntu/ubuntu   424 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/pre-applypatch.sample
-rwxrwxr-x ubuntu/ubuntu   896 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/commit-msg.sample
-rwxrwxr-x ubuntu/ubuntu  1492 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/prepare-commit-msg.sample
-rwxrwxr-x ubuntu/ubuntu  3079 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/fsmonitor-watchman.sample
-rwxrwxr-x ubuntu/ubuntu  3610 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/update.sample
-rwxrwxr-x ubuntu/ubuntu   478 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/applypatch-msg.sample
-rwxrwxr-x ubuntu/ubuntu  4898 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/pre-rebase.sample
-rwxrwxr-x ubuntu/ubuntu  1348 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/pre-push.sample
-rwxrwxr-x ubuntu/ubuntu   189 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/post-update.sample
-rwxrwxr-x ubuntu/ubuntu  1638 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/pre-commit.sample
-rwxrwxr-x ubuntu/ubuntu   416 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/pre-merge-commit.sample
-rwxrwxr-x ubuntu/ubuntu   544 2022-03-13 20:53 docker-adguard-unbound/.git/hooks/pre-receive.sample
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/info/
-rw-rw-r-- ubuntu/ubuntu   240 2022-03-13 20:53 docker-adguard-unbound/.git/info/exclude
-rw-rw-r-- ubuntu/ubuntu    73 2022-03-13 20:53 docker-adguard-unbound/.git/description
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/logs/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/logs/refs/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/logs/refs/remotes/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/logs/refs/remotes/origin/
-rw-rw-r-- ubuntu/ubuntu   193 2022-03-13 20:53 docker-adguard-unbound/.git/logs/refs/remotes/origin/HEAD
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/logs/refs/heads/
-rw-rw-r-- ubuntu/ubuntu   193 2022-03-13 20:53 docker-adguard-unbound/.git/logs/refs/heads/main
-rw-rw-r-- ubuntu/ubuntu   193 2022-03-13 20:53 docker-adguard-unbound/.git/logs/HEAD
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/objects/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/objects/pack/
-r--r--r-- ubuntu/ubuntu 44293 2022-03-13 20:53 docker-adguard-unbound/.git/objects/pack/pack-3c1a0d55726244dc536c92f90d0c55080e5c4255.pack
-r--r--r-- ubuntu/ubuntu  5216 2022-03-13 20:53 docker-adguard-unbound/.git/objects/pack/pack-3c1a0d55726244dc536c92f90d0c55080e5c4255.idx
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/objects/info/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/refs/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/refs/remotes/
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/refs/remotes/origin/
-rw-rw-r-- ubuntu/ubuntu    30 2022-03-13 20:53 docker-adguard-unbound/.git/refs/remotes/origin/HEAD
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/refs/heads/
-rw-rw-r-- ubuntu/ubuntu    41 2022-03-13 20:53 docker-adguard-unbound/.git/refs/heads/main
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/refs/tags/
-rw-rw-r-- ubuntu/ubuntu   721 2022-03-13 20:53 docker-adguard-unbound/.git/index
-rw-rw-r-- ubuntu/ubuntu    21 2022-03-13 20:53 docker-adguard-unbound/.git/HEAD
drwxrwxr-x ubuntu/ubuntu     0 2022-03-13 20:53 docker-adguard-unbound/.git/branches/
-rwxrwxr-x ubuntu/ubuntu   183 2022-03-13 20:53 docker-adguard-unbound/letsencrypt_renewal_pre_hook.sh
-rwxrwxr-x ubuntu/ubuntu   692 2022-03-13 20:53 docker-adguard-unbound/disable_dnsstublistener.sh
-rw-rw-r-- ubuntu/ubuntu  1183 2022-03-13 21:23 docker-adguard-unbound/docker-compose.yml
```

### Un-archive the backup
Use below command to un-archive the backup tarball.
Use sudo if your tarball content have root permission.
```bash
sudo tar –xvzf backupXXX.tar.gz –C /destination
```

### Download the tarball as backup
Use scp to download the tarball to local as backup.
```bash
scp -r -i /path/ssl.key username@xxx.xxx.xxx.xxx:/path/backup /path/destination
```
Use rsync to download the tarball to local as backup. Both host and client need to install the rsync program.
```bash
rsync -ave "ssh -i /path/ssl.k" ubuntu@xxx.xxx.xxx.xxx:/path/backup /path/destination
```
