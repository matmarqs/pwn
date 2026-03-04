# Software Introspection

## Disassembling Programs

```
ubuntu@introspecting~disassembling-programs:~$ objdump -d -M intel /challenge/disassemble-me 

/challenge/disassemble-me:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <__bss_start-0x1000>:
  401000:       48 c7 c7 09 36 00 00    mov    rdi,0x3609
  401007:       48 c7 c7 00 00 00 00    mov    rdi,0x0
  40100e:       48 c7 c0 3c 00 00 00    mov    rax,0x3c
  401015:       0f 05                   syscall
ubuntu@introspecting~disassembling-programs:~$ /challenge/submit-number 0x3609
CORRECT! Here is your flag:
pwn.college{kOUw2Aa0qTgu27N76oLXwgOtyK-.0lMzczMywyMyITOyEzW}
```

## Quitting GDB

```
ubuntu@introspecting~quitting-gdb:~$ gdb /challenge/debug-me 
GNU gdb (Ubuntu 15.0.50.20240403-0ubuntu1) 15.0.50.20240403-git
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.



You successfully started GDB!
Here is the secret number: 9687
Submit that with /challenge/submit-number.

HACKER: Now, quit GDB by typing 'quit' (or just 'q').

(gdb) quit

You quit GDB! Great job.
CORRECT! Here is your flag:
pwn.college{0dQvS4VdraBNPKDMSdbGB_zuxB3.01MzczMywyMyITOyEzW}
```

## Disassembling in GDB

```
ubuntu@introspecting~disassembling-in-gdb:~$ gdb /challenge/debug-me
GNU gdb (Ubuntu 15.0.50.20240403-0ubuntu1) 15.0.50.20240403-git
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.

(gdb) starti


HACKER: You successfully started your program!
HACKER: Now, run the 'disassemble' command to view the assembly code.
HACKER: Read the assembly to find the secret number stored in rdi and
HACKER: submit that with /challenge/submit-number. Good luck!
HACKER: When you're done, quit GDB with 'quit' (or 'q').

0x0000000000401000 in main ()
(gdb) disass
Dump of assembler code for function main:
=> 0x0000000000401000 <+0>:     mov    rdi,0x5b27
   0x0000000000401007 <+7>:     mov    rdi,0x0
   0x000000000040100e <+14>:    mov    rax,0x3c
   0x0000000000401015 <+21>:    syscall
End of assembler dump.
(gdb) quit
ubuntu@introspecting~disassembling-in-gdb:~$ /challenge/submit-number 0x5b27
CORRECT! Here is your flag:
pwn.college{4K01DaxnE0NNjuusJp3jss9D3iw.0FNzczMywyMyITOyEzW}
```

## Stepping Through Instructions

```
ubuntu@introspecting~stepping-through-instructions:~$ gdb /challenge/debug-me 
GNU gdb (Ubuntu 15.0.50.20240403-0ubuntu1) 15.0.50.20240403-git
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.

(gdb) starti

Dump of assembler code for function main:
=> 0x0000000000401000 <+0>:     mov    rdi,CENSORED
   0x0000000000401007 <+7>:     mov    rdi,0x0
   0x000000000040100e <+14>:    mov    rax,0x3c
   0x0000000000401015 <+21>:    syscall
End of assembler dump.

HACKER: The disassembly above shows the program, but the secret value is CENSORED!
HACKER: You can't read it from the code, but you CAN execute the instruction
HACKER: and then read the register. Use 'stepi' (or 'si') to execute one instruction.
0x0000000000401000 in main ()
(gdb) stepi

Dump of assembler code for function main:
   0x0000000000401000 <+0>:     mov    rdi,CENSORED
=> 0x0000000000401007 <+7>:     mov    rdi,0x0
   0x000000000040100e <+14>:    mov    rax,0x3c
   0x0000000000401015 <+21>:    syscall
End of assembler dump.

HACKER: You stepped forward! The 'mov rdi, CENSORED' instruction just executed.
HACKER: I'll now read the rdi register for you:

(gdb) print $rdi
$1 = 19239

HACKER: There's your secret! Submit it with /challenge/submit-number.
HACKER: You can quit GDB with 'quit' (or 'q').
0x0000000000401007 in main ()
(gdb) quit
ubuntu@introspecting~stepping-through-instructions:~$ /challenge/submit-number 19239
CORRECT! Here is your flag:
pwn.college{UAcz37goQApSTtTJWSI4kWsMlXj.0VNzczMywyMyITOyEzW}
```

## Reading Register Values

```
ubuntu@introspecting~reading-register-values:~$ gdb /challenge/debug-me 
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.

(gdb) starti

Dump of assembler code for function main:
=> 0x0000000000401000 <+0>:     mov    rdi,CENSORED
   0x0000000000401007 <+7>:     mov    rdi,0x0
   0x000000000040100e <+14>:    mov    rax,0x3c
   0x0000000000401015 <+21>:    syscall
End of assembler dump.

HACKER: The disassembly is CENSORED! Use 'stepi' to execute the first instruction.
0x0000000000401000 in main ()
(gdb) stepi

Dump of assembler code for function main:
   0x0000000000401000 <+0>:     mov    rdi,CENSORED
=> 0x0000000000401007 <+7>:     mov    rdi,0x0
   0x000000000040100e <+14>:    mov    rax,0x3c
   0x0000000000401015 <+21>:    syscall
End of assembler dump.

HACKER: You just executed 'mov rdi, CENSORED' --- the secret is now in rdi!
HACKER: Use 'print $rdi' to read the register value!
HACKER: When you're done, quit GDB with 'quit' (or 'q').
0x0000000000401007 in main ()
(gdb) print $rdi
$1 = 21540
(gdb) x/gx $rdi
0x5424: Cannot access memory at address 0x5424
(gdb) x/gx rdi
No symbol table is loaded.  Use the "file" command.
(gdb) quit
ubuntu@introspecting~reading-register-values:~$ /challenge/submit-number 0x5424
CORRECT! Here is your flag:
pwn.college{ozpvulS3oXuAkp2PwvEjAXB0yqu.0lNzczMywyMyITOyEzW}
```

## Popping Stack Values

```
ubuntu@introspecting~popping-stack-values:~$ gdb /challenge/debug-me 
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.

(gdb) starti

Dump of assembler code for function main:
=> 0x0000000000401000 <+0>:     pop    rdi
   0x0000000000401001 <+1>:     mov    rdi,0x0
   0x0000000000401008 <+8>:     mov    rax,0x3c
   0x000000000040100f <+15>:    syscall
End of assembler dump.

0x0000000000401000 in main ()
(gdb) stepi

Dump of assembler code for function main:
   0x0000000000401000 <+0>:     pop    rdi
=> 0x0000000000401001 <+1>:     mov    rdi,0x0
   0x0000000000401008 <+8>:     mov    rax,0x3c
   0x000000000040100f <+15>:    syscall
End of assembler dump.

0x0000000000401001 in main ()
(gdb) print $rdi
$1 = 236
(gdb) quit
ubuntu@introspecting~popping-stack-values:~$ /challenge/submit-number 236
CORRECT! Here is your flag:
pwn.college{ITqaVzmqV7uLUS9n2jKORQC183u.01NzczMywyMyITOyEzW}
```

## Examining Memory

```
ubuntu@introspecting~examining-memory:~$ gdb /challenge/debug-me 
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.

(gdb) starti

Dump of assembler code for function main:
=> 0x0000000000401000 <+0>:     mov    rdi,0x0
   0x0000000000401007 <+7>:     mov    rax,0x3c
   0x000000000040100e <+14>:    syscall
End of assembler dump.

0x0000000000401000 in main ()
(gdb) x $rsp
0x7fffffffe560: 0x0000009c
(gdb) x/d $rsp
0x7fffffffe560: 156
(gdb) x/gx $rsp
0x7fffffffe560: 0x000000000000009c
(gdb) quit
ubuntu@introspecting~examining-memory:~$ /challenge/submit-number 156
CORRECT! Here is your flag:
pwn.college{stSQP0RLM9ksfhRRnZWUtLSQOw-.0FOzczMywyMyITOyEzW}
```

## Examining Stack Pointers

```
ubuntu@introspecting~examining-stack-pointers:~$ gdb /challenge/debug-me 
Reading symbols from /challenge/debug-me...
(No debugging symbols found in /challenge/debug-me)
Warning: 'set logging on', an alias for the command 'set logging enabled', is deprecated.
Use 'set logging enabled on'.

(gdb) starti

Dump of assembler code for function main:
=> 0x0000000000401000 <+0>:     mov    rdi,0x0
   0x0000000000401007 <+7>:     mov    rax,0x3c
   0x000000000040100e <+14>:    syscall
End of assembler dump.

0x0000000000401000 in main ()
(gdb) x/a $rsp+16
0x7fffffffeb30: 0x7fffffffed64
(gdb) x/s 0x7fffffffed64
0x7fffffffed64: "pwn.college{MDTDy7567LAlcfDcc2ClBq_xQ6L.0VOzczMywyMyITOyEzW}"
(gdb) quit
```

## Cooperative Debugging

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rdi, 1337
  int3
  mov rax, 60
  mov rdi, 0
  syscall
```

```
ubuntu@introspecting~cooperative-debugging:~$ vim asm.s
ubuntu@introspecting~cooperative-debugging:~$ ./assemble.sh asm.s
ubuntu@introspecting~cooperative-debugging:~$ /challenge/check a.out

Checking that your program uses int3 for cooperative debugging...
... found int3! Your program is ready to cooperate with the debugger.

Running your program under gdb to test cooperative debugging...
... $rdi is 1337 at the int3 trap! Cooperative debugging works!

Here is your flag!
pwn.college{IRnW-THp8ZuM9ML0BjIUfohqyOb.0FM0czMywyMyITOyEzW}
```
