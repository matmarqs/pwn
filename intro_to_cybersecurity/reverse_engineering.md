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


