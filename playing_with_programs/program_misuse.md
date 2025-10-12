# Program Misuse

## cat

```
hacker@program-misuse~cat:~$ ls -la $(which cat)
lrwxrwxrwx 1 root root 12 Oct 12 14:20 /run/challenge/bin/cat -> /usr/bin/cat
hacker@program-misuse~cat:~$ ls -la /usr/bin/cat
-rwsr-xr-x 1 root root 43416 Sep  5  2019 /usr/bin/cat
hacker@program-misuse~cat:~$ ls -la /flag
-r-------- 1 root root 58 Oct 12 14:20 /flag
hacker@program-misuse~cat:~$ cat /flag
pwn.college{gB57rQcztvbvTKRbxx0kMhsKLpA.dNDNxwyMyITOyEzW}
```

## more

```
hacker@program-misuse~more:~$ more /flag
pwn.college{kc17DooH_bFHtjcsmxdQOBhDCPn.dRDNxwyMyITOyEzW}
```

## less

```
hacker@program-misuse~more:~$ less /flag
pwn.college{kFC024L3VcsC4IGaUrg_yCwlorL.dVDNxwyMyITOyEzW}
```

## tail

```
hacker@program-misuse~tail:~$ tail /flag
pwn.college{o8JdPiPr0nOl-aL171rK50yPBnE.dZDNxwyMyITOyEzW}
```

## head

```
hacker@program-misuse~head:~$ head /flag
pwn.college{kvSi5DlrEnrcxnBeUdcQ0zJ1IRV.ddDNxwyMyITOyEzW}
```

## sort

```
hacker@program-misuse~sort:~$ sort /flag
pwn.college{UB6xkxTZqgp3ZjEw_m7DkUEA_up.dhDNxwyMyITOyEzW}
```

## vim

```
hacker@program-misuse~sort:~$ vim /flag
pwn.college{M0OcH8T9l9bkNTZqVv372MbSLta.dlDNxwyMyITOyEzW}
```

## emacs

```
hacker@program-misuse~emacs:~$ emacs /flag
pwn.college{sTEmwtBNAew8CpeLT6dTKPefpZc.dBTNxwyMyITOyEzW}
```

## nano

```
hacker@program-misuse~nano:~$ nano /flag
pwn.college{snuo1hOYMG5LuZO-V8wpAjxGDjO.dFTNxwyMyITOyEzW}
```

## rev

```
hacker@program-misuse~rev:~$ rev /flag | rev
pwn.college{gXiTXgM7bJxlZ_mB4hlGotzhqym.dJTNxwyMyITOyEzW}
```

## od

```
hacker@program-misuse~od:~$ od /flag -c
0000000   p   w   n   .   c   o   l   l   e   g   e   {   k   U   y   q
0000020   3   P   b   N   k   g   U   w   A   4   N   U   r   7   z   1
0000040   U   E   v   B   u   W   X   .   d   N   T   N   x   w   y   M
0000060   y   I   T   O   y   E   z   W   }  \n
0000072
```

Flag: `pwn.college{kUyq3PbNkgUwA4NUr7z1UEvBuWX.dNTNxwyMyITOyEzW}`

## hd (hexdump)

```
hacker@program-misuse~hd:~$ ls -la $(which hd)
lrwxrwxrwx 1 root root 11 Oct 12 14:36 /run/challenge/bin/hd -> /usr/bin/hd
hacker@program-misuse~hd:~$ ls -la /usr/bin/hd
lrwxrwxrwx 1 root root 7 Mar 30  2020 /usr/bin/hd -> hexdump
hacker@program-misuse~hd:~$ hd /flag
00000000  70 77 6e 2e 63 6f 6c 6c  65 67 65 7b 55 78 48 35  |pwn.college{UxH5|
00000010  50 4e 45 43 50 73 75 4a  6e 43 63 52 52 54 46 53  |PNECPsuJnCcRRTFS|
00000020  79 4a 45 59 30 6f 64 2e  64 52 54 4e 78 77 79 4d  |yJEY0od.dRTNxwyM|
00000030  79 49 54 4f 79 45 7a 57  7d 0a                    |yITOyEzW}.|
0000003a
```

Flag: `pwn.college{UxH5PNECPsuJnCcRRTFSyJEY0od.dRTNxwyMyITOyEzW}`

## xxd

```
hacker@program-misuse~xxd:~$ xxd /flag
00000000: 7077 6e2e 636f 6c6c 6567 657b 5956 6343  pwn.college{YVcC
00000010: 4451 5879 626d 526c 4454 746d 3874 5374  DQXybmRlDTtm8tSt
00000020: 3074 7763 4661 432e 6456 544e 7877 794d  0twcFaC.dVTNxwyM
00000030: 7949 544f 7945 7a57 7d0a                 yITOyEzW}.
```

Flag: `pwn.college{YVcCDQXybmRlDTtm8tSt0twcFaC.dVTNxwyMyITOyEzW}`

## base32

```
hacker@program-misuse~base32:~$ base32 /flag
OB3W4LTDN5WGYZLHMV5USNTOIZGGIMTTK5KVA32XMZLWSSSGG5SUKQ2MJE4VKMZOMRNFITTYO54U
26KJKRHXSRL2K56QU===
hacker@program-misuse~base32:~$ base32 /flag | base32 -d
pwn.college{I6nFLd2sWUPoWfWiJF7eECLI9U3.dZTNxwyMyITOyEzW}
```

## base64

```
hacker@program-misuse~base64:~$ base64 /flag
cHduLmNvbGxlZ2V7VWhjT2VDR0VoNzdkTVotQUhjWHRCVkxiMllwLmRkVE54d3lNeUlUT3lFeld9
Cg==
hacker@program-misuse~base64:~$ base64 /flag | base64 -d
pwn.college{UhcOeCGEh77dMZ-AHcXtBVLb2Yp.ddTNxwyMyITOyEzW}
```

## split

```
hacker@program-misuse~split:~$ ls -la *aa*
ls: cannot access '*aa*': No such file or directory
hacker@program-misuse~split:~$ split /flag
hacker@program-misuse~split:~$ ls -la *aa*
-rw-r--r-- 1 root hacker 58 Oct 12 14:44 xaa
hacker@program-misuse~split:~$ cat xaa
pwn.college{wjwXTi6Fb9aqR-A8zDGsNnGN5dg.dhTNxwyMyITOyEzW}
```

## gzip

```
hacker@program-misuse~gzip:~$ gzip -k /flag
hacker@program-misuse~gzip:~$ ls -la /flag*
-r-------- 1 root root 58 Oct 12 14:45 /flag
-r-------- 1 root root 83 Oct 12 14:45 /flag.gz
hacker@program-misuse~gzip:~$ gzip -c /flag.gz -d
pwn.college{g9Bwi_b7meL1U14KDoIr-PM6We9.dlTNxwyMyITOyEzW}
```

## bzip2

```
hacker@program-misuse~bzip2:~$ bzip2 /flag -k -c | bzip2 -d -c
pwn.college{Mg8ZlqbVWDRNwQ3vftNS5lAJLaf.dBjNxwyMyITOyEzW}
```

## zip

```
hacker@program-misuse~zip:~$ zip flag.zip /flag
  adding: flag (stored 0%)
hacker@program-misuse~zip:~$ unzip flag.zip
Archive:  flag.zip
replace flag? [y]es, [n]o, [A]ll, [N]one, [r]ename: r
new name: theflag
 extracting: theflag
hacker@program-misuse~zip:~$ cat theflag
pwn.college{MulexHwPOpFtG-q067tEiwa8dPU.dFjNxwyMyITOyEzW}
```

## tar

```
hacker@program-misuse~tar:~$ cd /
hacker@program-misuse~tar:/$ tar czf ~/flag.tar flag
hacker@program-misuse~tar:/$ cd ~
hacker@program-misuse~tar:~$ ls -la flag.tar
-rw-r--r-- 1 root hacker 175 Oct 12 14:59 flag.tar
hacker@program-misuse~tar:~$ tar xzvf flag.tar -O
flag
pwn.college{Yp7aAeTD1oawF31sNBpaWXqEAoM.dJjNxwyMyITOyEzW}
```

## ar

```
hacker@program-misuse~ar:~$ ar rs flag.a /flag
ar: creating flag.a
hacker@program-misuse~ar:~$ ls -la flag.a
-rw-r--r-- 1 root hacker 126 Oct 12 15:01 flag.a
hacker@program-misuse~ar:~$ ar x flag.a
hacker@program-misuse~ar:~$ cat flag
pwn.college{ERvcN4xc0fWV6j2YZTKgOgOmADN.dNjNxwyMyITOyEzW}
```
