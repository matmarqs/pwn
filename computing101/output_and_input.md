# Output and Input

## Opening Files

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  xor rsi, rsi  # rsi = 0, read-only
  mov rdi, [rsp+16] # argv[1] = "/flag"
  mov rax, 2    # rax = 2, open(argv[1], 0)
  syscall
  sub rsp, 64   # allocate 64 bytes, char buffer[64]
  mov rdx, 64
  mov rsi, rsp  # char buffer
  mov rdi, rax  # returned fd from open
  mov rax, 0    # rax = 0, read(fd, buffer, 64)
  syscall
  mov rdi, 1  # rdi = 1, stdout
  mov rax, 1  # rsi = rsp is still the char buffer, rdx is still 64, write(stdout, buffer, 64)
  syscall
  add rsp, 64 # free the 64 bytes
  mov rax, 60
  mov rdi, 42
  syscall
```

```
ubuntu@hello-hackers~opening-files:~$ ./assemble.sh asm.s && /challenge/check a.out

Checking the assembly code...
Your assembly looks correct!

Let's run your program and see if it can read the flag!

hacker@hello-hackers~opening-files:/home/hacker$ a.out /flag
pwn.college{AtO5pn19I7XGiE5W9Y4aHskTSg6.0VM0czMywyMyITOyEzW}
hacker@hello-hackers~opening-files:/home/hacker$ echo $?
42
hacker@hello-hackers~opening-files:/home/hacker$ 

Your program opened, read, and wrote the flag!
```

## Hardcoding the Filename

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  sub rsp, 6  # allocate 6 bytes for "/flag\0"
  mov BYTE PTR [rsp], '/'
  mov BYTE PTR [rsp+1], 'f'
  mov BYTE PTR [rsp+2], 'l'
  mov BYTE PTR [rsp+3], 'a'
  mov BYTE PTR [rsp+4], 'g'
  mov BYTE PTR [rsp+5], 0
  xor rsi, rsi  # rsi = 0, read-only
  mov rdi, rsp  # rsp = pointer to "/flag"
  mov rax, 2    # rax = 2, open(argv[1], 0)
  syscall
  sub rsp, 64   # allocate 64 bytes, char buffer[64]
  mov rdx, 64
  mov rsi, rsp  # char buffer
  mov rdi, rax  # returned fd from open
  mov rax, 0    # rax = 0, read(fd, buffer, 64)
  syscall
  mov rdi, 1  # rdi = 1, stdout
  mov rax, 1  # rsi = rsp is still the char buffer, rdx is still 64, write(stdout, buffer, 64)
  syscall
  add rsp, 70 # free the 64 + 6 bytes
  mov rax, 60
  mov rdi, 42
  syscall
```

```
ubuntu@hello-hackers~hardcoding-the-filename:~$ /challenge/check a.out

Checking the assembly code...
Your assembly looks correct!

Let's run your program and see if it can read the flag!

hacker@hello-hackers~hardcoding-the-filename:/home/hacker$ a.out
pwn.college{IUdBc-6sl8X6sZWEWhiSI8BfQhb.0lM0czMywyMyITOyEzW}
   hacker@hello-hackers~hardcoding-the-filename:/home/hacker$ echo $?
42
hacker@hello-hackers~hardcoding-the-filename:/home/hacker$ 

Your program opened, read, and wrote the flag!
```
