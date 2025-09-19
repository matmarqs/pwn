# Hello Hackers

My `/home/hacker` directory:

```
hacker@hello-hackers~writing-output:~$ pwd
/home/hacker
hacker@hello-hackers~writing-output:~$ ls
Desktop  a.o  a.out  asm.s  assemble.sh  core
hacker@hello-hackers~writing-output:~$ cat assemble.sh
#!/bin/bash

as -o a.o "$1" && ld -o a.out a.o
```

## Writing Output

```
hacker@hello-hackers~writing-output:~$ nvim asm.s
```

```asm
.intel_syntax noprefix
.global _start

_start:
        mov rax, 1
        mov rdi, 1
        mov rsi, 1337000
        mov rdx, 1
        syscall
```

```
hacker@hello-hackers~writing-output:~$ /challenge/check asm.s

Checking the assembly code...
... YES! Great job!

Let's check what your exit code is! It should be our secret value
stored at memory address 1337000 (the letter H) to succeed!

hacker@hello-hackers~writing-output:/home/hacker$ /tmp/your-program
HSegmentation fault (core dumped)
hacker@hello-hackers~writing-output:/home/hacker$


Wow, you wrote an "H"!!!!!!! But why did your program crash? Well, you didn't
exit, and as before, the CPU kept executing and eventually crashed. In the next
level, we will learn how to chain two system calls togeter: write and exit!


Here is your flag!
pwn.college{EFnVo3IRjpQ7Wnont9-q0eklYEY.QXwUTN2wyMyITOyEzW}
```

## Chaining Syscalls

```
hacker@hello-hackers~chaining-syscalls:~$ nvim asm.s
```

```asm
.intel_syntax noprefix
.global _start

_start:
        mov rax, 1
        mov rdi, 1
        mov rsi, 1337000
        mov rdx, 1
        syscall
        mov rax, 60
        mov rdi, 42
        syscall
```


```
hacker@hello-hackers~chaining-syscalls:~$ /challenge/check asm.s

Checking the assembly code...
... YES! Great job!

Let's check what your exit code is! It should be our secret value
stored at memory address 1337000 (the letter H) to succeed!

hacker@hello-hackers~chaining-syscalls:/home/hacker$ /tmp/your-program
Hhacker@hello-hackers~chaining-syscalls:/home/hacker$

YES! You wrote an 'H' and cleanly exited! Great job!

Here is your flag!
pwn.college{YBR-W94LiMzgjdA82MOJO1a1aMy.QXxUTN2wyMyITOyEzW}
```

## Writing Strings

```
hacker@hello-hackers~writing-strings:~$ nvim asm.s
```

```asm
.intel_syntax noprefix
.global _start

_start:
        mov rax, 1
        mov rdi, 1
        mov rsi, 1337000
        mov rdx, 14
        syscall
        mov rax, 60
        mov rdi, 42
        syscall
```


```
hacker@hello-hackers~writing-strings:~$ /challenge/check asm.s

Checking the assembly code...
... YES! Great job!

Let's check what your exit code is! It should be our secret value
stored at memory address 1337000 (the string "Hello Hackers!" ) to succeed!

hacker@hello-hackers~writing-strings:/home/hacker$ /tmp/your-program
Hello Hackers!hacker@hello-hackers~writing-strings:/home/hacker$

YES! You wrote a "Hello Hackers" and cleanly exited! Great job!

Here is your flag!
pwn.college{gL8WYHiP7QZf96GSjRFlZ4Whml-.01NzEDMxwyMyITOyEzW}
```


## Reading Data

```
hacker@hello-hackers~reading-data:~$ nvim asm.s
```

```
.intel_syntax noprefix
.global _start

_start:
        mov rax, 0
        mov rdi, 0
        mov rsi, 1337000
        mov rdx, 8
        syscall
        mov rax, 1
        mov rdi, 1
        mov rsi, 1337000
        mov rdx, 8
        syscall
        mov rax, 60
        mov rdi, 42
        syscall
```

```
hacker@hello-hackers~reading-data:~$ /challenge/check asm.s

Checking the assembly code...
... YES! Great job!

Let's check what your output is! It should be our secret value, b'xRYBPMXv',
as passed into the stdin of your program!

hacker@hello-hackers~reading-data:/home/hacker$ /tmp/your-program
xRYBPMXv
hacker@hello-hackers~reading-data:/home/hacker$

YES! You wrote the data and cleanly exited! Great job!

Here is your flag!
pwn.college{M4dYJEsqEJtfr__amiBYI3ZEqPe.0FNwUTNxwyMyITOyEzW}
```
