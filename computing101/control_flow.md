# Control Flow

## Comparing Values

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rdi, [rsp]
  cmp rdi, 42
  setz dil
  mov rax, 60
  syscall
```

```
ubuntu@control-flow~comparing-values:~$ ./assemble.sh asm.s
ubuntu@control-flow~comparing-values:~$ /challenge/check a.out

Checking that your assembly compares argc against 42...
Your assembly looks correct!

Let's run your program with different numbers of arguments to check the comparison!

hacker@control-flow~comparing-values:/home/hacker$ a.out a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a
hacker@control-flow~comparing-values:/home/hacker$ echo $?
1

hacker@control-flow~comparing-values:/home/hacker$ a.out a a a a a a a a a a a a a a a
hacker@control-flow~comparing-values:/home/hacker$ echo $?
0

hacker@control-flow~comparing-values:/home/hacker$ a.out a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a
hacker@control-flow~comparing-values:/home/hacker$ echo $?
0
hacker@control-flow~comparing-values:/home/hacker$ 

Your program correctly uses cmp and setz to compare argc against 42! Nice work!

Here is your flag!
pwn.college{QFw8fie5tIbgtrIFTinW0E8PGFr.01M0czMywyMyITOyEzW}
```

## Comparing Characters

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, [rsp+16]
  cmp BYTE PTR [rax], 'p'
  setz dil
  mov rax, 60
  syscall
```

```
ubuntu@control-flow~comparing-characters:~$ /challenge/check a.out

Checking that your assembly compares the first byte of argv[1] against 'p'...
Your assembly looks correct!

Let's run your program with different arguments to check the comparison!

hacker@control-flow~comparing-characters:/home/hacker$ a.out pwn
hacker@control-flow~comparing-characters:/home/hacker$ echo $?
1

hacker@control-flow~comparing-characters:/home/hacker$ a.out Xray
hacker@control-flow~comparing-characters:/home/hacker$ echo $?
0

hacker@control-flow~comparing-characters:/home/hacker$ a.out zzz
hacker@control-flow~comparing-characters:/home/hacker$ echo $?
0
hacker@control-flow~comparing-characters:/home/hacker$ 

Your program correctly compares the first character of argv[1] against 'p'! Nice work!

Here is your flag!
pwn.college{cBzZqlvvdtO4BjU_rCJmFRlkJJH.0FN0czMywyMyITOyEzW}
```

## Conditional Control Flow

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, [rsp+16]
  cmp BYTE PTR [rax], 'p'
  mov rax, 60
  jne fail
  mov rdi, 0
  syscall
fail:
  mov rdi, 1
  syscall
```

```
ubuntu@control-flow~conditional-control-flow:~$ /challenge/check a.out

Checking that your assembly uses conditional jumps...
Your assembly looks correct!

Let's run your program with different arguments to check the conditional jump!

hacker@control-flow~conditional-control-flow:/home/hacker$ a.out pwn
hacker@control-flow~conditional-control-flow:/home/hacker$ echo $?
0
hacker@control-flow~conditional-control-flow:/home/hacker$ a.out hello
hacker@control-flow~conditional-control-flow:/home/hacker$ echo $?
1
hacker@control-flow~conditional-control-flow:/home/hacker$ a.out abc
hacker@control-flow~conditional-control-flow:/home/hacker$ echo $?
1
Your program correctly uses jne to branch on the comparison! Nice work!

Here is your flag!
pwn.college{MtEqZpah_89qQzaS32pmF_HXqDN.0VN0czMywyMyITOyEzW}
```

## Comparing Strings

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, [rsp+16]
  cmp BYTE PTR [rax], 'p'
  jne fail
  cmp BYTE PTR [rax+1], 'w'
  jne fail
  cmp BYTE PTR [rax+2], 'n'
  jne fail
  mov rdi, 0
  mov rax, 60
  syscall
fail:
  mov rdi, 1
  mov rax, 60
  syscall
```

```
ubuntu@control-flow~comparing-strings:~$ /challenge/check a.out

Checking that your assembly compares multiple characters of argv[1]...
Your assembly looks correct!

Let's run your program with different arguments to check the string comparison!

hacker@control-flow~comparing-strings:/home/hacker$ a.out pwn
hacker@control-flow~comparing-strings:/home/hacker$ echo $?
0

hacker@control-flow~comparing-strings:/home/hacker$ a.out pwnage
hacker@control-flow~comparing-strings:/home/hacker$ echo $?
0

hacker@control-flow~comparing-strings:/home/hacker$ a.out xwn
hacker@control-flow~comparing-strings:/home/hacker$ echo $?
1

hacker@control-flow~comparing-strings:/home/hacker$ a.out pan
hacker@control-flow~comparing-strings:/home/hacker$ echo $?
1
Your program correctly checks for the string "pwn"! Nice work!

Here is your flag!
pwn.college{sr6Fney8_w9NsgI7cu3NAJTSuzA.0lN0czMywyMyITOyEzW}
```

## Reverse the Password

WARNING: `/challenge/reverse-me` is a SUID binary --- it runs with elevated privileges so it can read `/flag`. However, debugging a program will drop its SUID privileges, which means the `open("/flag")` syscall inside will silently fail if you run it under gdb. You can use gdb or `objdump` to understand the binary and figure out the password, but make sure to run it directly (outside of gdb) to get the flag.

```
ubuntu@control-flow~reverse-the-password:~$ objdump -d -M intel /challenge/reverse-me

/challenge/reverse-me:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:       48 8b 44 24 10          mov    rax,QWORD PTR [rsp+0x10]
  401005:       80 38 6a                cmp    BYTE PTR [rax],0x6a
  401008:       75 74                   jne    40107e <fail>
  40100a:       80 78 01 6a             cmp    BYTE PTR [rax+0x1],0x6a
  40100e:       75 6e                   jne    40107e <fail>
  401010:       80 78 02 6f             cmp    BYTE PTR [rax+0x2],0x6f
  401014:       75 68                   jne    40107e <fail>
  401016:       80 78 03 68             cmp    BYTE PTR [rax+0x3],0x68
  40101a:       75 62                   jne    40107e <fail>
  40101c:       c6 04 24 2f             mov    BYTE PTR [rsp],0x2f
  401020:       c6 44 24 01 66          mov    BYTE PTR [rsp+0x1],0x66
  401025:       c6 44 24 02 6c          mov    BYTE PTR [rsp+0x2],0x6c
  40102a:       c6 44 24 03 61          mov    BYTE PTR [rsp+0x3],0x61
  40102f:       c6 44 24 04 67          mov    BYTE PTR [rsp+0x4],0x67
  401034:       c6 44 24 05 00          mov    BYTE PTR [rsp+0x5],0x0
  401039:       48 89 e7                mov    rdi,rsp
  40103c:       48 c7 c6 00 00 00 00    mov    rsi,0x0
  401043:       48 c7 c0 02 00 00 00    mov    rax,0x2
  40104a:       0f 05                   syscall
  40104c:       48 89 c7                mov    rdi,rax
  40104f:       48 89 e6                mov    rsi,rsp
  401052:       48 c7 c2 40 00 00 00    mov    rdx,0x40
  401059:       48 c7 c0 00 00 00 00    mov    rax,0x0
  401060:       0f 05                   syscall
  401062:       48 89 c2                mov    rdx,rax
  401065:       48 c7 c7 01 00 00 00    mov    rdi,0x1
  40106c:       48 c7 c0 01 00 00 00    mov    rax,0x1
  401073:       0f 05                   syscall
  401075:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  40107c:       0f 05                   syscall

000000000040107e <fail>:
  40107e:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  401085:       0f 05                   syscall
```

```
>>> chr(0x6a)
'j'
>>> a = [0x6a, 0x6a, 0x6f, 0x68, 0x2f, 0x66, 0x6c, 0x61, 0x67]
>>> s = ""
>>> for c in a:
...     s += chr(c)
...
>>> print(s)
jjoh/flag
```

```
ubuntu@control-flow~reverse-the-password:~$ /challenge/reverse-me jjoh
pwn.college{wIMJnBXujKxTqiKYQ6iKtZWq1vt.01N0czMywyMyITOyEzW}
```

## Conditionals Without Conditionals

```
ubuntu@control-flow~conditionals-without-conditionals:~$ gdb /challenge/reverse-me 
Reading symbols from /challenge/reverse-me...
(No debugging symbols found in /challenge/reverse-me)
(gdb) starti
Starting program: /challenge/reverse-me 

This GDB supports auto-downloading debuginfo from the following URLs:
  <https://debuginfod.ubuntu.com>
Enable debuginfod for this session? (y or [n]) n
Debuginfod has been disabled.
To make this setting permanent, add 'set debuginfod enabled off' to .gdbinit.

Program stopped.
0x0000000000401000 in _start ()
(gdb) disass
Dump of assembler code for function _start:
=> 0x0000000000401000 <+0>:     mov    rcx,QWORD PTR [rsp+0x10]
   0x0000000000401005 <+5>:     xor    eax,eax
   0x0000000000401007 <+7>:     mov    al,BYTE PTR [rcx]
   0x0000000000401009 <+9>:     mov    rax,QWORD PTR [rax*8+0x401085]
   0x0000000000401011 <+17>:    jmp    rax
End of assembler dump.
(gdb) stepi
0x0000000000401005 in _start ()
(gdb) print $rcx
$1 = 0
(gdb) x/a $rcx
0x0:    Cannot access memory at address 0x0
(gdb) x/a 0x401085
0x401085 <jump_table>:  0x401075 <fail>
(gdb) x/256a 0x401085
0x401085 <jump_table>:  0x401075 <fail> 0x401075 <fail>
0x401095 <jump_table+16>:       0x401075 <fail> 0x401075 <fail>
0x4010a5 <jump_table+32>:       0x401075 <fail> 0x401075 <fail>
0x4010b5 <jump_table+48>:       0x401075 <fail> 0x401075 <fail>
0x4010c5 <jump_table+64>:       0x401075 <fail> 0x401075 <fail>
0x4010d5 <jump_table+80>:       0x401075 <fail> 0x401075 <fail>
0x4010e5 <jump_table+96>:       0x401075 <fail> 0x401075 <fail>
0x4010f5 <jump_table+112>:      0x401075 <fail> 0x401075 <fail>
0x401105 <jump_table+128>:      0x401075 <fail> 0x401075 <fail>
0x401115 <jump_table+144>:      0x401075 <fail> 0x401075 <fail>
0x401125 <jump_table+160>:      0x401075 <fail> 0x401075 <fail>
0x401135 <jump_table+176>:      0x401075 <fail> 0x401075 <fail>
0x401145 <jump_table+192>:      0x401075 <fail> 0x401075 <fail>
0x401155 <jump_table+208>:      0x401075 <fail> 0x401075 <fail>
0x401165 <jump_table+224>:      0x401075 <fail> 0x401075 <fail>
0x401175 <jump_table+240>:      0x401075 <fail> 0x401075 <fail>
0x401185 <jump_table+256>:      0x401075 <fail> 0x401075 <fail>
0x401195 <jump_table+272>:      0x401075 <fail> 0x401075 <fail>
0x4011a5 <jump_table+288>:      0x401075 <fail> 0x401075 <fail>
0x4011b5 <jump_table+304>:      0x401075 <fail> 0x401075 <fail>
0x4011c5 <jump_table+320>:      0x401075 <fail> 0x401075 <fail>
0x4011d5 <jump_table+336>:      0x401075 <fail> 0x401075 <fail>
0x4011e5 <jump_table+352>:      0x401075 <fail> 0x401075 <fail>
0x4011f5 <jump_table+368>:      0x401075 <fail> 0x401075 <fail>
0x401205 <jump_table+384>:      0x401075 <fail> 0x401075 <fail>
0x401215 <jump_table+400>:      0x401075 <fail> 0x401075 <fail>
0x401225 <jump_table+416>:      0x401075 <fail> 0x401075 <fail>
0x401235 <jump_table+432>:      0x401075 <fail> 0x401075 <fail>
0x401245 <jump_table+448>:      0x401075 <fail> 0x401075 <fail>
0x401255 <jump_table+464>:      0x401075 <fail> 0x401075 <fail>
0x401265 <jump_table+480>:      0x401075 <fail> 0x401075 <fail>
0x401275 <jump_table+496>:      0x401075 <fail> 0x401075 <fail>
0x401285 <jump_table+512>:      0x401075 <fail> 0x401075 <fail>
0x401295 <jump_table+528>:      0x401075 <fail> 0x401075 <fail>
--Type <RET> for more, q to quit, c to continue without paging--
0x4012a5 <jump_table+544>:      0x401075 <fail> 0x401075 <fail>
0x4012b5 <jump_table+560>:      0x401075 <fail> 0x401075 <fail>
0x4012c5 <jump_table+576>:      0x401075 <fail> 0x401075 <fail>
0x4012d5 <jump_table+592>:      0x401075 <fail> 0x401075 <fail>
0x4012e5 <jump_table+608>:      0x401075 <fail> 0x401075 <fail>
0x4012f5 <jump_table+624>:      0x401075 <fail> 0x401075 <fail>
0x401305 <jump_table+640>:      0x401075 <fail> 0x401075 <fail>
0x401315 <jump_table+656>:      0x401075 <fail> 0x401075 <fail>
0x401325 <jump_table+672>:      0x401075 <fail> 0x401075 <fail>
0x401335 <jump_table+688>:      0x401075 <fail> 0x401075 <fail>
0x401345 <jump_table+704>:      0x401075 <fail> 0x401075 <fail>
0x401355 <jump_table+720>:      0x401075 <fail> 0x401075 <fail>
0x401365 <jump_table+736>:      0x401075 <fail> 0x401075 <fail>
0x401375 <jump_table+752>:      0x401075 <fail> 0x401075 <fail>
0x401385 <jump_table+768>:      0x401075 <fail> 0x401075 <fail>
0x401395 <jump_table+784>:      0x401075 <fail> 0x401075 <fail>
0x4013a5 <jump_table+800>:      0x401075 <fail> 0x401075 <fail>
0x4013b5 <jump_table+816>:      0x401075 <fail> 0x401075 <fail>
0x4013c5 <jump_table+832>:      0x401013 <success>      0x401075 <fail>
0x4013d5 <jump_table+848>:      0x401075 <fail> 0x401075 <fail>
0x4013e5 <jump_table+864>:      0x401075 <fail> 0x401075 <fail>
0x4013f5 <jump_table+880>:      0x401075 <fail> 0x401075 <fail>
0x401405 <jump_table+896>:      0x401075 <fail> 0x401075 <fail>
0x401415 <jump_table+912>:      0x401075 <fail> 0x401075 <fail>
0x401425 <jump_table+928>:      0x401075 <fail> 0x401075 <fail>
0x401435 <jump_table+944>:      0x401075 <fail> 0x401075 <fail>
0x401445 <jump_table+960>:      0x401075 <fail> 0x401075 <fail>
0x401455 <jump_table+976>:      0x401075 <fail> 0x401075 <fail>
0x401465 <jump_table+992>:      0x401075 <fail> 0x401075 <fail>
0x401475 <jump_table+1008>:     0x401075 <fail> 0x401075 <fail>
0x401485 <jump_table+1024>:     0x401075 <fail> 0x401075 <fail>
0x401495 <jump_table+1040>:     0x401075 <fail> 0x401075 <fail>
0x4014a5 <jump_table+1056>:     0x401075 <fail> 0x401075 <fail>
0x4014b5 <jump_table+1072>:     0x401075 <fail> 0x401075 <fail>
--Type <RET> for more, q to quit, c to continue without paging--
0x4014c5 <jump_table+1088>:     0x401075 <fail> 0x401075 <fail>
0x4014d5 <jump_table+1104>:     0x401075 <fail> 0x401075 <fail>
0x4014e5 <jump_table+1120>:     0x401075 <fail> 0x401075 <fail>
0x4014f5 <jump_table+1136>:     0x401075 <fail> 0x401075 <fail>
0x401505 <jump_table+1152>:     0x401075 <fail> 0x401075 <fail>
0x401515 <jump_table+1168>:     0x401075 <fail> 0x401075 <fail>
0x401525 <jump_table+1184>:     0x401075 <fail> 0x401075 <fail>
0x401535 <jump_table+1200>:     0x401075 <fail> 0x401075 <fail>
0x401545 <jump_table+1216>:     0x401075 <fail> 0x401075 <fail>
0x401555 <jump_table+1232>:     0x401075 <fail> 0x401075 <fail>
0x401565 <jump_table+1248>:     0x401075 <fail> 0x401075 <fail>
0x401575 <jump_table+1264>:     0x401075 <fail> 0x401075 <fail>
0x401585 <jump_table+1280>:     0x401075 <fail> 0x401075 <fail>
0x401595 <jump_table+1296>:     0x401075 <fail> 0x401075 <fail>
0x4015a5 <jump_table+1312>:     0x401075 <fail> 0x401075 <fail>
0x4015b5 <jump_table+1328>:     0x401075 <fail> 0x401075 <fail>
0x4015c5 <jump_table+1344>:     0x401075 <fail> 0x401075 <fail>
0x4015d5 <jump_table+1360>:     0x401075 <fail> 0x401075 <fail>
0x4015e5 <jump_table+1376>:     0x401075 <fail> 0x401075 <fail>
0x4015f5 <jump_table+1392>:     0x401075 <fail> 0x401075 <fail>
0x401605 <jump_table+1408>:     0x401075 <fail> 0x401075 <fail>
0x401615 <jump_table+1424>:     0x401075 <fail> 0x401075 <fail>
0x401625 <jump_table+1440>:     0x401075 <fail> 0x401075 <fail>
0x401635 <jump_table+1456>:     0x401075 <fail> 0x401075 <fail>
0x401645 <jump_table+1472>:     0x401075 <fail> 0x401075 <fail>
0x401655 <jump_table+1488>:     0x401075 <fail> 0x401075 <fail>
0x401665 <jump_table+1504>:     0x401075 <fail> 0x401075 <fail>
0x401675 <jump_table+1520>:     0x401075 <fail> 0x401075 <fail>
0x401685 <jump_table+1536>:     0x401075 <fail> 0x401075 <fail>
0x401695 <jump_table+1552>:     0x401075 <fail> 0x401075 <fail>
0x4016a5 <jump_table+1568>:     0x401075 <fail> 0x401075 <fail>
0x4016b5 <jump_table+1584>:     0x401075 <fail> 0x401075 <fail>
0x4016c5 <jump_table+1600>:     0x401075 <fail> 0x401075 <fail>
0x4016d5 <jump_table+1616>:     0x401075 <fail> 0x401075 <fail>
--Type <RET> for more, q to quit, c to continue without paging--q
Quit
(gdb) exit
A debugging session is active.

        Inferior 1 [process 148] will be killed.

Quit anyway? (y or n) y
ubuntu@control-flow~conditionals-without-conditionals:~$ /challenge/reverse-me 104
ubuntu@control-flow~conditionals-without-conditionals:~$ /challenge/reverse-me h
pwn.college{ccxeM-zBXRCK6-3Vgw5NV1B8DS5.0FO0czMywyMyITOyEzW}
```

Basically, we solved by seeing that `0x4013c5` jumps to *success*.

```python
>>> 0x4013c5 - 0x401085
832
>>> (0x4013c5 - 0x401085) // 8
104
>>> chr(104)
'h'
```

The letter `h` is the correct argument to pass. Interestingly, this problem could also be solved with brute-force.

## Looping

```
ubuntu@control-flow~looping:~$ objdump -M intel -d /challenge/reverse-me 

/challenge/reverse-me:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:       48 8b 7c 24 10          mov    rdi,QWORD PTR [rsp+0x10]
  401005:       c6 04 24 46             mov    BYTE PTR [rsp],0x46
  401009:       c6 44 24 01 64          mov    BYTE PTR [rsp+0x1],0x64
  40100e:       c6 44 24 02 48          mov    BYTE PTR [rsp+0x2],0x48
  401013:       c6 44 24 03 55          mov    BYTE PTR [rsp+0x3],0x55
  401018:       c6 44 24 04 53          mov    BYTE PTR [rsp+0x4],0x53
  40101d:       c6 44 24 05 45          mov    BYTE PTR [rsp+0x5],0x45
  401022:       c6 44 24 06 00          mov    BYTE PTR [rsp+0x6],0x0
  401027:       48 8d 34 24             lea    rsi,[rsp]

000000000040102b <loop>:
  40102b:       8a 06                   mov    al,BYTE PTR [rsi]
  40102d:       3a 07                   cmp    al,BYTE PTR [rdi]
  40102f:       75 6e                   jne    40109f <fail>
  401031:       3c 00                   cmp    al,0x0
  401033:       74 08                   je     40103d <success>
  401035:       48 ff c7                inc    rdi
  401038:       48 ff c6                inc    rsi
  40103b:       eb ee                   jmp    40102b <loop>

000000000040103d <success>:
  40103d:       c6 04 24 2f             mov    BYTE PTR [rsp],0x2f
  401041:       c6 44 24 01 66          mov    BYTE PTR [rsp+0x1],0x66
  401046:       c6 44 24 02 6c          mov    BYTE PTR [rsp+0x2],0x6c
  40104b:       c6 44 24 03 61          mov    BYTE PTR [rsp+0x3],0x61
  401050:       c6 44 24 04 67          mov    BYTE PTR [rsp+0x4],0x67
  401055:       c6 44 24 05 00          mov    BYTE PTR [rsp+0x5],0x0
  40105a:       48 89 e7                mov    rdi,rsp
  40105d:       48 c7 c6 00 00 00 00    mov    rsi,0x0
  401064:       48 c7 c0 02 00 00 00    mov    rax,0x2
  40106b:       0f 05                   syscall
  40106d:       48 89 c7                mov    rdi,rax
  401070:       48 89 e6                mov    rsi,rsp
  401073:       48 c7 c2 40 00 00 00    mov    rdx,0x40
  40107a:       48 c7 c0 00 00 00 00    mov    rax,0x0
  401081:       0f 05                   syscall
  401083:       48 89 c2                mov    rdx,rax
  401086:       48 c7 c7 01 00 00 00    mov    rdi,0x1
  40108d:       48 c7 c0 01 00 00 00    mov    rax,0x1
  401094:       0f 05                   syscall
  401096:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  40109d:       0f 05                   syscall

000000000040109f <fail>:
  40109f:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  4010a6:       0f 05                   syscall
ubuntu@control-flow~looping:~$ /challenge/reverse-me FdHUSE
pwn.college{YCku1UgtOmVB3ZIn2H_oulvbw6p.0VO0czMywyMyITOyEzW}
```

```python
>>> a = [0x46, 0x64, 0x48, 0x55, 0x53, 0x45]
>>> s = ""
>>> for c in a:
...     s += chr(c)
...
>>> print(s)
FdHUSE
```
