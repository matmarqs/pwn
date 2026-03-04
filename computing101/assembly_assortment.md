# Assembly Assortment

## Reverse the Calculation

```
ubuntu@assembly-assortment~reverse-the-calculation:~$ objdump -M intel -d /challenge/reverse-me 

/challenge/reverse-me:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:       48 8b 44 24 10          mov    rax,QWORD PTR [rsp+0x10]
  401005:       80 00 1f                add    BYTE PTR [rax],0x1f
  401008:       80 38 52                cmp    BYTE PTR [rax],0x52
  40100b:       75 62                   jne    40106f <fail>
  40100d:       c6 04 24 2f             mov    BYTE PTR [rsp],0x2f
  401011:       c6 44 24 01 66          mov    BYTE PTR [rsp+0x1],0x66
  401016:       c6 44 24 02 6c          mov    BYTE PTR [rsp+0x2],0x6c
  40101b:       c6 44 24 03 61          mov    BYTE PTR [rsp+0x3],0x61
  401020:       c6 44 24 04 67          mov    BYTE PTR [rsp+0x4],0x67
  401025:       c6 44 24 05 00          mov    BYTE PTR [rsp+0x5],0x0
  40102a:       48 89 e7                mov    rdi,rsp
  40102d:       48 c7 c6 00 00 00 00    mov    rsi,0x0
  401034:       48 c7 c0 02 00 00 00    mov    rax,0x2
  40103b:       0f 05                   syscall
  40103d:       48 89 c7                mov    rdi,rax
  401040:       48 89 e6                mov    rsi,rsp
  401043:       48 c7 c2 40 00 00 00    mov    rdx,0x40
  40104a:       48 c7 c0 00 00 00 00    mov    rax,0x0
  401051:       0f 05                   syscall
  401053:       48 89 c2                mov    rdx,rax
  401056:       48 c7 c7 01 00 00 00    mov    rdi,0x1
  40105d:       48 c7 c0 01 00 00 00    mov    rax,0x1
  401064:       0f 05                   syscall
  401066:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  40106d:       0f 05                   syscall

000000000040106f <fail>:
  40106f:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  401076:       0f 05                   syscall
ubuntu@assembly-assortment~reverse-the-calculation:~$ /challenge/reverse-me 3
pwn.college{M1tgxwi1tjGThJkBkXelJEvqrYF.0FM1czMywyMyITOyEzW}
```

```python
>>> 0x52 - 0x1f
51
>>> hex(51)
'0x33'
```

## Reverse the Reverse

```
ubuntu@assembly-assortment~reverse-the-reverse:~$ objdump -M intel -d /challenge/reverse-me

/challenge/reverse-me:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:       48 8b 44 24 10          mov    rax,QWORD PTR [rsp+0x10]
  401005:       80 28 10                sub    BYTE PTR [rax],0x10
  401008:       80 38 67                cmp    BYTE PTR [rax],0x67
  40100b:       75 62                   jne    40106f <fail>
  40100d:       c6 04 24 2f             mov    BYTE PTR [rsp],0x2f
  401011:       c6 44 24 01 66          mov    BYTE PTR [rsp+0x1],0x66
  401016:       c6 44 24 02 6c          mov    BYTE PTR [rsp+0x2],0x6c
  40101b:       c6 44 24 03 61          mov    BYTE PTR [rsp+0x3],0x61
  401020:       c6 44 24 04 67          mov    BYTE PTR [rsp+0x4],0x67
  401025:       c6 44 24 05 00          mov    BYTE PTR [rsp+0x5],0x0
  40102a:       48 89 e7                mov    rdi,rsp
  40102d:       48 c7 c6 00 00 00 00    mov    rsi,0x0
  401034:       48 c7 c0 02 00 00 00    mov    rax,0x2
  40103b:       0f 05                   syscall
  40103d:       48 89 c7                mov    rdi,rax
  401040:       48 89 e6                mov    rsi,rsp
  401043:       48 c7 c2 40 00 00 00    mov    rdx,0x40
  40104a:       48 c7 c0 00 00 00 00    mov    rax,0x0
  401051:       0f 05                   syscall
  401053:       48 89 c2                mov    rdx,rax
  401056:       48 c7 c7 01 00 00 00    mov    rdi,0x1
  40105d:       48 c7 c0 01 00 00 00    mov    rax,0x1
  401064:       0f 05                   syscall
  401066:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  40106d:       0f 05                   syscall

000000000040106f <fail>:
  40106f:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  401076:       0f 05                   syscall
ubuntu@assembly-assortment~reverse-the-reverse:~$ /challenge/reverse-me w
pwn.college{YuSASNhUUo_coZ8LGxXPQvsJKwC.0VM1czMywyMyITOyEzW}
```

## Dealing with Bitwise Operations

```
ubuntu@assembly-assortment~dealing-with-bitwise-operations:~$ objdump -M intel -d /challenge/reverse-me 

/challenge/reverse-me:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:       48 8b 44 24 10          mov    rax,QWORD PTR [rsp+0x10]
  401005:       80 30 3e                xor    BYTE PTR [rax],0x3e
  401008:       80 38 74                cmp    BYTE PTR [rax],0x74
  40100b:       75 62                   jne    40106f <fail>
  40100d:       c6 04 24 2f             mov    BYTE PTR [rsp],0x2f
  401011:       c6 44 24 01 66          mov    BYTE PTR [rsp+0x1],0x66
  401016:       c6 44 24 02 6c          mov    BYTE PTR [rsp+0x2],0x6c
  40101b:       c6 44 24 03 61          mov    BYTE PTR [rsp+0x3],0x61
  401020:       c6 44 24 04 67          mov    BYTE PTR [rsp+0x4],0x67
  401025:       c6 44 24 05 00          mov    BYTE PTR [rsp+0x5],0x0
  40102a:       48 89 e7                mov    rdi,rsp
  40102d:       48 c7 c6 00 00 00 00    mov    rsi,0x0
  401034:       48 c7 c0 02 00 00 00    mov    rax,0x2
  40103b:       0f 05                   syscall
  40103d:       48 89 c7                mov    rdi,rax
  401040:       48 89 e6                mov    rsi,rsp
  401043:       48 c7 c2 40 00 00 00    mov    rdx,0x40
  40104a:       48 c7 c0 00 00 00 00    mov    rax,0x0
  401051:       0f 05                   syscall
  401053:       48 89 c2                mov    rdx,rax
  401056:       48 c7 c7 01 00 00 00    mov    rdi,0x1
  40105d:       48 c7 c0 01 00 00 00    mov    rax,0x1
  401064:       0f 05                   syscall
  401066:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  40106d:       0f 05                   syscall

000000000040106f <fail>:
  40106f:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  401076:       0f 05                   syscall
ubuntu@assembly-assortment~dealing-with-bitwise-operations:~$ /challenge/reverse-me J
pwn.college{EYV-TLYA3kq8qhkQY1K3P2Fxiwv.0lM1czMywyMyITOyEzW}
```

```python
>>> 0x3e ^ 0x74
74
>>> chr(0x3e ^ 0x74)
'J'
```

## Loops on Data

```
ubuntu@assembly-assortment~loops-on-data:~$ objdump -s -j .rodata /challenge/reverse-me 

/challenge/reverse-me:     file format elf64-x86-64

Contents of section .rodata:
 402000 64756e4a 5a7600                      dunJZv.
ubuntu@assembly-assortment~loops-on-data:~$ /challenge/reverse-me dunJZv
pwn.college{IjdsAKe2TcdXDIVWFB2zDVudiKY.01M1czMywyMyITOyEzW}
```

```
ubuntu@assembly-assortment~loops-on-data:~$ gdb /challenge/reverse-me 
Reading symbols from /challenge/reverse-me...
(No debugging symbols found in /challenge/reverse-me)
(gdb) stepi
The program is not being run.
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
=> 0x0000000000401000 <+0>:     mov    rdi,QWORD PTR [rsp+0x10]
   0x0000000000401005 <+5>:     lea    rsi,[rip+0xff4]        # 0x402000
End of assembler dump.
(gdb) x/s 0x402000
0x402000:       "dunJZv"
(gdb) stepi
0x0000000000401005 in _start ()
(gdb) 
0x000000000040100c in loop ()
(gdb) disass
Dump of assembler code for function loop:
=> 0x000000000040100c <+0>:     mov    al,BYTE PTR [rsi]
   0x000000000040100e <+2>:     cmp    al,BYTE PTR [rdi]
   0x0000000000401010 <+4>:     jne    0x401080 <fail>
   0x0000000000401012 <+6>:     cmp    al,0x0
   0x0000000000401014 <+8>:     je     0x40101e <success>
   0x0000000000401016 <+10>:    inc    rdi
   0x0000000000401019 <+13>:    inc    rsi
   0x000000000040101c <+16>:    jmp    0x40100c <loop>
End of assembler dump.
(gdb) x/30i $rdi
   0x0: Cannot access memory at address 0x0
(gdb) x/30i $rip
=> 0x40100c <loop>:     mov    al,BYTE PTR [rsi]
   0x40100e <loop+2>:   cmp    al,BYTE PTR [rdi]
   0x401010 <loop+4>:   jne    0x401080 <fail>
   0x401012 <loop+6>:   cmp    al,0x0
   0x401014 <loop+8>:   je     0x40101e <success>
   0x401016 <loop+10>:  inc    rdi
   0x401019 <loop+13>:  inc    rsi
   0x40101c <loop+16>:  jmp    0x40100c <loop>
   0x40101e <success>:  mov    BYTE PTR [rsp],0x2f
   0x401022 <success+4>:        mov    BYTE PTR [rsp+0x1],0x66
   0x401027 <success+9>:        mov    BYTE PTR [rsp+0x2],0x6c
   0x40102c <success+14>:       mov    BYTE PTR [rsp+0x3],0x61
   0x401031 <success+19>:       mov    BYTE PTR [rsp+0x4],0x67
   0x401036 <success+24>:       mov    BYTE PTR [rsp+0x5],0x0
   0x40103b <success+29>:       mov    rdi,rsp
   0x40103e <success+32>:       mov    rsi,0x0
   0x401045 <success+39>:       mov    rax,0x2
   0x40104c <success+46>:       syscall
   0x40104e <success+48>:       mov    rdi,rax
   0x401051 <success+51>:       mov    rsi,rsp
   0x401054 <success+54>:       mov    rdx,0x40
   0x40105b <success+61>:       mov    rax,0x0
   0x401062 <success+68>:       syscall
   0x401064 <success+70>:       mov    rdx,rax
   0x401067 <success+73>:       mov    rdi,0x1
   0x40106e <success+80>:       mov    rax,0x1
   0x401075 <success+87>:       syscall
   0x401077 <success+89>:       mov    rax,0x3c
   0x40107e <success+96>:       syscall
   0x401080 <fail>:     mov    rax,0x3c
(gdb) x/40i $rip
=> 0x40100c <loop>:     mov    al,BYTE PTR [rsi]
   0x40100e <loop+2>:   cmp    al,BYTE PTR [rdi]
   0x401010 <loop+4>:   jne    0x401080 <fail>
   0x401012 <loop+6>:   cmp    al,0x0
   0x401014 <loop+8>:   je     0x40101e <success>
   0x401016 <loop+10>:  inc    rdi
   0x401019 <loop+13>:  inc    rsi
   0x40101c <loop+16>:  jmp    0x40100c <loop>
   0x40101e <success>:  mov    BYTE PTR [rsp],0x2f
   0x401022 <success+4>:        mov    BYTE PTR [rsp+0x1],0x66
   0x401027 <success+9>:        mov    BYTE PTR [rsp+0x2],0x6c
   0x40102c <success+14>:       mov    BYTE PTR [rsp+0x3],0x61
   0x401031 <success+19>:       mov    BYTE PTR [rsp+0x4],0x67
   0x401036 <success+24>:       mov    BYTE PTR [rsp+0x5],0x0
   0x40103b <success+29>:       mov    rdi,rsp
   0x40103e <success+32>:       mov    rsi,0x0
   0x401045 <success+39>:       mov    rax,0x2
   0x40104c <success+46>:       syscall
   0x40104e <success+48>:       mov    rdi,rax
   0x401051 <success+51>:       mov    rsi,rsp
   0x401054 <success+54>:       mov    rdx,0x40
   0x40105b <success+61>:       mov    rax,0x0
   0x401062 <success+68>:       syscall
   0x401064 <success+70>:       mov    rdx,rax
   0x401067 <success+73>:       mov    rdi,0x1
   0x40106e <success+80>:       mov    rax,0x1
   0x401075 <success+87>:       syscall
   0x401077 <success+89>:       mov    rax,0x3c
   0x40107e <success+96>:       syscall
   0x401080 <fail>:     mov    rax,0x3c
   0x401087 <fail+7>:   syscall
   0x401089:    add    BYTE PTR [rax],al
   0x40108b:    add    BYTE PTR [rax],al
   0x40108d:    add    BYTE PTR [rax],al
--Type <RET> for more, q to quit, c to continue without paging--
   0x40108f:    add    BYTE PTR [rax],al
   0x401091:    add    BYTE PTR [rax],al
   0x401093:    add    BYTE PTR [rax],al
   0x401095:    add    BYTE PTR [rax],al
   0x401097:    add    BYTE PTR [rax],al
   0x401099:    add    BYTE PTR [rax],al
(gdb) quit
A debugging session is active.

        Inferior 1 [process 150] will be killed.

Quit anyway? (y or n) y
ubuntu@assembly-assortment~loops-on-data:~$ /challenge/reverse-me dunJZv
pwn.college{IjdsAKe2TcdXDIVWFB2zDVudiKY.01M1czMywyMyITOyEzW}
```
