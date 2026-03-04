# The Stack

## The Stack

```bash
cat assemble.sh
#!/bin/bash

as -o a.o "$1" && ld -o a.out a.o
```

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, 60
  mov rdi, [rsp]
  syscall
```

```bash
./assemble.sh asm.s
/challenge/check a.out
```

## Stack Offsets

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, 60
  mov rdi, [rsp+128]
  syscall
```

## Program Arguments on the Stack

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, 60
  mov rdi, [rsp+16]
  mov rdi, [rdi]
  syscall
```

## Popping From the Stack

```asm
# asm.s
.intel_syntax noprefix
.global _start

_start:
  mov rax, 60
  pop rdi
  syscall
```
