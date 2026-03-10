# Reverse Engineering

## File Formats: Magic Numbers (Python)

```
hacker@reverse-engineering~file-formats-magic-numbers-python:~$ file /challenge/cimg
/challenge/cimg: setuid Python script, ASCII text executable
hacker@reverse-engineering~file-formats-magic-numbers-python:~$ less /challenge/cimg
hacker@reverse-engineering~file-formats-magic-numbers-python:~$ cat /challenge/cimg
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(4)
    assert len(header) == 4, "ERROR: Failed to read header!"

    assert header[:4] == b"[%Mg", "ERROR: Invalid magic number!"

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
hacker@reverse-engineering~file-formats-magic-numbers-python:~$ echo -n '[%Mg' > "cimg_level1.cimg"
hacker@reverse-engineering~file-formats-magic-numbers-python:~$ /challenge/cimg cimg_level1.cimg 
pwn.college{kKqES-JSd8YIjc_hZwG5LNARx8n.0VNwUjNxwyMyITOyEzW}

hacker@reverse-engineering~file-formats-magic-numbers-python:~$ /challenge/cimg < cimg_level1.cimg 
pwn.college{kKqES-JSd8YIjc_hZwG5LNARx8n.0VNwUjNxwyMyITOyEzW}
```

## File Formats: Magic Numbers (C)

Using `radare2`, it becomes obvious the magic number are the characters `{NmG`

```
[0x00401230]> afl
0x00401130    1     11 sym.imp.__errno_location
0x00401140    1     11 sym.imp.puts
0x00401150    1     11 sym.imp.write
0x00401160    1     11 sym.imp.strlen
0x00401170    1     11 sym.imp.__stack_chk_fail
0x00401180    1     11 sym.imp.dup2
0x00401190    1     11 sym.imp.printf
0x004011a0    1     11 sym.imp.geteuid
0x004011b0    1     11 sym.imp.fputc
0x004011c0    1     11 sym.imp.read
0x004011d0    1     11 sym.imp.strcmp
0x004011e0    1     11 sym.imp.fprintf
0x004011f0    1     11 sym.imp.setvbuf
0x00401200    1     11 sym.imp.open
0x00401210    1     11 sym.imp.exit
0x00401220    1     11 sym.imp.strerror
0x00401230    1     46 entry0
0x00401270    4     31 sym.deregister_tm_clones
0x004012a0    4     49 sym.register_tm_clones
0x004012e0    3     32 entry.fini0
0x00401310    1      6 entry.init0
0x004016b0    1      5 sym.__libc_csu_fini
0x004016b8    1     13 sym._fini
0x00401640    4    101 sym.__libc_csu_init
0x00401316    9    295 sym.win
0x00401260    1      5 sym._dl_relocate_static_pie
0x00401500   14    320 main
0x0040143d    3    124 sym.read_exact
0x004014b9    1     71 entry.init1
0x00401000    3     27 sym._init
0x00401030    2     28 fcn.00401030
0x00401040    1     15 fcn.00401040
0x00401050    1     15 fcn.00401050
0x00401060    1     15 fcn.00401060
0x00401070    1     15 fcn.00401070
0x00401080    1     15 fcn.00401080
0x00401090    1     15 fcn.00401090
0x004010a0    1     15 fcn.004010a0
0x004010b0    1     15 fcn.004010b0
0x004010c0    1     15 fcn.004010c0
0x004010d0    1     15 fcn.004010d0
0x004010e0    1     15 fcn.004010e0
0x004010f0    1     15 fcn.004010f0
0x00401100    1     15 fcn.00401100
0x00401110    1     15 fcn.00401110
0x00401120    1     15 fcn.00401120
[0x00401230]> s main
[0x00401500]> pdf
            ; ICOD XREF from entry0 @ 0x401251(r)
┌ 320: int main (signed int64_t argc, char **argv, char **envp);
│ `- args(rdi, rsi, rdx) vars(9:sp[0x20..0x40])
│           0x00401500      f30f1efa       endbr64
│           0x00401504      55             push rbp
│           0x00401505      4889e5         mov rbp, rsp
│           0x00401508      53             push rbx
│           0x00401509      4883ec38       sub rsp, 0x38
│           0x0040150d      897ddc         mov dword [var_24h], edi    ; argc
│           0x00401510      488975d0       mov qword [path], rsi       ; argv
│           0x00401514      488955c8       mov qword [var_38h], rdx    ; envp
│           0x00401518      64488b0425..   mov rax, qword fs:[0x28]
│           0x00401521      488945e8       mov qword [canary], rax
│           0x00401525      31c0           xor eax, eax
│           0x00401527      c745e40000..   mov dword [var_1ch], 0
│           0x0040152e      c745e00100..   mov dword [var_20h], 1
│           0x00401535      837ddc01       cmp dword [var_24h], 1
│       ┌─< 0x00401539      7e7c           jle 0x4015b7
│       │   0x0040153b      488b45d0       mov rax, qword [path]
│       │   0x0040153f      4883c008       add rax, 8
│       │   0x00401543      488b18         mov rbx, qword [rax]
│       │   0x00401546      488b45d0       mov rax, qword [path]
│       │   0x0040154a      4883c008       add rax, 8
│       │   0x0040154e      488b00         mov rax, qword [rax]
│       │   0x00401551      4889c7         mov rdi, rax                ; const char *s
│       │   0x00401554      e807fcffff     call sym.imp.strlen         ; size_t strlen(const char *s)
│       │   0x00401559      4883e805       sub rax, 5
│       │   0x0040155d      4801d8         add rax, rbx
│       │   0x00401560      488d35850b..   lea rsi, str..cimg          ; 0x4020ec ; ".cimg" ; const char *s2
│       │   0x00401567      4889c7         mov rdi, rax                ; const char *s1
│       │   0x0040156a      e861fcffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)
│       │   0x0040156f      85c0           test eax, eax
│      ┌──< 0x00401571      741b           je 0x40158e
│      ││   0x00401573      488d3d7e0b..   lea rdi, str.ERROR:_Invalid_file_extension_ ; 0x4020f8 ; "ERROR: Invalid file extension!" ; const char *format
│      ││   0x0040157a      b800000000     mov eax, 0
│      ││   0x0040157f      e80cfcffff     call sym.imp.printf         ; int printf(const char *format)
│      ││   0x00401584      bfffffffff     mov edi, 0xffffffff         ; -1 ; int status
│      ││   0x00401589      e882fcffff     call sym.imp.exit           ; void exit(int status)
│      ││   ; CODE XREF from main @ 0x401571(x)
│      └──> 0x0040158e      488b45d0       mov rax, qword [path]
│       │   0x00401592      4883c008       add rax, 8
│       │   0x00401596      488b00         mov rax, qword [rax]
│       │   0x00401599      be00000000     mov esi, 0                  ; int oflag
│       │   0x0040159e      4889c7         mov rdi, rax                ; const char *path
│       │   0x004015a1      b800000000     mov eax, 0
│       │   0x004015a6      e855fcffff     call sym.imp.open           ; int open(const char *path, int oflag)
│       │   0x004015ab      be00000000     mov esi, 0
│       │   0x004015b0      89c7           mov edi, eax
│       │   0x004015b2      e8c9fbffff     call sym.imp.dup2
│       │   ; CODE XREF from main @ 0x401539(x)
│       └─> 0x004015b7      488d45e4       lea rax, [var_1ch]
│           0x004015bb      41b8ffffffff   mov r8d, 0xffffffff         ; -1 ; int64_t arg5
│           0x004015c1      488d0d4f0b..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x402117 ; "ERROR: Failed to read header!" ; char *arg4
│           0x004015c8      ba04000000     mov edx, 4                  ; uint32_t arg3
│           0x004015cd      4889c6         mov rsi, rax                ; void *arg2
│           0x004015d0      bf00000000     mov edi, 0                  ; int64_t arg1
│           0x004015d5      e863feffff     call sym.read_exact
│           0x004015da      0fb645e4       movzx eax, byte [var_1ch]
│           0x004015de      3c7b           cmp al, 0x7b                ; '{' ; 123
│       ┌─< 0x004015e0      7518           jne 0x4015fa
│       │   0x004015e2      0fb645e5       movzx eax, byte [var_1bh]
│       │   0x004015e6      3c4e           cmp al, 0x4e                ; 'N' ; 78
│      ┌──< 0x004015e8      7510           jne 0x4015fa
│      ││   0x004015ea      0fb645e6       movzx eax, byte [var_1ah]
│      ││   0x004015ee      3c6d           cmp al, 0x6d                ; 'm' ; 109
│     ┌───< 0x004015f0      7508           jne 0x4015fa
│     │││   0x004015f2      0fb645e7       movzx eax, byte [var_19h]
│     │││   0x004015f6      3c47           cmp al, 0x47                ; 'G' ; 71
│    ┌────< 0x004015f8      7416           je 0x401610
│    ││││   ; CODE XREFS from main @ 0x4015e0(x), 0x4015e8(x), 0x4015f0(x)
│    │└└└─> 0x004015fa      488d3d340b..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402135 ; "ERROR: Invalid magic number!" ; const char *s
│    │      0x00401601      e83afbffff     call sym.imp.puts           ; int puts(const char *s)
│    │      0x00401606      bfffffffff     mov edi, 0xffffffff         ; -1 ; int status
│    │      0x0040160b      e800fcffff     call sym.imp.exit           ; void exit(int status)
│    │      ; CODE XREF from main @ 0x4015f8(x)
│    └────> 0x00401610      837de000       cmp dword [var_20h], 0
│       ┌─< 0x00401614      740a           je 0x401620
│       │   0x00401616      b800000000     mov eax, 0
│       │   0x0040161b      e8f6fcffff     call sym.win
│       │   ; CODE XREF from main @ 0x401614(x)
│       └─> 0x00401620      b800000000     mov eax, 0
│           0x00401625      488b4de8       mov rcx, qword [canary]
│           0x00401629      6448330c25..   xor rcx, qword fs:[0x28]
│       ┌─< 0x00401632      7405           je 0x401639
│       │   0x00401634      e837fbffff     call sym.imp.__stack_chk_fail ; void __stack_chk_fail(void)
│       │   ; CODE XREF from main @ 0x401632(x)
│       └─> 0x00401639      4883c438       add rsp, 0x38
│           0x0040163d      5b             pop rbx
│           0x0040163e      5d             pop rbp
└           0x0040163f      c3             ret
hacker@reverse-engineering~file-formats-magic-numbers-c:~$ echo -n '{NmG' | /challenge/cimg
pwn.college{k-Dx7WPorwiVa6fzs0t1Gm0b_UJ.0lNwUjNxwyMyITOyEzW}
```

## File Formats: Magic Numbers (x86)

Unfortunately, the file `/challenge/cimg` is the same as the previous problem (it has the SAME HASH)!

```
hacker@reverse-engineering~file-formats-magic-numbers-x86:~$ echo  -n '{NmG' | /challenge/cimg 
pwn.college{kWrsLJdKCA-uw7tLMXC57SOSQrq.0FMwMDMxwyMyITOyEzW}
```

## Reading Endianness (Python)

```
hacker@reverse-engineering~reading-endianness-python:~$ file /challenge/cimg 
/challenge/cimg: setuid Python script, ASCII text executable
hacker@reverse-engineering~reading-endianness-python:~$ cat /challenge/cimg 
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(4)
    assert len(header) == 4, "ERROR: Failed to read header!"

    assert int.from_bytes(header[:4], "little") == 0x366D3A7B, "ERROR: Invalid magic number!"

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
hacker@reverse-engineering~reading-endianness-python:~$ echo -ne '\x7b\x3a\x6d\x36' | /challenge/cimg 
pwn.college{ciV-UoB-pDalUVYiuT_PUw4je4q.01NwUjNxwyMyITOyEzW}
```

## Reading Endianness (C)

```
[0x00401320]> s main
[0x00401244]> pdf
            ; ICOD XREF from entry0 @ 0x401341(r)
┌ 210: int main (int argc, char **s1, int64_t arg4, int64_t arg5);
│ `- args(rdi, rsi, rcx, r8) vars(2:sp[0x10..0x14])
│           0x00401244      f30f1efa       endbr64
│           0x00401248      55             push rbp
│           0x00401249      4883ec10       sub rsp, 0x10
│           0x0040124d      64488b0425..   mov rax, qword fs:[0x28]
│           0x00401256      4889442408     mov qword [canary], rax
│           0x0040125b      31c0           xor eax, eax
│           0x0040125d      ffcf           dec edi                     ; argc
│           0x0040125f      c744240400..   mov dword [var_4h], 0
│       ┌─< 0x00401267      7e4f           jle 0x4012b8
│       │   0x00401269      488b6e08       mov rbp, qword [rsi + 8]    ; argv
│       │   0x0040126d      4883c9ff       or rcx, 0xffffffffffffffff  ; arg4
│       │   0x00401271      488d355b0e..   lea rsi, str..cimg          ; 0x4020d3 ; ".cimg" ; const char *s2
│       │   0x00401278      4889ef         mov rdi, rbp
│       │   0x0040127b      f2ae           repne scasb al, byte [rdi]
│       │   0x0040127d      48f7d1         not rcx                     ; arg4
│       │   0x00401280      488d7c0dfa     lea rdi, [rbp + rcx - 6]    ; const char *s1
│       │   0x00401285      e816ffffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)
│       │   0x0040128a      85c0           test eax, eax
│      ┌──< 0x0040128c      7415           je 0x4012a3
│      ││   0x0040128e      488d35440e..   lea rsi, str.ERROR:_Invalid_file_extension_ ; 0x4020d9 ; "ERROR: Invalid file extension!"
│      ││   0x00401295      bf01000000     mov edi, 1
│      ││   0x0040129a      31c0           xor eax, eax
│      ││   0x0040129c      e80fffffff     call sym.imp.__printf_chk
│     ┌───< 0x004012a1      eb47           jmp 0x4012ea
│     │││   ; CODE XREF from main @ 0x40128c(x)
│     │└──> 0x004012a3      31f6           xor esi, esi                ; int oflag
│     │ │   0x004012a5      4889ef         mov rdi, rbp                ; const char *path
│     │ │   0x004012a8      31c0           xor eax, eax
│     │ │   0x004012aa      e821ffffff     call sym.imp.open           ; int open(const char *path, int oflag)
│     │ │   0x004012af      31f6           xor esi, esi
│     │ │   0x004012b1      89c7           mov edi, eax
│     │ │   0x004012b3      e8a8feffff     call sym.imp.dup2
│     │ │   ; CODE XREF from main @ 0x401267(x)
│     │ └─> 0x004012b8      4183c8ff       or r8d, 0xffffffff          ; -1 ; arg5
│     │     0x004012bc      31ff           xor edi, edi                ; int fildes
│     │     0x004012be      488d742404     lea rsi, [var_4h]           ; void *buf
│     │     0x004012c3      ba04000000     mov edx, 4                  ; size_t nbyte
│     │     0x004012c8      488d0d290e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012cf      e827020000     call sym.read_exact
│     │     0x004012d4      817c24047b..   cmp dword [var_4h], 0x476d4e7b ; '{NmG'
│     │ ┌─< 0x004012dc      7414           je 0x4012f2
│     │ │   0x004012de      488d3d310e..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!" ; const char *s
│     │ │   0x004012e5      e846feffff     call sym.imp.puts           ; int puts(const char *s)
│     │ │   ; CODE XREF from main @ 0x4012a1(x)
│     └───> 0x004012ea      83cfff         or edi, 0xffffffff          ; -1
│       │   0x004012ed      e8eefeffff     call sym.imp.exit           ; void exit(int status)
│       │   ; CODE XREF from main @ 0x4012dc(x)
│       └─> 0x004012f2      31c0           xor eax, eax
│           0x004012f4      e80d010000     call sym.win
│           0x004012f9      488b442408     mov rax, qword [canary]
│           0x004012fe      6448330425..   xor rax, qword fs:[0x28]
│       ┌─< 0x00401307      7405           je 0x40130e
│       │   0x00401309      e842feffff     call sym.imp.__stack_chk_fail ; void __stack_chk_fail(void)
│       │   ; CODE XREF from main @ 0x401307(x)
│       └─> 0x0040130e      4883c410       add rsp, 0x10
│           0x00401312      31c0           xor eax, eax
│           0x00401314      5d             pop rbp
└           0x00401315      c3             ret
hacker@reverse-engineering~reading-endianness-c:~$ echo -ne '\x7b\x4e\x6d\x47' | /challenge/cimg
pwn.college{Y_cX_buJ-UGTcVjtIrh9vMbcCYT.0FOwUjNxwyMyITOyEzW}
```

## Reading Endianness (x86)

```
[0x00401320]> s main
[0x00401244]> pdf
            ; ICOD XREF from entry0 @ 0x401341(r)
┌ 210: int main (int argc, char **s1, int64_t arg4, int64_t arg5);
│ `- args(rdi, rsi, rcx, r8) vars(2:sp[0x10..0x14])
│           0x00401244      f30f1efa       endbr64
│           0x00401248      55             push rbp
│           0x00401249      4883ec10       sub rsp, 0x10
│           0x0040124d      64488b0425..   mov rax, qword fs:[0x28]
│           0x00401256      4889442408     mov qword [canary], rax
│           0x0040125b      31c0           xor eax, eax
│           0x0040125d      ffcf           dec edi                     ; argc
│           0x0040125f      c744240400..   mov dword [var_4h], 0
│       ┌─< 0x00401267      7e4f           jle 0x4012b8
│       │   0x00401269      488b6e08       mov rbp, qword [rsi + 8]    ; argv
│       │   0x0040126d      4883c9ff       or rcx, 0xffffffffffffffff  ; arg4
│       │   0x00401271      488d355b0e..   lea rsi, str..cimg          ; 0x4020d3 ; ".cimg" ; const char *s2
│       │   0x00401278      4889ef         mov rdi, rbp
│       │   0x0040127b      f2ae           repne scasb al, byte [rdi]
│       │   0x0040127d      48f7d1         not rcx                     ; arg4
│       │   0x00401280      488d7c0dfa     lea rdi, [rbp + rcx - 6]    ; const char *s1
│       │   0x00401285      e816ffffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)
│       │   0x0040128a      85c0           test eax, eax
│      ┌──< 0x0040128c      7415           je 0x4012a3
│      ││   0x0040128e      488d35440e..   lea rsi, str.ERROR:_Invalid_file_extension_ ; 0x4020d9 ; "ERROR: Invalid file extension!"
│      ││   0x00401295      bf01000000     mov edi, 1
│      ││   0x0040129a      31c0           xor eax, eax
│      ││   0x0040129c      e80fffffff     call sym.imp.__printf_chk
│     ┌───< 0x004012a1      eb47           jmp 0x4012ea
│     │││   ; CODE XREF from main @ 0x40128c(x)
│     │└──> 0x004012a3      31f6           xor esi, esi                ; int oflag
│     │ │   0x004012a5      4889ef         mov rdi, rbp                ; const char *path
│     │ │   0x004012a8      31c0           xor eax, eax
│     │ │   0x004012aa      e821ffffff     call sym.imp.open           ; int open(const char *path, int oflag)
│     │ │   0x004012af      31f6           xor esi, esi
│     │ │   0x004012b1      89c7           mov edi, eax
│     │ │   0x004012b3      e8a8feffff     call sym.imp.dup2
│     │ │   ; CODE XREF from main @ 0x401267(x)
│     │ └─> 0x004012b8      4183c8ff       or r8d, 0xffffffff          ; -1 ; arg5
│     │     0x004012bc      31ff           xor edi, edi                ; int fildes
│     │     0x004012be      488d742404     lea rsi, [var_4h]           ; void *buf
│     │     0x004012c3      ba04000000     mov edx, 4                  ; size_t nbyte
│     │     0x004012c8      488d0d290e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012cf      e827020000     call sym.read_exact
│     │     0x004012d4      817c24047b..   cmp dword [var_4h], 0x726e4f7b ; '{Onr'
│     │ ┌─< 0x004012dc      7414           je 0x4012f2
│     │ │   0x004012de      488d3d310e..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!" ; const char *s
│     │ │   0x004012e5      e846feffff     call sym.imp.puts           ; int puts(const char *s)
│     │ │   ; CODE XREF from main @ 0x4012a1(x)
│     └───> 0x004012ea      83cfff         or edi, 0xffffffff          ; -1
│       │   0x004012ed      e8eefeffff     call sym.imp.exit           ; void exit(int status)
│       │   ; CODE XREF from main @ 0x4012dc(x)
│       └─> 0x004012f2      31c0           xor eax, eax
│           0x004012f4      e80d010000     call sym.win
│           0x004012f9      488b442408     mov rax, qword [canary]
│           0x004012fe      6448330425..   xor rax, qword fs:[0x28]
│       ┌─< 0x00401307      7405           je 0x40130e
│       │   0x00401309      e842feffff     call sym.imp.__stack_chk_fail ; void __stack_chk_fail(void)
│       │   ; CODE XREF from main @ 0x401307(x)
│       └─> 0x0040130e      4883c410       add rsp, 0x10
│           0x00401312      31c0           xor eax, eax
│           0x00401314      5d             pop rbp
└           0x00401315      c3             ret
[0x00401244]>
hacker@reverse-engineering~reading-endianness-x86:~$ echo -n '{Onr' | /challenge/cimg 
pwn.college{sGY3qCBR2rdpoMzsVD4Qr874PiB.0VMwMDMxwyMyITOyEzW}
```

## Version Information (Python)

```
hacker@reverse-engineering~version-information-python:~$ file /challenge/cimg 
/challenge/cimg: setuid Python script, ASCII text executable
hacker@reverse-engineering~version-information-python:~$ cat /challenge/cimg 
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(6)
    assert len(header) == 6, "ERROR: Failed to read header!"

    assert header[:4] == b"<0%r", "ERROR: Invalid magic number!"

    assert int.from_bytes(header[4:6], "little") == 125, "ERROR: Invalid version!"

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
```

```
hacker@reverse-engineering~version-information-python:~$ vim make_byte_file.py
hacker@reverse-engineering~version-information-python:~$ python3 make_byte_file.py 
hacker@reverse-engineering~version-information-python:~$ xxd byte_file.bin 
00000000: 3c30 2572 7d00                           <0%r}.
hacker@reverse-engineering~version-information-python:~$ cat make_byte_file.py 
import struct

with open("byte_file.bin", "wb") as f:
        f.write(b"<0%r")
        f.write(struct.pack('<h', 125))
hacker@reverse-engineering~version-information-python:~$ /challenge/cimg byte_file.bin 
ERROR: file has incorrect extension
hacker@reverse-engineering~version-information-python:~$ mv byte_file.bin byte_file.cimg
hacker@reverse-engineering~version-information-python:~$ /challenge/cimg byte_file.cimg 
pwn.college{0PUF2VbHlpJPoKoyWKq2HZeHBQD.0VOwUjNxwyMyITOyEzW}
```

## Version Information (C)

```
[0x00401244]> pdf
            ; ICOD XREF from entry0 @ 0x401361(r)
┌ 250: int main (int argc, char **s1);
│ `- args(rdi, rsi) vars(6:sp[0x10..0x15])
│           0x00401244      f30f1efa       endbr64
│           0x00401248      55             push rbp
│           0x00401249      4189f8         mov r8d, edi                ; argc
│           0x0040124c      b905000000     mov ecx, 5
│           0x00401251      4883ec10       sub rsp, 0x10
│           0x00401255      64488b0425..   mov rax, qword fs:[0x28]
│           0x0040125e      4889442408     mov qword [canary], rax
│           0x00401263      31c0           xor eax, eax
│           0x00401265      488d7c2403     lea rdi, [var_3h]
│           0x0040126a      41ffc8         dec r8d
│           0x0040126d      f3aa           rep stosb byte [rdi], al
│       ┌─< 0x0040126f      7e4f           jle 0x4012c0
│       │   0x00401271      488b6e08       mov rbp, qword [rsi + 8]    ; argv
│       │   0x00401275      4883c9ff       or rcx, 0xffffffffffffffff
│       │   0x00401279      488d35530e..   lea rsi, str..cimg          ; 0x4020d3 ; ".cimg" ; const char *s2
│       │   0x00401280      4889ef         mov rdi, rbp
│       │   0x00401283      f2ae           repne scasb al, byte [rdi]
│       │   0x00401285      48f7d1         not rcx
│       │   0x00401288      488d7c0dfa     lea rdi, [rbp + rcx - 6]    ; const char *s1
│       │   0x0040128d      e80effffff     call sym.imp.strcmp         ; int strcmp(const char *s1, const char *s2)
│       │   0x00401292      85c0           test eax, eax
│      ┌──< 0x00401294      7415           je 0x4012ab
│      ││   0x00401296      488d353c0e..   lea rsi, str.ERROR:_Invalid_file_extension_ ; 0x4020d9 ; "ERROR: Invalid file extension!"
│      ││   0x0040129d      bf01000000     mov edi, 1
│      ││   0x004012a2      31c0           xor eax, eax
│      ││   0x004012a4      e807ffffff     call sym.imp.__printf_chk
│     ┌───< 0x004012a9      eb59           jmp 0x401304
│     │││   ; CODE XREF from main @ 0x401294(x)
│     │└──> 0x004012ab      31f6           xor esi, esi                ; int oflag
│     │ │   0x004012ad      4889ef         mov rdi, rbp                ; const char *path
│     │ │   0x004012b0      31c0           xor eax, eax
│     │ │   0x004012b2      e819ffffff     call sym.imp.open           ; int open(const char *path, int oflag)
│     │ │   0x004012b7      31f6           xor esi, esi
│     │ │   0x004012b9      89c7           mov edi, eax
│     │ │   0x004012bb      e8a0feffff     call sym.imp.dup2
│     │ │   ; CODE XREF from main @ 0x40126f(x)
│     │ └─> 0x004012c0      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x004012c4      31ff           xor edi, edi                ; int fildes
│     │     0x004012c6      488d742403     lea rsi, [var_3h]           ; void *buf
│     │     0x004012cb      ba05000000     mov edx, 5                  ; size_t nbyte
│     │     0x004012d0      488d0d210e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012d7      e83f020000     call sym.read_exact
│     │     0x004012dc      807c240363     cmp byte [var_3h], 0x63     ; 'c'
│     │ ┌─< 0x004012e1      7515           jne 0x4012f8
│     │ │   0x004012e3      807c24046e     cmp byte [var_4h], 0x6e     ; 'n'
│     │┌──< 0x004012e8      750e           jne 0x4012f8
│     │││   0x004012ea      807c24056d     cmp byte [var_5h], 0x6d     ; 'm'
│    ┌────< 0x004012ef      7507           jne 0x4012f8
│    ││││   0x004012f1      807c240667     cmp byte [var_6h], 0x67     ; 'g'
│   ┌─────< 0x004012f6      7414           je 0x40130c
│   │││││   ; CODE XREFS from main @ 0x4012e1(x), 0x4012e8(x), 0x4012ef(x)
│   │└─└└─> 0x004012f8      488d3d170e..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREF from main @ 0x401318(x)
│   │ │ ┌─> 0x004012ff      e82cfeffff     call sym.imp.puts           ; int puts(const char *s)
│   │ │ ╎   ; CODE XREF from main @ 0x4012a9(x)
│   │ └───> 0x00401304      83cfff         or edi, 0xffffffff          ; -1
│   │   ╎   0x00401307      e8d4feffff     call sym.imp.exit           ; void exit(int status)
│   │   ╎   ; CODE XREF from main @ 0x4012f6(x)
│   └─────> 0x0040130c      807c240756     cmp byte [var_7h], 0x56     ; 'V'
│       ╎   0x00401311      488d3d1b0e..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│       └─< 0x00401318      75e5           jne 0x4012ff
│           0x0040131a      31c0           xor eax, eax
│           0x0040131c      e805010000     call sym.win
│           0x00401321      488b442408     mov rax, qword [canary]
│           0x00401326      6448330425..   xor rax, qword fs:[0x28]
│       ┌─< 0x0040132f      7405           je 0x401336
│       │   0x00401331      e81afeffff     call sym.imp.__stack_chk_fail ; void __stack_chk_fail(void)
│       │   ; CODE XREF from main @ 0x40132f(x)
│       └─> 0x00401336      4883c410       add rsp, 0x10
│           0x0040133a      31c0           xor eax, eax
│           0x0040133c      5d             pop rbp
└           0x0040133d      c3             ret
```

Basically, it reads `5` bytes from the file. They must be `cnmgV`

```
hacker@reverse-engineering~version-information-c:~$ echo -n 'cnmgV' | /challenge/cimg
pwn.college{4BDOgEHqP2OrQy8VfVAmfDqLhxm.0FMxUjNxwyMyITOyEzW}
```

## Version Information (x86)

```
│     │ └─> 0x004012c0      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x004012c4      31ff           xor edi, edi                ; int fildes
│     │     0x004012c6      488d742402     lea rsi, [var_2h]           ; void *buf
│     │     0x004012cb      ba06000000     mov edx, 6                  ; size_t nbyte
│     │     0x004012d0      488d0d210e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012d7      e83f020000     call sym.read_exact
│     │     0x004012dc      807c24025b     cmp byte [var_2h], 0x5b     ; '['
│     │ ┌─< 0x004012e1      7515           jne 0x4012f8
│     │ │   0x004012e3      807c24036e     cmp byte [var_3h], 0x6e     ; 'n'
│     │┌──< 0x004012e8      750e           jne 0x4012f8
│     │││   0x004012ea      807c24046e     cmp byte [var_4h], 0x6e     ; 'n'
│    ┌────< 0x004012ef      7507           jne 0x4012f8
│    ││││   0x004012f1      807c240552     cmp byte [var_5h], 0x52     ; 'R'
│   ┌─────< 0x004012f6      7414           je 0x40130c
│   │││││   ; CODE XREFS from main @ 0x4012e1(x), 0x4012e8(x), 0x4012ef(x)
│   │└─└└─> 0x004012f8      488d3d170e..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREF from main @ 0x40131a(x)
│   │ │ ┌─> 0x004012ff      e82cfeffff     call sym.imp.puts           ; int puts(const char *s)
│   │ │ ╎   ; CODE XREF from main @ 0x4012a9(x)
│   │ └───> 0x00401304      83cfff         or edi, 0xffffffff          ; -1
│   │   ╎   0x00401307      e8d4feffff     call sym.imp.exit           ; void exit(int status)
│   │   ╎   ; CODE XREF from main @ 0x4012f6(x)
│   └─────> 0x0040130c      66817c2406..   cmp word [var_6h], 0xaa
│       ╎   0x00401313      488d3d190e..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│       └─< 0x0040131a      75e3           jne 0x4012ff
```

```
hacker@reverse-engineering~version-information-x86:~$ echo -ne '[nnR\xaa\x00' | /challenge/cimg 
pwn.college{k2N0ZoIaBuhv7hzE7FoSvNiS1__.0lMwMDMxwyMyITOyEzW}
```

## Metadata and Data (Python)

```
hacker@reverse-engineering~metadata-and-data-python:~$ cat /challenge/cimg 
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(20)
    assert len(header) == 20, "ERROR: Failed to read header!"

    assert header[:4] == b"{MAG", "ERROR: Invalid magic number!"

    assert int.from_bytes(header[4:12], "little") == 1, "ERROR: Invalid version!"

    width = int.from_bytes(header[12:16], "little")
    assert width == 79, "ERROR: Incorrect width!"

    height = int.from_bytes(header[16:20], "little")
    assert height == 24, "ERROR: Incorrect height!"

    data = file.read1(width * height)
    assert len(data) == width * height, "ERROR: Failed to read data!"

    pixels = [Pixel(character) for character in data]

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
```

We first write the magic bytes `{MAG`, then 64-bit `0x0000000000000001`, then ints `79 = 0x4f000000` and `24 = 0x18000000`, then we need `79 * 24` bytes.

```
hacker@reverse-engineering~metadata-and-data-python:~$ python3 -c "import sys; sys.stdout.buffer.write(b'{MAG\x01\x00\x00\x00\x00\x00\x00\x00\x4f\x00\x00\x00\x18\x00\x00\x00' + b'\x00'*(79*24))" | /challenge/cimg 
pwn.college{MW2upS0HVr7G_CD_dAQ7bQrJWZp.0VMxUjNxwyMyITOyEzW}
```

## Metadata and Data (C)

```
│     │ └─> 0x004012e0      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x004012e4      31ff           xor edi, edi                ; int fildes
│     │     0x004012e6      488d74240b     lea rsi, [var_bh]           ; void *buf
│     │     0x004012eb      ba0d000000     mov edx, 0xd                ; 13 ; size_t nbyte
│     │     0x004012f0      488d0d010e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012f7      e88f020000     call sym.read_exact
│     │     0x004012fc      807c240b28     cmp byte [var_bh], 0x28     ; '('
│     │ ┌─< 0x00401301      7515           jne 0x401318
│     │ │   0x00401303      807c240c4d     cmp byte [var_ch], 0x4d     ; 'M'
│     │┌──< 0x00401308      750e           jne 0x401318
│     │││   0x0040130a      807c240d36     cmp byte [var_dh], 0x36     ; '6'
│    ┌────< 0x0040130f      7507           jne 0x401318
│    ││││   0x00401311      807c240e33     cmp byte [var_eh], 0x33     ; '3'
│   ┌─────< 0x00401316      7414           je 0x40132c
│   │││││   ; CODE XREFS from main @ 0x401301(x), 0x401308(x), 0x40130f(x)
│   │└─└└─> 0x00401318      488d3df70d..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREFS from main @ 0x401338(x), 0x401346(x), 0x401354(x), 0x40136d(x)
│  ┌─┌─┌┌─> 0x0040131f      e81cfeffff     call sym.imp.puts           ; int puts(const char *s)
│  ╎│╎│╎╎   ; CODE XREF from main @ 0x4012c9(x)
│  ╎│╎└───> 0x00401324      83cfff         or edi, 0xffffffff          ; -1
│  ╎│╎ ╎╎   0x00401327      e8d4feffff     call sym.imp.exit           ; void exit(int status)
│  ╎│╎ ╎╎   ; CODE XREF from main @ 0x401316(x)
│  ╎└─────> 0x0040132c      837c240f01     cmp dword [var_fh], 1
│  ╎ ╎ ╎╎   0x00401331      488d3dfb0d..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│  └──────< 0x00401338      75e5           jne 0x40131f
│    ╎ ╎╎   0x0040133a      807c24133e     cmp byte [var_13h], 0x3e    ; '>'
│    ╎ ╎╎   0x0040133f      488d3d090e..   lea rdi, str.ERROR:_Incorrect_width_ ; 0x40214f ; "ERROR: Incorrect width!"
│    └────< 0x00401346      75d7           jne 0x40131f
│      ╎╎   0x00401348      837c24140e     cmp dword [var_14h], 0xe
│      ╎╎   0x0040134d      488d3d130e..   lea rdi, str.ERROR:_Incorrect_height_ ; 0x402167 ; "ERROR: Incorrect height!"
│      └──< 0x00401354      75c9           jne 0x40131f
│       ╎   0x00401356      bf64030000     mov edi, 0x364              ; 868 ; size_t size
│       ╎   0x0040135b      e860feffff     call sym.imp.malloc         ;  void *malloc(size_t size)
│       ╎   0x00401360      488d3d190e..   lea rdi, str.ERROR:_Failed_to_allocate_memory_for_the_image_data_ ; 0x402180 ; "ERROR: Failed to allocate memory for the image data!"
│       ╎   0x00401367      4889c6         mov rsi, rax
│       ╎   0x0040136a      4885c0         test rax, rax
│       └─< 0x0040136d      74b0           je 0x40131f
│           0x0040136f      4183c8ff       or r8d, 0xffffffff          ; -1
│           0x00401373      31ff           xor edi, edi                ; int fildes
│           0x00401375      ba64030000     mov edx, 0x364              ; 868 ; size_t nbyte
│           0x0040137a      488d0d340e..   lea rcx, str.ERROR:_Failed_to_read_data_ ; 0x4021b5 ; "ERROR: Failed to read data!" ; int64_t arg4
│           0x00401381      e805020000     call sym.read_exact
│           0x00401386      31c0           xor eax, eax
│           0x00401388      e809010000     call sym.win
```

```
hacker@reverse-engineering~metadata-and-data-c:~$ python3 -c "import sys; sys.stdout.buffer.write(b'(M63\x01\x00\x00\x00\x3e\x0e\x00\x00\x00' + b'\x00'*(868))" | /challenge/cimg
pwn.college{sE5rL5NCNt6iUEUyYQmZQhEehBI.0lMxUjNxwyMyITOyEzW}
```

## Metadata and Data (x86)

```
│     │ └─> 0x004012e0      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x004012e4      31ff           xor edi, edi                ; int fildes
│     │     0x004012e6      488d742409     lea rsi, [var_9h]           ; void *buf
│     │     0x004012eb      ba0f000000     mov edx, 0xf                ; 15 ; size_t nbyte
│     │     0x004012f0      488d0d010e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012f7      e88f020000     call sym.read_exact
│     │     0x004012fc      807c24095b     cmp byte [var_9h], 0x5b     ; '['
│     │ ┌─< 0x00401301      7515           jne 0x401318
│     │ │   0x00401303      807c240a4d     cmp byte [var_ah], 0x4d     ; 'M'
│     │┌──< 0x00401308      750e           jne 0x401318
│     │││   0x0040130a      807c240b34     cmp byte [var_bh], 0x34     ; '4'
│    ┌────< 0x0040130f      7507           jne 0x401318
│    ││││   0x00401311      807c240c47     cmp byte [var_ch], 0x47     ; 'G'
│   ┌─────< 0x00401316      7414           je 0x40132c
│   │││││   ; CODE XREFS from main @ 0x401301(x), 0x401308(x), 0x40130f(x)
│   │└─└└─> 0x00401318      488d3df70d..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREFS from main @ 0x401339(x), 0x401348(x), 0x401356(x), 0x40136f(x)
│  ┌─┌─┌┌─> 0x0040131f      e81cfeffff     call sym.imp.puts           ; int puts(const char *s)
│  ╎│╎│╎╎   ; CODE XREF from main @ 0x4012c9(x)
│  ╎│╎└───> 0x00401324      83cfff         or edi, 0xffffffff          ; -1
│  ╎│╎ ╎╎   0x00401327      e8d4feffff     call sym.imp.exit           ; void exit(int status)
│  ╎│╎ ╎╎   ; CODE XREF from main @ 0x401316(x)
│  ╎└─────> 0x0040132c      48837c240d01   cmp qword [var_dh], 1
│  ╎ ╎ ╎╎   0x00401332      488d3dfa0d..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│  └──────< 0x00401339      75e4           jne 0x40131f
│    ╎ ╎╎   0x0040133b      66837c241528   cmp word [var_15h], 0x28    ; '('
│    ╎ ╎╎   0x00401341      488d3d070e..   lea rdi, str.ERROR:_Incorrect_width_ ; 0x40214f ; "ERROR: Incorrect width!"
│    └────< 0x00401348      75d5           jne 0x40131f
│      ╎╎   0x0040134a      807c24170e     cmp byte [var_17h], 0xe
│      ╎╎   0x0040134f      488d3d110e..   lea rdi, str.ERROR:_Incorrect_height_ ; 0x402167 ; "ERROR: Incorrect height!"
│      └──< 0x00401356      75c7           jne 0x40131f
│       ╎   0x00401358      bf30020000     mov edi, 0x230              ; 560 ; size_t size
│       ╎   0x0040135d      e85efeffff     call sym.imp.malloc         ;  void *malloc(size_t size)
│       ╎   0x00401362      488d3d170e..   lea rdi, str.ERROR:_Failed_to_allocate_memory_for_the_image_data_ ; 0x402180 ; "ERROR: Failed to allocate memory for the image data!"
│       ╎   0x00401369      4889c6         mov rsi, rax
│       ╎   0x0040136c      4885c0         test rax, rax
│       └─< 0x0040136f      74ae           je 0x40131f
│           0x00401371      4183c8ff       or r8d, 0xffffffff          ; -1
│           0x00401375      31ff           xor edi, edi                ; int fildes
│           0x00401377      ba30020000     mov edx, 0x230              ; 560 ; size_t nbyte
│           0x0040137c      488d0d320e..   lea rcx, str.ERROR:_Failed_to_read_data_ ; 0x4021b5 ; "ERROR: Failed to read data!" ; int64_t arg4
│           0x00401383      e803020000     call sym.read_exact
│           0x00401388      31c0           xor eax, eax
│           0x0040138a      e807010000     call sym.win
```

```
hacker@reverse-engineering~metadata-and-data-x86:~$ python3 -c "import sys; sys.stdout.buffer.write(b'[M4G\x01\x00\x00\x00\x00\x00\x00\x00\x28\x00\x0e' + b'\x00'*(0x230))" | /challenge/cimg
pwn.college{wJ783jOxszoltMHQK3_XvqfxUmF.01MwMDMxwyMyITOyEzW}
```

## Input Restrictions (Python)

```python
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(10)
    assert len(header) == 10, "ERROR: Failed to read header!"

    assert header[:4] == b"cIMG", "ERROR: Invalid magic number!"

    assert int.from_bytes(header[4:6], "little") == 1, "ERROR: Invalid version!"

    width = int.from_bytes(header[6:8], "little")
    assert width == 61, "ERROR: Incorrect width!"

    height = int.from_bytes(header[8:10], "little")
    assert height == 15, "ERROR: Incorrect height!"

    data = file.read1(width * height)
    assert len(data) == width * height, "ERROR: Failed to read data!"

    pixels = [Pixel(character) for character in data]

    invalid_character = next((pixel.ascii for pixel in pixels if not (0x20 <= pixel.ascii <= 0x7E)), None)
    assert invalid_character is None, f"ERROR: Invalid character {invalid_character:#04x} in data!"

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
```

Just have to put pixels between in the ASCII range, for example all of them equal to `0x20`.

```
hacker@reverse-engineering~input-restrictions-python:~$ python3 -c "import sys; sys.stdout.buffer.write(b'cIMG\x01\x00\x3d\x00\x0f\x00' + b'\x20'*(61 * 15))" | /challenge/cimg
pwn.college{wlBjgnFOtwzxSKohFdIkN_n03CK.01MxUjNxwyMyITOyEzW}
```

## Input Restrictions (C)

```
│     │ └─> 0x004012df      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x004012e3      31ff           xor edi, edi                ; int fildes
│     │     0x004012e5      488d0d0c0e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012ec      4889e6         mov rsi, rsp                ; void *buf
│     │     0x004012ef      ba18000000     mov edx, 0x18               ; 24 ; size_t nbyte
│     │     0x004012f4      e8d2020000     call sym.read_exact
│     │     0x004012f9      803c2463       cmp byte [rsp], 0x63        ; 'c'
│     │ ┌─< 0x004012fd      7515           jne 0x401314
│     │ │   0x004012ff      807c240149     cmp byte [var_1h], 0x49     ; 'I'
│     │┌──< 0x00401304      750e           jne 0x401314
│     │││   0x00401306      807c24024d     cmp byte [var_2h], 0x4d     ; 'M'
│    ┌────< 0x0040130b      7507           jne 0x401314
│    ││││   0x0040130d      807c240347     cmp byte [var_3h], 0x47     ; 'G'
│   ┌─────< 0x00401312      7414           je 0x401328
│   │││││   ; CODE XREFS from main @ 0x4012fd(x), 0x401304(x), 0x40130b(x)
│   │└─└└─> 0x00401314      488d3dfb0d..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREFS from main @ 0x401335(x), 0x401344(x), 0x401352(x), 0x40136b(x)
│  ┌─┌─┌┌─> 0x0040131b      e820feffff     call sym.imp.puts           ; int puts(const char *s)
│  ╎│╎│╎╎   ; CODE XREFS from main @ 0x4012c8(x), 0x4013c2(x)
│ ┌───└───> 0x00401320      83cfff         or edi, 0xffffffff          ; -1
│ ╎╎│╎ ╎╎   0x00401323      e8d8feffff     call sym.imp.exit           ; void exit(int status)
│ ╎╎│╎ ╎╎   ; CODE XREF from main @ 0x401312(x)
│ ╎╎└─────> 0x00401328      48837c240401   cmp qword [var_4h], 1
│ ╎╎ ╎ ╎╎   0x0040132e      488d3dfe0d..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│ ╎└──────< 0x00401335      75e4           jne 0x40131b
│ ╎  ╎ ╎╎   0x00401337      48837c240c3e   cmp qword [var_ch], 0x3e    ; '>'
│ ╎  ╎ ╎╎   0x0040133d      488d3d0b0e..   lea rdi, str.ERROR:_Incorrect_width_ ; 0x40214f ; "ERROR: Incorrect width!"
│ ╎  └────< 0x00401344      75d5           jne 0x40131b
│ ╎    ╎╎   0x00401346      837c24140e     cmp dword [var_14h], 0xe
│ ╎    ╎╎   0x0040134b      488d3d150e..   lea rdi, str.ERROR:_Incorrect_height_ ; 0x402167 ; "ERROR: Incorrect height!"
│ ╎    └──< 0x00401352      75c7           jne 0x40131b
│ ╎     ╎   0x00401354      bf64030000     mov edi, 0x364              ; 868 ; size_t size
│ ╎     ╎   0x00401359      e862feffff     call sym.imp.malloc         ;  void *malloc(size_t size)
│ ╎     ╎   0x0040135e      488d3d1b0e..   lea rdi, str.ERROR:_Failed_to_allocate_memory_for_the_image_data_ ; 0x402180 ; "ERROR: Failed to allocate memory for the image data!"
│ ╎     ╎   0x00401365      4889c3         mov rbx, rax
│ ╎     ╎   0x00401368      4885c0         test rax, rax
│ ╎     └─< 0x0040136b      74ae           je 0x40131b
│ ╎         0x0040136d      ba64030000     mov edx, 0x364              ; 868 ; size_t nbyte
│ ╎         0x00401372      4889c6         mov rsi, rax                ; void *buf
│ ╎         0x00401375      4183c8ff       or r8d, 0xffffffff          ; -1
│ ╎         0x00401379      31ff           xor edi, edi                ; int fildes
│ ╎         0x0040137b      488d0d330e..   lea rcx, str.ERROR:_Failed_to_read_data_ ; 0x4021b5 ; "ERROR: Failed to read data!" ; int64_t arg4
│ ╎         0x00401382      e844020000     call sym.read_exact
│ ╎         0x00401387      8b542414       mov edx, dword [var_14h]
│ ╎         0x0040138b      480faf54240c   imul rdx, qword [var_ch]
│ ╎         0x00401391      31c0           xor eax, eax
│ ╎         ; CODE XREF from main @ 0x4013a6(x)
│ ╎     ┌─> 0x00401393      4839c2         cmp rdx, rax
│ ╎    ┌──< 0x00401396      742f           je 0x4013c7
│ ╎    │╎   0x00401398      0fb60c03       movzx ecx, byte [rbx + rax]
│ ╎    │╎   0x0040139c      48ffc0         inc rax
│ ╎    │╎   0x0040139f      8d71e0         lea esi, [rcx - 0x20]
│ ╎    │╎   0x004013a2      4080fe5e       cmp sil, 0x5e               ; '^' ; 94
│ ╎    │└─< 0x004013a6      76eb           jbe 0x401393
│ ╎    │    0x004013a8      488b3d912c..   mov rdi, qword [obj.stderr] ; obj.stderr__GLIBC_2.2.5
│ ╎    │                                                               ; [0x404040:8]=0
│ ╎    │    0x004013af      488d151b0e..   lea rdx, str.ERROR:_Invalid_character_0x_x_in_the_image_data__n ; str.ERROR:_Invalid_character_0x_x_in_the_image_data__n
│ ╎    │                                                               ; 0x4021d1 ; "ERROR: Invalid character 0x%x in the image data!\n"
│ ╎    │    0x004013b6      be01000000     mov esi, 1
│ ╎    │    0x004013bb      31c0           xor eax, eax
│ ╎    │    0x004013bd      e84efeffff     call sym.imp.__fprintf_chk
│ └───────< 0x004013c2      e959ffffff     jmp 0x401320
│      │    ; CODE XREF from main @ 0x401396(x)
│      └──> 0x004013c7      31c0           xor eax, eax
│           0x004013c9      e808010000     call sym.win
```

```python
# cimg_payload.py
import sys
import struct

payload = b""
payload += b"cIMG"
payload += struct.pack("<Q", 1) # version qword
payload += struct.pack("<Q", 0x3e) # width qword
payload += struct.pack("<I", 0xe) # height dword
payload += b"0x20" * (0x3e * 0xe) # width x height bytes that are 0x20 <= b <= 0x7e

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~input-restrictions-c:~$ python3 cimg_payload.py | /challenge/cimg
pwn.college{wXsbxJ-J2kJjpvk42ovD8Ou4oir.0FNxUjNxwyMyITOyEzW}
```

## Input Restrictions (x86)

```
│     │ │   ; CODE XREF from main @ 0x401290(x)
│     │ └─> 0x004012e1      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x004012e5      31ff           xor edi, edi                ; int fildes
│     │     0x004012e7      488d74240a     lea rsi, [var_ah]           ; void *buf
│     │     0x004012ec      ba0e000000     mov edx, 0xe                ; 14 ; size_t nbyte
│     │     0x004012f1      488d0d000e..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x004012f8      e8ce020000     call sym.read_exact
│     │     0x004012fd      807c240a63     cmp byte [var_ah], 0x63     ; 'c'
│     │ ┌─< 0x00401302      7515           jne 0x401319
│     │ │   0x00401304      807c240b49     cmp byte [var_bh], 0x49     ; 'I'
│     │┌──< 0x00401309      750e           jne 0x401319
│     │││   0x0040130b      807c240c4d     cmp byte [var_ch], 0x4d     ; 'M'
│    ┌────< 0x00401310      7507           jne 0x401319
│    ││││   0x00401312      807c240d47     cmp byte [var_dh], 0x47     ; 'G'
│   ┌─────< 0x00401317      7414           je 0x40132d
│   │││││   ; CODE XREFS from main @ 0x401302(x), 0x401309(x), 0x401310(x)
│   │└─└└─> 0x00401319      488d3df60d..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREFS from main @ 0x401339(x), 0x401348(x), 0x401356(x), 0x40136f(x)
│  ┌─┌─┌┌─> 0x00401320      e81bfeffff     call sym.imp.puts           ; int puts(const char *s)
│  ╎│╎│╎╎   ; CODE XREFS from main @ 0x4012ca(x), 0x4013c5(x)
│ ┌───└───> 0x00401325      83cfff         or edi, 0xffffffff          ; -1
│ ╎╎│╎ ╎╎   0x00401328      e8d3feffff     call sym.imp.exit           ; void exit(int status)
│ ╎╎│╎ ╎╎   ; CODE XREF from main @ 0x401317(x)
│ ╎╎└─────> 0x0040132d      837c240e01     cmp dword [var_eh], 1
│ ╎╎ ╎ ╎╎   0x00401332      488d3dfa0d..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│ ╎└──────< 0x00401339      75e5           jne 0x401320
│ ╎  ╎ ╎╎   0x0040133b      66837c24124f   cmp word [var_12h], 0x4f    ; 'O'
│ ╎  ╎ ╎╎   0x00401341      488d3d070e..   lea rdi, str.ERROR:_Incorrect_width_ ; 0x40214f ; "ERROR: Incorrect width!"
│ ╎  └────< 0x00401348      75d6           jne 0x401320
│ ╎    ╎╎   0x0040134a      837c241418     cmp dword [var_14h], 0x18
│ ╎    ╎╎   0x0040134f      488d3d110e..   lea rdi, str.ERROR:_Incorrect_height_ ; 0x402167 ; "ERROR: Incorrect height!"
│ ╎    └──< 0x00401356      75c8           jne 0x401320
│ ╎     ╎   0x00401358      bf68070000     mov edi, 0x768              ; 1896 ; size_t size
│ ╎     ╎   0x0040135d      e85efeffff     call sym.imp.malloc         ;  void *malloc(size_t size)
│ ╎     ╎   0x00401362      488d3d170e..   lea rdi, str.ERROR:_Failed_to_allocate_memory_for_the_image_data_ ; 0x402180 ; "ERROR: Failed to allocate memory for the image data!"
│ ╎     ╎   0x00401369      4889c3         mov rbx, rax
│ ╎     ╎   0x0040136c      4885c0         test rax, rax
│ ╎     └─< 0x0040136f      74af           je 0x401320
│ ╎         0x00401371      ba68070000     mov edx, 0x768              ; 1896 ; size_t nbyte
│ ╎         0x00401376      4889c6         mov rsi, rax                ; void *buf
│ ╎         0x00401379      4183c8ff       or r8d, 0xffffffff          ; -1
│ ╎         0x0040137d      31ff           xor edi, edi                ; int fildes
│ ╎         0x0040137f      488d0d2f0e..   lea rcx, str.ERROR:_Failed_to_read_data_ ; 0x4021b5 ; "ERROR: Failed to read data!" ; int64_t arg4
│ ╎         0x00401386      e840020000     call sym.read_exact
│ ╎         0x0040138b      0fb7542412     movzx edx, word [var_12h]
│ ╎         0x00401390      0faf542414     imul edx, dword [var_14h]
│ ╎         0x00401395      31c0           xor eax, eax
│ ╎         ; CODE XREF from main @ 0x4013a9(x)
│ ╎     ┌─> 0x00401397      39c2           cmp edx, eax
│ ╎    ┌──< 0x00401399      762f           jbe 0x4013ca
│ ╎    │╎   0x0040139b      0fb60c03       movzx ecx, byte [rbx + rax]
│ ╎    │╎   0x0040139f      48ffc0         inc rax
│ ╎    │╎   0x004013a2      8d71e0         lea esi, [rcx - 0x20]
│ ╎    │╎   0x004013a5      4080fe5e       cmp sil, 0x5e               ; '^' ; 94
│ ╎    │└─< 0x004013a9      76ec           jbe 0x401397
│ ╎    │    0x004013ab      488b3d8e2c..   mov rdi, qword [obj.stderr] ; obj.stderr__GLIBC_2.2.5
│ ╎    │                                                               ; [0x404040:8]=0
│ ╎    │    0x004013b2      488d15180e..   lea rdx, str.ERROR:_Invalid_character_0x_x_in_the_image_data__n ; str.ERROR:_Invalid_character_0x_x_in_the_image_data__n
│ ╎    │                                                               ; 0x4021d1 ; "ERROR: Invalid character 0x%x in the image data!\n"
│ ╎    │    0x004013b9      be01000000     mov esi, 1
│ ╎    │    0x004013be      31c0           xor eax, eax
│ ╎    │    0x004013c0      e84bfeffff     call sym.imp.__fprintf_chk
│ └───────< 0x004013c5      e95bffffff     jmp 0x401325
│      │    ; CODE XREF from main @ 0x401399(x)
│      └──> 0x004013ca      31c0           xor eax, eax
│           0x004013cc      e805010000     call sym.win
```

```python
# cimg_payload.py
import sys
import struct

payload = b""
payload += b"cIMG"
payload += struct.pack("<I", 1) # version dword
payload += struct.pack("<H", 0x4f) # width word
payload += struct.pack("<I", 0x18) # height dword
payload += b"0x20" * 0x768 # width x height bytes that are 0x20 <= b <= 0x7e

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~input-restrictions-x86:~$ python3 cimg_payload.py | /challenge/cimg 
pwn.college{8PmZHJRMnOuf8EYgPA7nLJHAIIp.0FNwMDMxwyMyITOyEzW}
```

## Behold the cIMG! (Python)

```python
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(20)
    assert len(header) == 20, "ERROR: Failed to read header!"

    assert header[:4] == b"cIMG", "ERROR: Invalid magic number!"

    assert int.from_bytes(header[4:12], "little") == 1, "ERROR: Invalid version!"

    width = int.from_bytes(header[12:16], "little")

    height = int.from_bytes(header[16:20], "little")

    data = file.read1(width * height)
    assert len(data) == width * height, "ERROR: Failed to read data!"

    pixels = [Pixel(character) for character in data]

    invalid_character = next((pixel.ascii for pixel in pixels if not (0x20 <= pixel.ascii <= 0x7E)), None)
    assert invalid_character is None, f"ERROR: Invalid character {invalid_character:#04x} in data!"

    framebuffer = "".join(
        bytes(pixel.ascii for pixel in pixels[row_start : row_start + width]).decode() + "\n"
        for row_start in range(0, len(pixels), width)
    )
    print(framebuffer)

    nonspace_count = sum(1 for pixel in pixels if chr(pixel.ascii) != " ")
    if nonspace_count != 275:
        return

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
```

```python
# cimg_payload.py
import sys
import struct

# width * height must be 275
width = 25
height = 11

payload = b""
payload += b"cIMG"
payload += struct.pack("<Q", 1) # version qword
payload += struct.pack("<I", width) # width dword
payload += struct.pack("<I", height) # height dword
payload += b"\x61" * (width * height) # width x height bytes that are 0x20 <= b <= 0x7e

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~behold-the-cimg-python:~$ python3 cimg_payload.py | /challenge/cimg 
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa

pwn.college{w5swLdPsWE3jIhqr6C_V0Q5fFGm.0VNxUjNxwyMyITOyEzW}
```

## Behold the cIMG! (C)

```
│     │ └─> 0x00401308      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x0040130c      31ff           xor edi, edi                ; int fildes
│     │     0x0040130e      488d0de30d..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x00401315      4889ee         mov rsi, rbp                ; void *buf
│     │     0x00401318      ba0f000000     mov edx, 0xf                ; 15 ; size_t nbyte
│     │     0x0040131d      e8f9020000     call sym.read_exact
│     │     0x00401322      807c240963     cmp byte [var_9h], 0x63     ; 'c'
│     │ ┌─< 0x00401327      7515           jne 0x40133e
│     │ │   0x00401329      807c240a49     cmp byte [var_ah], 0x49     ; 'I'
│     │┌──< 0x0040132e      750e           jne 0x40133e
│     │││   0x00401330      807c240b4d     cmp byte [var_bh], 0x4d     ; 'M'
│    ┌────< 0x00401335      7507           jne 0x40133e
│    ││││   0x00401337      807c240c47     cmp byte [var_ch], 0x47     ; 'G'
│   ┌─────< 0x0040133c      7414           je 0x401352
│   │││││   ; CODE XREFS from main @ 0x401327(x), 0x40132e(x), 0x401335(x)
│   │└─└└─> 0x0040133e      488d3dd10d..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREFS from main @ 0x40135e(x), 0x401381(x)
│   │ │┌┌─> 0x00401345      e816feffff     call sym.imp.puts           ; int puts(const char *s)
│   │ │╎╎   ; CODE XREFS from main @ 0x4012f1(x), 0x4013d7(x)
│   │┌└───> 0x0040134a      83cfff         or edi, 0xffffffff          ; -1
│   │╎ ╎╎   0x0040134d      e8cefeffff     call sym.imp.exit           ; void exit(int status)
│   │╎ ╎╎   ; CODE XREF from main @ 0x40133c(x)
│   └─────> 0x00401352      807c240d01     cmp byte [var_dh], 1
│    ╎ ╎╎   0x00401357      488d3dd50d..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│    ╎ └──< 0x0040135e      75e5           jne 0x401345
│    ╎  ╎   0x00401360      440fb7642416   movzx r12d, word [var_16h]
│    ╎  ╎   0x00401366      4c0faf64240e   imul r12, qword [size]
│    ╎  ╎   0x0040136c      4c89e7         mov rdi, r12                ; size_t size
│    ╎  ╎   0x0040136f      e86cfeffff     call sym.imp.malloc         ;  void *malloc(size_t size)
│    ╎  ╎   0x00401374      488d3dd40d..   lea rdi, str.ERROR:_Failed_to_allocate_memory_for_the_image_data_ ; 0x40214f ; "ERROR: Failed to allocate memory for the image data!"
│    ╎  ╎   0x0040137b      4889c3         mov rbx, rax
│    ╎  ╎   0x0040137e      4885c0         test rax, rax
│    ╎  └─< 0x00401381      74c2           je 0x401345
│    ╎      0x00401383      4489e2         mov edx, r12d               ; size_t nbyte
│    ╎      0x00401386      4889c6         mov rsi, rax                ; void *buf
│    ╎      0x00401389      4183c8ff       or r8d, 0xffffffff          ; -1
│    ╎      0x0040138d      31ff           xor edi, edi                ; int fildes
│    ╎      0x0040138f      488d0dee0d..   lea rcx, str.ERROR:_Failed_to_read_data_ ; 0x402184 ; "ERROR: Failed to read data!" ; int64_t arg4
│    ╎      0x00401396      e880020000     call sym.read_exact
│    ╎      0x0040139b      0fb7542416     movzx edx, word [var_16h]
│    ╎      0x004013a0      480faf54240e   imul rdx, qword [size]
│    ╎      0x004013a6      31c0           xor eax, eax
│    ╎      ; CODE XREF from main @ 0x4013bb(x)
│    ╎  ┌─> 0x004013a8      4839c2         cmp rdx, rax
│    ╎ ┌──< 0x004013ab      742f           je 0x4013dc
│    ╎ │╎   0x004013ad      0fb60c03       movzx ecx, byte [rbx + rax]
│    ╎ │╎   0x004013b1      48ffc0         inc rax
│    ╎ │╎   0x004013b4      8d71e0         lea esi, [rcx - 0x20]
│    ╎ │╎   0x004013b7      4080fe5e       cmp sil, 0x5e               ; '^' ; 94
│    ╎ │└─< 0x004013bb      76eb           jbe 0x4013a8
│    ╎ │    0x004013bd      488b3d7c2c..   mov rdi, qword [obj.stderr] ; obj.stderr__GLIBC_2.2.5
│    ╎ │                                                               ; [0x404040:8]=0
│    ╎ │    0x004013c4      488d15d50d..   lea rdx, str.ERROR:_Invalid_character_0x_x_in_the_image_data__n ; str.ERROR:_Invalid_character_0x_x_in_the_image_data__n
│    ╎ │                                                               ; 0x4021a0 ; "ERROR: Invalid character 0x%x in the image data!\n"
│    ╎ │    0x004013cb      be01000000     mov esi, 1
│    ╎ │    0x004013d0      31c0           xor eax, eax
│    ╎ │    0x004013d2      e859feffff     call sym.imp.__fprintf_chk
│    └────< 0x004013d7      e96effffff     jmp 0x40134a
│      │    ; CODE XREF from main @ 0x4013ab(x)
│      └──> 0x004013dc      4889de         mov rsi, rbx                ; int64_t arg2
│           0x004013df      4889ef         mov rdi, rbp                ; int64_t arg1
│           0x004013e2      e884020000     call sym.display
│           0x004013e7      0fb74c2416     movzx ecx, word [var_16h]
│           0x004013ec      31c0           xor eax, eax
│           0x004013ee      31d2           xor edx, edx
│           0x004013f0      480faf4c240e   imul rcx, qword [size]
│           ; CODE XREF from main @ 0x401406(x)
│       ┌─> 0x004013f6      4839c1         cmp rcx, rax
│      ┌──< 0x004013f9      740d           je 0x401408
│      │╎   0x004013fb      803c0320       cmp byte [rbx + rax], 0x20
│     ┌───< 0x004013ff      7402           je 0x401403
│     ││╎   0x00401401      ffc2           inc edx
│     ││╎   ; CODE XREF from main @ 0x4013ff(x)
│     └───> 0x00401403      48ffc0         inc rax
│      │└─< 0x00401406      ebee           jmp 0x4013f6
│      │    ; CODE XREF from main @ 0x4013f9(x)
│      └──> 0x00401408      81fa13010000   cmp edx, 0x113              ; 275
│       ┌─< 0x0040140e      7507           jne 0x401417
│       │   0x00401410      31c0           xor eax, eax
│       │   0x00401412      e80f010000     call sym.win
```

Took some time to figure out, but it was kind of simple. For some reason I thought this was big endian, and for some reason I thought there was padding. Going through `gdb` made me realize
it was plain simple, just `width` was a `qword` and `height` was `word`.

```python
# cimg_payload.py
import sys
import struct

# width * height must be 275
width = 25
height = 11

payload = b""
payload += b"cIMG"  # 4 bytes
payload += struct.pack("<B", 1) # version byte, 5 bytes
payload += struct.pack("<Q", width) # height qword
payload += struct.pack("<H", height) # height qword
payload += b"\x61" * (width * height) # width x height bytes that are 0x20 <= b <= 0x7e

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~behold-the-cimg-c:~$ python3 cimg_payload.py | /challenge/cimg
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
pwn.college{oG93ot_fiZSjbQSqQVwVJ2iB2L0.0lNxUjNxwyMyITOyEzW}
```

## Behold the cIMG! (x86)

```
│     │ └─> 0x00401308      4183c8ff       or r8d, 0xffffffff          ; -1
│     │     0x0040130c      31ff           xor edi, edi                ; int fildes
│     │     0x0040130e      488d0de30d..   lea rcx, str.ERROR:_Failed_to_read_header_ ; 0x4020f8 ; "ERROR: Failed to read header!" ; int64_t arg4
│     │     0x00401315      4889ee         mov rsi, rbp                ; void *buf
│     │     0x00401318      ba0f000000     mov edx, 0xf                ; 15 ; size_t nbyte
│     │     0x0040131d      e8f9020000     call sym.read_exact
│     │     0x00401322      807c240963     cmp byte [var_9h], 0x63     ; 'c'
│     │ ┌─< 0x00401327      7515           jne 0x40133e
│     │ │   0x00401329      807c240a49     cmp byte [var_ah], 0x49     ; 'I'
│     │┌──< 0x0040132e      750e           jne 0x40133e
│     │││   0x00401330      807c240b4d     cmp byte [var_bh], 0x4d     ; 'M'
│    ┌────< 0x00401335      7507           jne 0x40133e
│    ││││   0x00401337      807c240c47     cmp byte [var_ch], 0x47     ; 'G'
│   ┌─────< 0x0040133c      7414           je 0x401352
│   │││││   ; CODE XREFS from main @ 0x401327(x), 0x40132e(x), 0x401335(x)
│   │└─└└─> 0x0040133e      488d3dd10d..   lea rdi, str.ERROR:_Invalid_magic_number_ ; 0x402116 ; "ERROR: Invalid magic number!"
│   │ │     ; CODE XREFS from main @ 0x40135e(x), 0x401381(x)
│   │ │┌┌─> 0x00401345      e816feffff     call sym.imp.puts           ; int puts(const char *s)
│   │ │╎╎   ; CODE XREFS from main @ 0x4012f1(x), 0x4013d7(x)
│   │┌└───> 0x0040134a      83cfff         or edi, 0xffffffff          ; -1
│   │╎ ╎╎   0x0040134d      e8cefeffff     call sym.imp.exit           ; void exit(int status)
│   │╎ ╎╎   ; CODE XREF from main @ 0x40133c(x)
│   └─────> 0x00401352      807c240d01     cmp byte [var_dh], 1
│    ╎ ╎╎   0x00401357      488d3dd50d..   lea rdi, str.ERROR:_Unsupported_version_ ; 0x402133 ; "ERROR: Unsupported version!"
│    ╎ └──< 0x0040135e      75e5           jne 0x401345
│    ╎  ╎   0x00401360      440fb7642416   movzx r12d, word [var_16h]
│    ╎  ╎   0x00401366      4c0faf64240e   imul r12, qword [size]
│    ╎  ╎   0x0040136c      4c89e7         mov rdi, r12                ; size_t size
│    ╎  ╎   0x0040136f      e86cfeffff     call sym.imp.malloc         ;  void *malloc(size_t size)
│    ╎  ╎   0x00401374      488d3dd40d..   lea rdi, str.ERROR:_Failed_to_allocate_memory_for_the_image_data_ ; 0x40214f ; "ERROR: Failed to allocate memory for the image data!"
│    ╎  ╎   0x0040137b      4889c3         mov rbx, rax
│    ╎  ╎   0x0040137e      4885c0         test rax, rax
│    ╎  └─< 0x00401381      74c2           je 0x401345
│    ╎      0x00401383      4489e2         mov edx, r12d               ; size_t nbyte
│    ╎      0x00401386      4889c6         mov rsi, rax                ; void *buf
│    ╎      0x00401389      4183c8ff       or r8d, 0xffffffff          ; -1
│    ╎      0x0040138d      31ff           xor edi, edi                ; int fildes
│    ╎      0x0040138f      488d0dee0d..   lea rcx, str.ERROR:_Failed_to_read_data_ ; 0x402184 ; "ERROR: Failed to read data!" ; int64_t arg4
│    ╎      0x00401396      e880020000     call sym.read_exact
│    ╎      0x0040139b      0fb7542416     movzx edx, word [var_16h]
│    ╎      0x004013a0      480faf54240e   imul rdx, qword [size]
│    ╎      0x004013a6      31c0           xor eax, eax
│    ╎      ; CODE XREF from main @ 0x4013bb(x)
│    ╎  ┌─> 0x004013a8      4839c2         cmp rdx, rax
│    ╎ ┌──< 0x004013ab      742f           je 0x4013dc
│    ╎ │╎   0x004013ad      0fb60c03       movzx ecx, byte [rbx + rax]
│    ╎ │╎   0x004013b1      48ffc0         inc rax
│    ╎ │╎   0x004013b4      8d71e0         lea esi, [rcx - 0x20]
│    ╎ │╎   0x004013b7      4080fe5e       cmp sil, 0x5e               ; '^' ; 94
│    ╎ │└─< 0x004013bb      76eb           jbe 0x4013a8
│    ╎ │    0x004013bd      488b3d7c2c..   mov rdi, qword [obj.stderr] ; obj.stderr__GLIBC_2.2.5
│    ╎ │                                                               ; [0x404040:8]=0
│    ╎ │    0x004013c4      488d15d50d..   lea rdx, str.ERROR:_Invalid_character_0x_x_in_the_image_data__n ; str.ERROR:_Invalid_character_0x_x_in_the_image_data__n
│    ╎ │                                                               ; 0x4021a0 ; "ERROR: Invalid character 0x%x in the image data!\n"
│    ╎ │    0x004013cb      be01000000     mov esi, 1
│    ╎ │    0x004013d0      31c0           xor eax, eax
│    ╎ │    0x004013d2      e859feffff     call sym.imp.__fprintf_chk
│    └────< 0x004013d7      e96effffff     jmp 0x40134a
│      │    ; CODE XREF from main @ 0x4013ab(x)
│      └──> 0x004013dc      4889de         mov rsi, rbx                ; int64_t arg2
│           0x004013df      4889ef         mov rdi, rbp                ; int64_t arg1
│           0x004013e2      e884020000     call sym.display
│           0x004013e7      0fb74c2416     movzx ecx, word [var_16h]
│           0x004013ec      31c0           xor eax, eax
│           0x004013ee      31d2           xor edx, edx
│           0x004013f0      480faf4c240e   imul rcx, qword [size]
│           ; CODE XREF from main @ 0x401406(x)
│       ┌─> 0x004013f6      4839c1         cmp rcx, rax
│      ┌──< 0x004013f9      740d           je 0x401408
│      │╎   0x004013fb      803c0320       cmp byte [rbx + rax], 0x20
│     ┌───< 0x004013ff      7402           je 0x401403
│     ││╎   0x00401401      ffc2           inc edx
│     ││╎   ; CODE XREF from main @ 0x4013ff(x)
│     └───> 0x00401403      48ffc0         inc rax
│      │└─< 0x00401406      ebee           jmp 0x4013f6
│      │    ; CODE XREF from main @ 0x4013f9(x)
│      └──> 0x00401408      81fa13010000   cmp edx, 0x113              ; 275
│       ┌─< 0x0040140e      7507           jne 0x401417
│       │   0x00401410      31c0           xor eax, eax
│       │   0x00401412      e80f010000     call sym.win
```

Exactly the same solution works here again!

```python
# cimg_payload.py
import sys
import struct

# width * height must be 275
width = 25
height = 11

payload = b""
payload += b"cIMG"  # 4 bytes
payload += struct.pack("<B", 1) # version byte, 5 bytes
payload += struct.pack("<Q", width) # height qword
payload += struct.pack("<H", height) # height qword
payload += b"\x61" * (width * height) # width x height bytes that are 0x20 <= b <= 0x7e

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~behold-the-cimg-x86:~$ python3 cimg_payload.py | /challenge/cimg
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa
pwn.college{kvWO4uDtMv7Gm_3a-ER9PE4ppu-.0VNwMDMxwyMyITOyEzW}
```

## A Basic cIMG (Python)

```python
#!/usr/bin/exec-suid -- /usr/bin/python3 -I

import os
import sys
from collections import namedtuple

Pixel = namedtuple("Pixel", ["r", "g", "b", "ascii"])


def main():
    if len(sys.argv) >= 2:
        path = sys.argv[1]
        assert path.endswith(".cimg"), "ERROR: file has incorrect extension"
        file = open(path, "rb")
    else:
        file = sys.stdin.buffer

    header = file.read1(16)
    assert len(header) == 16, "ERROR: Failed to read header!"

    assert header[:4] == b"cIMG", "ERROR: Invalid magic number!"

    assert int.from_bytes(header[4:12], "little") == 2, "ERROR: Invalid version!"

    width = int.from_bytes(header[12:14], "little")
    assert width == 46, "ERROR: Incorrect width!"

    height = int.from_bytes(header[14:16], "little")
    assert height == 23, "ERROR: Incorrect height!"

    data = file.read1(width * height * 4)
    assert len(data) == width * height * 4, "ERROR: Failed to read data!"

    pixels = [Pixel(*data[i : i + 4]) for i in range(0, len(data), 4)]

    invalid_character = next((pixel.ascii for pixel in pixels if not (0x20 <= pixel.ascii <= 0x7E)), None)
    assert invalid_character is None, f"ERROR: Invalid character {invalid_character:#04x} in data!"

    ansii_escape = lambda pixel: f"\x1b[38;2;{pixel.r:03};{pixel.g:03};{pixel.b:03}m{chr(pixel.ascii)}\x1b[0m"
    framebuffer = "".join(
        "".join(ansii_escape(pixel) for pixel in pixels[row_start : row_start + width])
        + ansii_escape(Pixel(0, 0, 0, ord("\n")))
        for row_start in range(0, len(pixels), width)
    )
    print(framebuffer)

    nonspace_count = sum(1 for pixel in pixels if chr(pixel.ascii) != " ")
    if nonspace_count != 1058:
        return

    asu_maroon = (0x8C, 0x1D, 0x40)
    if any((pixel.r, pixel.g, pixel.b) != asu_maroon for pixel in pixels):
        return

    with open("/flag", "r") as f:
        flag = f.read()
        print(flag)


if __name__ == "__main__":
    try:
        main()
    except AssertionError as e:
        print(e, file=sys.stderr)
        sys.exit(-1)
```

We need to put the exact `RGB = #8c1d40`.

```python
# cimg_payload.py
import sys
import struct

# width * height must be 275
width = 46
height = 23

payload = b""
payload += b"cIMG"  # 4 bytes
payload += struct.pack("<Q", 2) # version qword, 12 bytes
payload += struct.pack("<H", width) # width word
payload += struct.pack("<H", height) # height word
payload += b"\x8c\x1d\x40\x61" * (width * height) # 4 x width x height bytes

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~a-basic-cimg-python:~$ python3 cimg_payload.py | /challenge/cimg 
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

pwn.college{Yd7u1U5-cMPEWf5LHZjnNFIwrzv.01NxUjNxwyMyITOyEzW}
```

## A Basic cIMG (C)

Just have to change some sizes, but it is generally the same.

```python
# cimg_payload.py
import sys
import struct

# width * height must be 275
width = 0x27
height = 0x15

payload = b""
payload += b"cIMG"  # 4 bytes
payload += struct.pack("<B", 2) # version qword, 12 bytes
payload += struct.pack("<B", width) # width byte
payload += struct.pack("<I", height) # height dword
payload += b"\x8c\x1d\x40\x61" * (width * height) # 4 x width x height bytes

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~a-basic-cimg-c:~$ python3 cimg_payload.py | /challenge/cimg
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
pwn.college{gE7SLz8LudC1wr59wK1usZc3XvV.0FOxUjNxwyMyITOyEzW}
```

##  A Basic cIMG (x86)

Just have to change some sizes again, but it is generally the same.

```python
# cimg_payload.py
import sys
import struct

# width * height must be 275
width = 0x2a
height = 0x18

payload = b""
payload += b"cIMG"  # 4 bytes
payload += struct.pack("<H", 2) # version qword, 12 bytes
payload += struct.pack("<I", width) # width byte
payload += struct.pack("<B", height) # height dword
payload += b"\x8c\x1d\x40\x61" * (width * height) # 4 x width x height bytes

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~a-basic-cimg-x86:~$ python3 cimg_payload.py | /challenge/cimg 
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
pwn.college{cs2W8SvYLqzP2Klopp5yK7JyhE7.0lNwMDMxwyMyITOyEzW}
```

## Internal State Mini (C)

### Enquanto eu estava confuso

We need to investigate this part:
```
│      └──> 0x004013ff      4889ee         mov rsi, rbp                ; int64_t arg2
│           0x00401402      4c89e7         mov rdi, r12                ; int64_t arg1
│           0x00401405      4c8d25142c..   lea r12, obj.desired_output ; 0x404020
│           0x0040140c      31db           xor ebx, ebx
│           0x0040140e      e8b8020000     call sym.display
│           0x00401413      448b6c2408     mov r13d, dword [var_8h]
│           0x00401418      4c8b742410     mov r14, qword [var_10h]
│           0x0040141d      4183fd04       cmp r13d, 4                 ; 4, width x length must be 4
│           0x00401421      0f94c3         sete bl
│           0x00401424      31ed           xor ebp, ebp
│           0x00401426      4531ff         xor r15d, r15d
│           ; CODE XREF from main @ 0x40146a(x)
│       ┌─> 0x00401429      83fd04         cmp ebp, 4                  ; 4
│      ┌──< 0x0040142c      743e           je 0x40146c
│      │╎   0x0040142e      4139ed         cmp r13d, ebp
│     ┌───< 0x00401431      7639           jbe 0x40146c
│     ││╎   0x00401433      486bfd18       imul rdi, rbp, 0x18
│     ││╎   0x00401437      418a443e13     mov al, byte [r14 + rdi + 0x13]
│     ││╎   0x0040143c      413a442413     cmp al, byte [r12 + 0x13]
│     ││╎   0x00401441      410f45df       cmovne ebx, r15d
│     ││╎   0x00401445      3c20           cmp al, 0x20                ; 32
│    ┌────< 0x00401447      741a           je 0x401463
│    │││╎   0x00401449      3c0a           cmp al, 0xa                 ; 10
│   ┌─────< 0x0040144b      7416           je 0x401463
│   ││││╎   0x0040144d      4c01f7         add rdi, r14                ; const void *s1
│   ││││╎   0x00401450      ba18000000     mov edx, 0x18               ; 24 ; size_t n
│   ││││╎   0x00401455      4c89e6         mov rsi, r12                ; const void *s2
│   ││││╎   0x00401458      e883fdffff     call sym.imp.memcmp         ; int memcmp(const void *s1, const void *s2, size_t n)   ; the two memory areas must be equal
│   ││││╎   0x0040145d      85c0           test eax, eax
│   ││││╎   0x0040145f      410f45df       cmovne ebx, r15d
│   ││││╎   ; CODE XREFS from main @ 0x401447(x), 0x40144b(x)
│   └└────> 0x00401463      48ffc5         inc rbp
│     ││╎   0x00401466      4983c418       add r12, 0x18               ; 24
│     ││└─< 0x0040146a      ebbd           jmp 0x401429
│     ││    ; CODE XREFS from main @ 0x40142c(x), 0x401431(x)
│     └└──> 0x0040146c      85db           test ebx, ebx
│       ┌─< 0x0040146e      7407           je 0x401477
│       │   0x00401470      31c0           xor eax, eax
│       │   0x00401472      e80f010000     call sym.win
```

```python
# cimg_payload.py
import sys
import struct

width = 2
height = 2

# header has 8 bytes

payload = b""
payload += b"cIMG" # header[0] = 4 bytes
payload += struct.pack("<H", 2) # header[4] = version word
payload += struct.pack("<B", width) # header[6] = width byte
payload += struct.pack("<B", height) # header[7] = height byte
payload += b"\x20\x0a\x18\x63"
payload += b"\x20\x0a\x18\x49"
payload += b"\x20\x0a\x18\x4d"
payload += b"\x20\x0a\x18\x47"

sys.stdout.buffer.write(payload)
```

No começo da função `rsp+0x10 = 0`.

In order for the binary to call `sym.win`, we need `ebx != 0`. (`0x40146c`)
This `test ebx, ebx` is executed if `ebp == 4` or `r13d <= ebp`. (`0x401429`)
At `0x4013ff`, we have:
```
0x004013ff      4889ee         mov rsi, rbp                ; int64_t arg2
0x00401402      4c89e7         mov rdi, r12                ; int64_t arg1
0x00401405      4c8d25142c..   lea r12, obj.desired_output ; 0x404020
0x0040140c      31db           xor ebx, ebx ; here ebx = 0
0x0040140e      e8b8020000     call sym.display
0x00401413      448b6c2408     mov r13d, dword [var_8h] ; r13d is the width * length
0x00401418      4c8b742410     mov r14, qword [var_10h] ; r14 is the malloc'ed image data
0x0040141d      4183fd04       cmp r13d, 4                 ; 4
0x00401421      0f94c3         sete bl  ; if r13 == 4, then ebx = 1
0x00401424      31ed           xor ebp, ebp ; ebp = 0
0x00401426      4531ff         xor r15d, r15d   ; r15d = 0
```

We can put `r13 = 0`, then `ebx = 0`.

A função `initialize_framebuffer` é responsável por setar `(int) rsp+0x8 = width * length`
`(byte *) rsp+0x16 = malloc'ed buffer` (com size `0x18 * (width*height) + 1`)

No começo do `main`, `r12` é igual ao `rsp`, que é o header do arquivo cIMG.

Basically, we must set `width * height = 4` and also make sure our processed input to be equal to `desired_output` at `0x404020`

```python
desired_output = [0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x31, 0x37, 0x30, 0x3b, 0x30, 0x35, 0x34, 0x3b, 0x31, 0x31, 0x32, 0x6d, 0x63, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x31, 0x36, 0x31, 0x3b, 0x31, 0x32, 0x39, 0x3b, 0x32, 0x30, 0x34, 0x6d, 0x49, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x30, 0x30, 0x31, 0x3b, 0x31, 0x39, 0x35, 0x3b, 0x30, 0x35, 0x33, 0x6d, 0x4d, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x30, 0x36, 0x34, 0x3b, 0x30, 0x34, 0x36, 0x3b, 0x32, 0x32, 0x34, 0x6d, 0x47, 0x1b, 0x5b, 0x30, 0x6d, 0x00, 0x00]
```

Given all of this, we need to reverse the `initialize_framebuffer()` and `display()` functions.


#### `initialize_framebuffer`

```c
char *initialize_framebuffer(char *cimg_data) {
             /*    width    *   length */
    int size = cimg_data[6] * cimg_data[7]
    *(int *)(cimg_data + 8) = size;
    char *ptr_pixels = malloc(24 * size + 1);
    *(char **)(cimg_data + 16) = ptr_pixels;
    if (!pixels) {
        puts("ERROR: Failed to allocate...");
        exit(-1);
    }
    for (int i = 0; i < size; i++) {
        /* r12 = cimg_data */
        /* [r12 + 8] = size */
        /* ebx = i */
        /* rbp = rsp+0xf */

        /* __snprintf_chk */
        edx = 1;
        r9d = 0xff;
        rdi = rsp+0xf;
        r8 = "\033[38;2;%03d;%03d;%03dm%c\033[0m";
        ecx = 0x19;
        eax = 0;
        esi = 0x19;
        /* __snprintf_chk */

        rax = ptr_pixels + i * 0x18;
        rbx += 1;
        /* this is a terminal color string */
        rdx = *(rbp + 0x10); /* this is "55m \033[0m" always */
        *(ptr_pixels + i*0x18 + 0x10) = rdx;
    }
    return cimg_data;
}
```

O loop de `initialize_framebuffer` puts the terminal color string
at every `ptr_pixels[24*i + 16]`. Ou seja, nos últimos 8 bytes de cada
bloco de 24 bytes. Ainda sobra 16 bytes.

Acredito que `16 = 4*4`, seja para ser um `int` para cada dado
RGBC que colocamos como input.

O que interessa agora então é a função `display()`.

### Solução real

Se pegarmos o `desired_output` e printarmos no Python, obtemos a string `cIMG` coloridinha.

```python
>>> desired_output = [0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x31, 0x37, 0x30, 0x3b, 0x30, 0x35, 0x34, 0x3b, 0x31, 0x31, 0x32, 0x6d, 0x63, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x31, 0x36, 0x31, 0x3b, 0x31, 0x32, 0x39, 0x3b, 0x32, 0x30, 0x34, 0x6d, 0x49, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x30, 0x30, 0x31, 0x3b, 0x31, 0x39, 0x35, 0x3b, 0x30, 0x35, 0x33, 0x6d, 0x4d, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x30, 0x36, 0x34, 0x3b, 0x30, 0x34, 0x36, 0x3b, 0x32, 0x32, 0x34, 0x6d, 0x47, 0x1b, 0x5b, 0x30, 0x6d, 0x00, 0x00]
>>> s2 = ""
>>> for c in desired_output:
...     s2 += chr(c)
...
>>> print(s2)
cIMG
>>> s2
'\x1b[38;2;170;054;112mc\x1b[0m\x1b[38;2;161;129;204mI\x1b[0m\x1b[38;2;001;195;053mM\x1b[0m\x1b[38;2;064;046;224mG\x1b[0m\x00\x00'
```

Se fizermos esse payload aqui, obtemos `001;002;003` etc.
```python
# cimg_payload.py
import sys
import struct

width = 2
height = 2

# header has 8 bytes

payload = b""
payload += b"cIMG" # header[0] = 4 bytes
payload += struct.pack("<H", 2) # header[4] = version word
payload += struct.pack("<B", width) # header[6] = width byte
payload += struct.pack("<B", height) # header[7] = height byte
payload += b"\x01\x02\x03\x63"
payload += b"\x04\x05\x06\x49"
payload += b"\x07\x08\x09\x4d"
payload += b"\x0a\x0b\x0c\x47"

with open("payload.cimg", "wb") as f:
        f.write(payload)
#sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~internal-state-mini-c:~$ gdb /challenge/cimg
Reading symbols from /challenge/cimg...
(No debugging symbols found in /challenge/cimg)
(gdb) b *0x401437
Breakpoint 1 at 0x401437
(gdb) run ~/payload.cimg 
Starting program: /challenge/cimg ~/payload.cimg
cI
MG

Breakpoint 1, 0x0000000000401437 in main ()
(gdb) x/s $r14+$rdi
0x25ef22a0:     "\033[38;2;001;002;003mc\033[0m\033[38;2;004;005;006mI\033[0m\033[38;2;007;008;009mM\033[0m\033[38;2;010;011;012mG\033[0m"
(gdb) x/s $r12
0x404020 <desired_output>:      "\033[38;2;170;054;112mc\033[0m\033[38;2;161;129;204mI\033[0m\033[38;2;001;195;053mM\033[0m\033[38;2;064;046;224mG\033[0m"
```

Ou seja, nosso programa tem que ser exatamente isso aqui para corresponder ao `desired_output`:
```python
# cimg_payload.py
import sys
import struct

# width * height must be 4, but they can be 2 and 2 for example
width = 4
height = 1

desired_output = [0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x31, 0x37, 0x30, 0x3b, 0x30, 0x35, 0x34, 0x3b, 0x31, 0x31, 0x32, 0x6d, 0x63, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x31, 0x36, 0x31, 0x3b, 0x31, 0x32, 0x39, 0x3b, 0x32, 0x30, 0x34, 0x6d, 0x49, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x30, 0x30, 0x31, 0x3b, 0x31, 0x39, 0x35, 0x3b, 0x30, 0x35, 0x33, 0x6d, 0x4d, 0x1b, 0x5b, 0x30, 0x6d, 0x1b, 0x5b, 0x33, 0x38, 0x3b, 0x32, 0x3b, 0x30, 0x36, 0x34, 0x3b, 0x30, 0x34, 0x36, 0x3b, 0x32, 0x32, 0x34, 0x6d, 0x47, 0x1b, 0x5b, 0x30, 0x6d, 0x00, 0x00]
desired_output_str = "\033[38;2;170;054;112mc\033[0m\033[38;2;161;129;204mI\033[0m\033[38;2;001;195;053mM\033[0m\033[38;2;064;046;224mG\033[0m"

# header has 8 bytes

payload = b""
payload += b"cIMG" # header[0] = 4 bytes
payload += struct.pack("<H", 2) # header[4] = version word
payload += struct.pack("<B", width) # header[6] = width byte
payload += struct.pack("<B", height) # header[7] = height byte
payload += b"\xaa\x36\x70\x63"  # 170;054;112
payload += b"\xa1\x81\xcc\x49"  # 161;129;204
payload += b"\x01\xc3\x35\x4d"  # 001;195;053
payload += b"\x40\x2e\xe0\x47"  # 064;046;224

with open("payload.cimg", "wb") as f:
        f.write(payload)

sys.stdout.buffer.write(payload)
```

```
hacker@reverse-engineering~internal-state-mini-c:~$ vim cimg_payload.py 
hacker@reverse-engineering~internal-state-mini-c:~$ python3 cimg_payload.py 
hacker@reverse-engineering~internal-state-mini-c:~$ /challenge/cimg payload.cimg 
cIMG
pwn.college{IODwacnQffNO2UjsTv98ze6LbMP.0VOxUjNxwyMyITOyEzW}
```
