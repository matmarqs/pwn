# Assembly Crash Course

## set-register

```
hacker@assembly-crash-course~set-register:~$ nvim asm.s
```

```
.intel_syntax noprefix
.global _start

_start:
        mov rdi, 0x1337
```

```
hacker@assembly-crash-course~set-register:~$ cat assemble.sh
#!/bin/bash

as -o a.o "$1" && ld -o a.out a.o
hacker@assembly-crash-course~set-register:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~set-register:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.


In this level you will work with registers! Please set the following:
  rdi = 0x1337

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rdi, 0x1337
--------------------------------------
pwn.college{0_66XwNkRrBAA-mVkbmBei15I8w.dRTOxwyMyITOyEzW}
```

## set-multiple-registers

```
hacker@assembly-crash-course~set-multiple-registers:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, 0x1337
        mov r12, 0xCAFED00D1337BEEF
        mov rsp, 0x31337
hacker@assembly-crash-course~set-register:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~set-multiple-registers:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.


In this level you will work with multiple registers. Please set the following:
  rax = 0x1337
  r12 = 0xCAFED00D1337BEEF
  rsp = 0x31337

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, 0x1337
0x400007:       movabs  r12, 0xcafed00d1337beef
0x400011:       mov     rsp, 0x31337
--------------------------------------
pwn.college{IKnFDGHm7snKKGX7M_QUmkXInDC.QXwEDOzwyMyITOyEzW}
```

## add-to-register

```
hacker@assembly-crash-course~add-to-register:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        add rdi, 0x331337
hacker@assembly-crash-course~add-to-register:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~add-to-register:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.


Many instructions exist in x86 that allow you to do all the normal
math operations on registers and memory.

For shorthand, when we say A += B, it really means A = A + B.

Here are some useful instructions:
  add reg1, reg2       <=>     reg1 += reg2
  sub reg1, reg2       <=>     reg1 -= reg2
  imul reg1, reg2      <=>     reg1 *= reg2

div is more complicated and we will discuss it later.
Note: all 'regX' can be replaced by a constant or memory location

Do the following:
  add 0x331337 to rdi

We will now set the following in preparation for your code:
  rdi = 0x6a5

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       add     rdi, 0x331337
--------------------------------------
pwn.college{0VT17ie_b7rKfzl35xeE6ye44OC.dVTOxwyMyITOyEzW}
```

## linear-equation-registers

```
hacker@assembly-crash-course~linear-equation-registers:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        imul rdi, rsi
        add rdi, rdx
        mov rax, rdi
hacker@assembly-crash-course~linear-equation-registers:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~linear-equation-registers:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.


Using your new knowledge, please compute the following:
  f(x) = mx + b, where:
    m = rdi
    x = rsi
    b = rdx

Place the result into rax.

Note: there is an important difference between mul (unsigned
multiply) and imul (signed multiply) in terms of which
registers are used. Look at the documentation on these
instructions to see the difference.

In this case, you will want to use imul.

We will now set the following in preparation for your code:
  rdi = 0x87f
  rsi = 0x6d1
  rdx = 0x21db

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       imul    rdi, rsi
0x400004:       add     rdi, rdx
0x400007:       mov     rax, rdi
--------------------------------------
pwn.college{ogKaO5wJKAtrm8P-ZwmEDfN-kGi.dZTOxwyMyITOyEzW}
```

## integer-division

How does this complex div instruction work and operate on a 128-bit dividend (which is twice as large as a register)?

For the instruction `div reg`, the following happens:

```
rax = rdx:rax / reg
rdx = remainder
```

`rdx:rax` means that `rdx` will be the upper 64-bits of the 128-bit dividend and `rax` will be the lower 64-bits of the 128-bit dividend.

```
hacker@assembly-crash-course~integer-division:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rdx, 0
        mov rax, rdi
        div rsi
hacker@assembly-crash-course~integer-division:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~integer-division:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.


Division in x86 is more special than in normal math. Math in here is
called integer math. This means every value is a whole number.

As an example: 10 / 3 = 3 in integer math.

Why?

Because 3.33 is rounded down to an integer.

The relevant instructions for this level are:
  mov rax, reg1; div reg2

Note: div is a special instruction that can divide
a 128-bit dividend by a 64-bit divisor, while
storing both the quotient and the remainder, using only one register as an operand.

How does this complex div instruction work and operate on a
128-bit dividend (which is twice as large as a register)?

For the instruction: div reg, the following happens:
  rax = rdx:rax / reg
  rdx = remainder

rdx:rax means that rdx will be the upper 64-bits of
the 128-bit dividend and rax will be the lower 64-bits of the
128-bit dividend.

You must be careful about what is in rdx and rax before you call div.

Please compute the following:
  speed = distance / time, where:
    distance = rdi
    time = rsi
    speed = rax

Note that distance will be at most a 64-bit value, so rdx should be 0 when dividing.

We will now set the following in preparation for your code:
  rdi = 0x160b
  rsi = 0x42

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rdx, 0
0x400007:       mov     rax, rdi
0x40000a:       div     rsi
--------------------------------------
pwn.college{k6FZjU1IiU-fsunumFExdZt_cNI.ddTOxwyMyITOyEzW}
```

## modulo-operation

```
hacker@assembly-crash-course~modulo-operation:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rdx, 0
        mov rax, rdi
        div rsi
        mov rax, rdx
hacker@assembly-crash-course~modulo-operation:~$ nvim asm.s
hacker@assembly-crash-course~modulo-operation:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~modulo-operation:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.


Modulo in assembly is another interesting concept!

x86 allows you to get the remainder after a div operation.

For instance: 10 / 3 -> remainder = 1

The remainder is the same as modulo, which is also called the "mod" operator.

In most programming languages we refer to mod with the symbol '%'.

Please compute the following:
  rdi % rsi

Place the value in rax.

We will now set the following in preparation for your code:
  rdi = 0x28a4e1c8
  rsi = 0x7

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rdx, 0
0x400007:       mov     rax, rdi
0x40000a:       div     rsi
0x40000d:       mov     rax, rdx
--------------------------------------
pwn.college{M8ADB-X-wucMn2sLfKW-faMqRJl.dhTOxwyMyITOyEzW}
```

## set-upper-byte

```
hacker@assembly-crash-course~set-upper-byte:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov ah, 0x42
hacker@assembly-crash-course~set-upper-byte:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~set-upper-byte:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.


Another cool concept in x86 is the ability to independently access to lower register bytes.

Each register in x86_64 is 64 bits in size, and in the previous levels we have accessed
the full register using rax, rdi or rsi.

We can also access the lower bytes of each register using different register names.

For example the lower 32 bits of rax can be accessed using eax, the lower 16 bits using ax,
the lower 8 bits using al.

MSB                                    LSB
+----------------------------------------+
|                   rax                  |
+--------------------+-------------------+
                     |        eax        |
                     +---------+---------+
                               |   ax    |
                               +----+----+
                               | ah | al |
                               +----+----+

Lower register bytes access is applicable to almost all registers.

Using only one move instruction, please set the upper 8 bits of the ax register to 0x42.

We will now set the following in preparation for your code:
  rax = 0xcd101d7e8c2600fa

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     ah, 0x42
--------------------------------------
pwn.college{wOJ-nN0pp-hh9O6K281b004-cXY.QXxEDOzwyMyITOyEzW}
```

## efficient-modulo

```
hacker@assembly-crash-course~efficient-modulo:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov al, dil
        mov bx, si
hacker@assembly-crash-course~efficient-modulo:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~efficient-modulo:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.


It turns out that using the div operator to compute the modulo operation is slow!

We can use a math trick to optimize the modulo operator (%). Compilers use this trick a lot.

If we have "x % y", and y is a power of 2, such as 2^n, the result will be the lower n bits of x.

Therefore, we can use the lower register byte access to efficiently implement modulo!

Using only the following instruction(s):
  mov

Please compute the following:
  rax = rdi % 256
  rbx = rsi % 65536

We will now set the following in preparation for your code:
  rdi = 0xe359
  rsi = 0x3dfcd3aa

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     al, dil
0x400003:       mov     bx, si
--------------------------------------
pwn.college{8BaqFacIjutrZd0AXTNHBobIHDH.dlTOxwyMyITOyEzW}
```

## byte-extraction

```
hacker@assembly-crash-course~byte-extraction:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, rdi
        shl rax, 24
        shr rax, 56
hacker@assembly-crash-course~byte-extraction:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~byte-extraction:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with bit logic and operations. This will involve heavy use of
directly interacting with bits stored in a register or memory location. You will also likely
need to make use of the logic instructions in x86: and, or, not, xor.


Shifting bits around in assembly is another interesting concept!

x86 allows you to 'shift' bits around in a register.

Take, for instance, al, the lowest 8 bits of rax.

The value in al (in bits) is:
  rax = 10001010

If we shift once to the left using the shl instruction:
  shl al, 1

The new value is:
  al = 00010100

Everything shifted to the left and the highest bit fell off
while a new 0 was added to the right side.

You can use this to do special things to the bits you care about.

Shifting has the nice side affect of doing quick multiplication (by 2)
or division (by 2), and can also be used to compute modulo.

Here are the important instructions:
  shl reg1, reg2       <=>     Shift reg1 left by the amount in reg2
  shr reg1, reg2       <=>     Shift reg1 right by the amount in reg2
  Note: 'reg2' can be replaced by a constant or memory location

Using only the following instructions:
  mov, shr, shl

Please perform the following:
  Set rax to the 5th least significant byte of rdi.

For example:
  rdi = | B7 | B6 | B5 | B4 | B3 | B2 | B1 | B0 |
  Set rax to the value of B4

We will now set the following in preparation for your code:
  rdi = 0x576cae932b8f3a19

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, rdi
0x400003:       shl     rax, 0x18
0x400007:       shr     rax, 0x38
--------------------------------------
pwn.college{Uhy_6n8oIuKZLpZAvCrIJlL-ZSy.dBDMywyMyITOyEzW}
```

## bitwise-and

```
hacker@assembly-crash-course~bitwise-and:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        xor rax, rax
        not rax
        and rax, rdi
        and rax, rsi
hacker@assembly-crash-course~bitwise-and:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~bitwise-and:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with bit logic and operations. This will involve heavy use of
directly interacting with bits stored in a register or memory location. You will also likely
need to make use of the logic instructions in x86: and, or, not, xor.


Bitwise logic in assembly is yet another interesting concept!
x86 allows you to perform logic operations bit by bit on registers.

For the sake of this example say registers only store 8 bits.

The values in rax and rbx are:
  rax = 10101010
  rbx = 00110011

If we were to perform a bitwise AND of rax and rbx using the
"and rax, rbx" instruction, the result would be calculated by
ANDing each bit pair 1 by 1 hence why it's called a bitwise
logic.

So from left to right:
  1 AND 0 = 0
  0 AND 0 = 0
  1 AND 1 = 1
  0 AND 1 = 0
  ...

Finally we combine the results together to get:
  rax = 00100010

Here are some truth tables for reference:
      AND          OR           XOR
   A | B | X    A | B | X    A | B | X
  ---+---+---  ---+---+---  ---+---+---
   0 | 0 | 0    0 | 0 | 0    0 | 0 | 0
   0 | 1 | 0    0 | 1 | 1    0 | 1 | 1
   1 | 0 | 0    1 | 0 | 1    1 | 0 | 1
   1 | 1 | 1    1 | 1 | 1    1 | 1 | 0

Without using the following instructions:
  mov, xchg

Please perform the following:
  rax = rdi AND rsi

i.e. Set rax to the value of (rdi AND rsi)

We will now set the following in preparation for your code:
  rdi = 0x9325f085e1e83965
  rsi = 0x62bdfd4d4a07a731

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       xor     rax, rax
0x400003:       not     rax
0x400006:       and     rax, rdi
0x400009:       and     rax, rsi
--------------------------------------
pwn.college{kQsBrabnoYsP9SEl2O3-JqdCuC1.dFDMywyMyITOyEzW}
```

## check-even

```
hacker@assembly-crash-course~check-even:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        xor rax, rax    # zerando rax
        xor rax, 1      # rax = 1
        xor rax, rdi    # LSbit of rax = 1 if rdi is even, LSbit rax = 0 if rdi is odd
        and rax, 1      # get LSbit only
hacker@assembly-crash-course~check-even:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~check-even:~$ /challenge/run a.out

In this level you will be working with registers. You will be asked to modify
or read from registers.

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with bit logic and operations. This will involve heavy use of
directly interacting with bits stored in a register or memory location. You will also likely
need to make use of the logic instructions in x86: and, or, not, xor.


Using only the following instructions:
  and, or, xor

Implement the following logic:
  if x is even then
    y = 1
  else
    y = 0

where:
  x = rdi
  y = rax

We will now set the following in preparation for your code:
  rdi = 0x1864d58d

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       xor     rax, rax
0x400003:       xor     rax, 1
0x400007:       xor     rax, rdi
0x40000a:       and     rax, 1
--------------------------------------
pwn.college{gAlqVLEfTXae4I-ukEnt4aUUVF7.dJDMywyMyITOyEzW}
```

## memory-read

```
hacker@assembly-crash-course~memory-read:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, [0x404000]
hacker@assembly-crash-course~memory-read:~$ cat assemble.sh
#!/bin/bash

as -o a.o "$1" && ld -o a.out a.o
hacker@assembly-crash-course~memory-read:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~memory-read:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


Up until now you have worked with registers as the only way for storing things, essentially
variables such as 'x' in math.

However, we can also store bytes into memory!

Recall that memory can be addressed, and each address contains something at that location.

Note that this is similar to addresses in real life!

As an example: the real address '699 S Mill Ave, Tempe, AZ
85281' maps to the 'ASU Brickyard'.

We would also say it points to 'ASU Brickyard'.

We can represent this like:
  ['699 S Mill Ave, Tempe, AZ 85281'] = 'ASU Brickyard'

The address is special because it is unique.

But that also does not mean other addresses can't point to the same thing (as someone can have multiple houses).

Memory is exactly the same!

For instance, the address in memory that your code is stored (when we take it from you) is 0x400000.

In x86 we can access the thing at a memory location, called dereferencing, like so:
  mov rax, [some_address]        <=>     Moves the thing at 'some_address' into rax

This also works with things in registers:
  mov rax, [rdi]         <=>     Moves the thing stored at the address of what rdi holds to rax

This works the same for writing to memory:
  mov [rax], rdi         <=>     Moves rdi to the address of what rax holds.

So if rax was 0xdeadbeef, then rdi would get stored at the address 0xdeadbeef:
  [0xdeadbeef] = rdi

Note: memory is linear, and in x86_64, it goes from 0 - 0xffffffffffffffff (yes, huge).

Please perform the following:
  Place the value stored at 0x404000 into rax

Make sure the value in rax is the original value stored at 0x404000.

We will now set the following in preparation for your code:
  [0x404000] = 0x10480c

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, qword ptr [0x404000]
--------------------------------------
pwn.college{Uq_2S-qR9no2AiibK7NSs_DHdmi.QXyEDOzwyMyITOyEzW}
```

## memory-write

```
hacker@assembly-crash-course~memory-write:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov [0x404000], rax
hacker@assembly-crash-course~memory-write:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~memory-write:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


Please perform the following:
  Place the value stored in rax to 0x404000

We will now set the following in preparation for your code:
  rax = 0x1e4365

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     qword ptr [0x404000], rax
--------------------------------------
pwn.college{8bIxaUv6YwViTJvpnRgcRHaRm7C.QXzEDOzwyMyITOyEzW}
```

## memory-increment

```
hacker@assembly-crash-course~memory-increment:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, [0x404000]
        mov rbx, rax
        add rax, 0x1337
        mov [0x404000], rax
        mov rax, rbx
hacker@assembly-crash-course~memory-increment:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~memory-increment:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


Please perform the following:
  Place the value stored at 0x404000 into rax
  Increment the value stored at the address 0x404000 by 0x1337

Make sure the value in rax is the original value stored at 0x404000 and make sure
that [0x404000] now has the incremented value.

We will now set the following in preparation for your code:
  [0x404000] = 0x13ca39

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, qword ptr [0x404000]
0x400008:       mov     rbx, rax
0x40000b:       add     rax, 0x1337
0x400011:       mov     qword ptr [0x404000], rax
0x400019:       mov     rax, rbx
--------------------------------------
pwn.college{0pKuLBxOnCP-rodh3E0ceGvuQ1u.dNDMywyMyITOyEzW}
```

## byte-access

```
hacker@assembly-crash-course~byte-access:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        xor rax, rax
        mov al, [0x404000]
hacker@assembly-crash-course~byte-access:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~byte-access:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


Recall that registers in x86_64 are 64 bits wide, meaning they can store 64 bits.

Similarly, each memory location can be treated as a 64 bit value.

We refer to something that is 64 bits (8 bytes) as a quad word.

Here is the breakdown of the names of memory sizes:
  Quad Word   = 8 Bytes = 64 bits
  Double Word = 4 bytes = 32 bits
  Word        = 2 bytes = 16 bits
  Byte        = 1 byte  = 8 bits

In x86_64, you can access each of these sizes when dereferencing an address, just like using
bigger or smaller register accesses:
  mov al, [address]        <=>        moves the least significant byte from address to rax
  mov ax, [address]        <=>        moves the least significant word from address to rax
  mov eax, [address]       <=>        moves the least significant double word from address to rax
  mov rax, [address]       <=>        moves the full quad word from address to rax

Remember that moving into al does not fully clear the upper bytes.

Please perform the following:
  Set rax to the byte at 0x404000

We will now set the following in preparation for your code:
  [0x404000] = 0x1bcdb8

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       xor     rax, rax
0x400003:       mov     al, byte ptr [0x404000]
--------------------------------------
pwn.college{0N2UrJ9ukYMLCAB6io_lyMwUymW.QX0EDOzwyMyITOyEzW}
```

## memory-size-access

```
hacker@assembly-crash-course~memory-size-access:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        xor rax, rax
        xor rbx, rbx
        xor rcx, rcx
        xor rdx, rdx
        mov al, [0x404000]
        mov bx, [0x404000]
        mov ecx, [0x404000]
        mov rdx, [0x404000]
hacker@assembly-crash-course~memory-size-access:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~memory-size-access:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


Recall the following:
  The breakdown of the names of memory sizes:
    Quad Word   = 8 Bytes = 64 bits
    Double Word = 4 bytes = 32 bits
    Word        = 2 bytes = 16 bits
    Byte        = 1 byte  = 8 bits

In x86_64, you can access each of these sizes when dereferencing an address, just like using
bigger or smaller register accesses:
  mov al, [address]        <=>        moves the least significant byte from address to rax
  mov ax, [address]        <=>        moves the least significant word from address to rax
  mov eax, [address]       <=>        moves the least significant double word from address to rax
  mov rax, [address]       <=>        moves the full quad word from address to rax

Please perform the following:
  Set rax to the byte at 0x404000
  Set rbx to the word at 0x404000
  Set rcx to the double word at 0x404000
  Set rdx to the quad word at 0x404000

We will now set the following in preparation for your code:
  [0x404000] = 0x8d79d7344d19f96d

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       xor     rax, rax
0x400003:       xor     rbx, rbx
0x400006:       xor     rcx, rcx
0x400009:       xor     rdx, rdx
0x40000c:       mov     al, byte ptr [0x404000]
0x400013:       mov     bx, word ptr [0x404000]
0x40001b:       mov     ecx, dword ptr [0x404000]
0x400022:       mov     rdx, qword ptr [0x404000]
--------------------------------------
pwn.college{IX5t6o2XveOPut2pUKumFmhP6gE.dRDMywyMyITOyEzW}
```

## little-endian-write

```
hacker@assembly-crash-course~little-endian-write:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, 0xdeadbeef00001337
        mov [rdi], rax
        mov rax, 0xc0ffee0000
        mov [rsi], rax
hacker@assembly-crash-course~little-endian-write:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~little-endian-write:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


It is worth noting, as you may have noticed, that values are stored in reverse order of how we
represent them.

As an example, say:
  [0x1330] = 0x00000000deadc0de

If you examined how it actually looked in memory, you would see:
  [0x1330] = 0xde
  [0x1331] = 0xc0
  [0x1332] = 0xad
  [0x1333] = 0xde
  [0x1334] = 0x00
  [0x1335] = 0x00
  [0x1336] = 0x00
  [0x1337] = 0x00

This format of storing things in 'reverse' is intentional in x86, and its called "Little Endian".

For this challenge we will give you two addresses created dynamically each run.

The first address will be placed in rdi.
The second will be placed in rsi.

Using the earlier mentioned info, perform the following:
  Set [rdi] = 0xdeadbeef00001337
  Set [rsi] = 0xc0ffee0000

Hint: it may require some tricks to assign a big constant to a dereferenced register.
Try setting a register to the constant value then assigning that register to the dereferenced register.

We will now set the following in preparation for your code:
  [0x404568] = 0xffffffffffffffff
  [0x4048d8] = 0xffffffffffffffff
  rdi = 0x404568
  rsi = 0x4048d8

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       movabs  rax, 0xdeadbeef00001337
0x40000a:       mov     qword ptr [rdi], rax
0x40000d:       movabs  rax, 0xc0ffee0000
0x400017:       mov     qword ptr [rsi], rax
--------------------------------------
pwn.college{g0DtF-NXul1I9371S_I_mk6Opwz.dVDMywyMyITOyEzW}
```

## memory-sum

```
hacker@assembly-crash-course~memory-sum:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, [rdi]
        mov rbx, [rdi+8]
        add rax, rbx
        mov [rsi], rax
hacker@assembly-crash-course~memory-sum:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~memory-sum:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with memory. This will require you to read or write
to things stored linearly in memory. If you are confused, go look at the linear
addressing module in 'ike. You may also be asked to dereference things, possibly multiple
times, to things we dynamically put in memory for your use.


Recall that memory is stored linearly.

What does that mean?

Say we access the quad word at 0x1337:
  [0x1337] = 0x00000000deadbeef

The real way memory is layed out is byte by byte, little endian:
  [0x1337] = 0xef
  [0x1337 + 1] = 0xbe
  [0x1337 + 2] = 0xad
  ...
  [0x1337 + 7] = 0x00

What does this do for us?

Well, it means that we can access things next to each other using offsets,
similar to what was shown above.

Say you want the 5th *byte* from an address, you can access it like:
  mov al, [address+4]

Remember, offsets start at 0.

Perform the following:
  Load two consecutive quad words from the address stored in rdi
  Calculate the sum of the previous steps quad words.
  Store the sum at the address in rsi

We will now set the following in preparation for your code:
  [0x4042c8] = 0xbd813
  [0x4042d0] = 0x4ecd9
  rdi = 0x4042c8
  rsi = 0x404688

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, qword ptr [rdi]
0x400003:       mov     rbx, qword ptr [rdi + 8]
0x400007:       add     rax, rbx
0x40000a:       mov     qword ptr [rsi], rax
--------------------------------------
pwn.college{00g8np4n32_flCy6AS7H6wUly4e.dZDMywyMyITOyEzW}
```

## stack-subtraction

```
hacker@assembly-crash-course~stack-subtraction:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        pop rax
        sub rax, rdi
        push rax
hacker@assembly-crash-course~stack-subtraction:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~stack-subtraction:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with the stack, the memory region that dynamically expands
and shrinks. You will be required to read and write to the stack, which may require you to use
the pop and push instructions. You may also need to use the stack pointer register (rsp) to know
where the stack is pointing.


In these levels we are going to introduce the stack.

The stack is a region of memory that can store values for later.

To store a value on the stack we use the push instruction, and to retrieve a value we use pop.

The stack is a last in first out (LIFO) memory structure, and this means
the last value pushed in the first value popped.

Imagine unloading plates from the dishwasher let's say there are 1 red, 1 green, and 1 blue.
First we place the red one in the cabinet, then the green on top of the red, then the blue.

Our stack of plates would look like:
  Top ----> Blue
            Green
  Bottom -> Red

Now, if we wanted a plate to make a sandwich we would retrieve the top plate from the stack
which would be the blue one that was last into the cabinet, ergo the first one out.

On x86, the pop instruction will take the value from the top of the stack and put it into a register.

Similarly, the push instruction will take the value in a register and push it onto the top of the stack.

Using these instructions, take the top value of the stack, subtract rdi from it, then put it back.

We will now set the following in preparation for your code:
  rdi = 0x1507b
  (stack) [0x7fffff1ffff8] = 0x2bb6d555

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       pop     rax
0x400001:       sub     rax, rdi
0x400004:       push    rax
--------------------------------------
pwn.college{QDGWsX7KE544BT2NPi-GCSNfkSu.ddDMywyMyITOyEzW}
```


## swap-stack-values

```
hacker@assembly-crash-course~swap-stack-values:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        push rdi
        push rsi
        pop rdi
        pop rsi
hacker@assembly-crash-course~swap-stack-values:~$ ./assemble.sh asm.s
hacker@assembly-crash-course~swap-stack-values:~$ /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with the stack, the memory region that dynamically expands
and shrinks. You will be required to read and write to the stack, which may require you to use
the pop and push instructions. You may also need to use the stack pointer register (rsp) to know
where the stack is pointing.


In this level we are going to explore the last in first out (LIFO) property of the stack.

Using only following instructions:
  push, pop

Swap values in rdi and rsi.
i.e.
If to start rdi = 2 and rsi = 5
Then to end rdi = 5 and rsi = 2

We will now set the following in preparation for your code:
  rdi = 0x3237909a
  rsi = 0x8dafde1

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       push    rdi
0x400001:       push    rsi
0x400002:       pop     rdi
0x400003:       pop     rsi
--------------------------------------
pwn.college{8lx7s979tkB4IBjEXjP0jjBXfQ7.dhDMywyMyITOyEzW}
```


## average-stack-values

```
hacker@assembly-crash-course~average-stack-values:~$ cat asm.s
.intel_syntax noprefix
.global _start

_start:
        mov rax, [rsp]
        mov rbx, [rsp+0x8]
        mov rcx, [rsp+0x10]
        mov rdx, [rsp+0x18]
        add rax, rbx
        add rcx, rdx
        add rax, rcx
        shr rax, 2
        push rax
hacker@assembly-crash-course~average-stack-values:~$ ./assemble.sh asm.s && /challenge/run a.out

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with the stack, the memory region that dynamically expands
and shrinks. You will be required to read and write to the stack, which may require you to use
the pop and push instructions. You may also need to use the stack pointer register (rsp) to know
where the stack is pointing.


In the previous levels you used push and pop to store and load data from the stack.

However you can also access the stack directly using the stack pointer.

On x86, the stack pointer is stored in the special register, rsp.
rsp always stores the memory address of the top of the stack,
i.e. the memory address of the last value pushed.

Similar to the memory levels, we can use [rsp] to access the value at the memory address in rsp.

Without using pop, please calculate the average of 4 consecutive quad words stored on the stack.

Push the average on the stack.

Hint:
  RSP+0x?? Quad Word A
  RSP+0x?? Quad Word B
  RSP+0x?? Quad Word C
  RSP      Quad Word D

We will now set the following in preparation for your code:
  (stack) [0x7fffff200000:0x7fffff1fffe0] = ['0x1fc7c98d', '0x544f441', '0x18a9d68e', '0xcbc0efc'] (list of things)

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, qword ptr [rsp]
0x400004:       mov     rbx, qword ptr [rsp + 8]
0x400009:       mov     rcx, qword ptr [rsp + 0x10]
0x40000e:       mov     rdx, qword ptr [rsp + 0x18]
0x400013:       add     rax, rbx
0x400016:       add     rcx, rdx
0x400019:       add     rax, rcx
0x40001c:       shr     rax, 2
0x400020:       push    rax
--------------------------------------
pwn.college{Y3mmTjXMJrwa7C7H5D1URD8_4Py.dlDMywyMyITOyEzW}
```

## absolute-jump

```
hacker@assembly-crash-course~absolute-jump:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        mov rax, 0x403000
        jmp rax

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.


Earlier, you learned how to manipulate data in a pseudo-control way, but x86 gives us actual
instructions to manipulate control flow directly.

There are two major ways to manipulate control flow:
 through a jump;
 through a call.

In this level, you will work with jumps.

There are two types of jumps:
  Unconditional jumps
  Conditional jumps

Unconditional jumps always trigger and are not based on the results of earlier instructions.

As you know, memory locations can store data and instructions.

Your code will be stored at 0x400031 (this will change each run).

For all jumps, there are three types:
  Relative jumps: jump + or - the next instruction.
  Absolute jumps: jump to a specific address.
  Indirect jumps: jump to the memory address specified in a register.

In x86, absolute jumps (jump to a specific address) are accomplished by first putting the target address in a register reg, then doing jmp reg.

In this level we will ask you to do an absolute jump.

Perform the following:
  Jump to the absolute address 0x403000

We will now set the following in preparation for your code:
  Loading your given code at: 0x400031

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400031:       mov     rax, 0x403000
0x400038:       jmp     rax
--------------------------------------
pwn.college{UtEBjkyC1EksQZg8qX_cylRIQfA.QX1EDOzwyMyITOyEzW}
```

## relative-jump

```
hacker@assembly-crash-course~relative-jump:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        jmp label
        .rept 0x51
        nop
        .endr

label:
        mov rax, 0x1

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.


Recall that for all jumps, there are three types:
  Relative jumps
  Absolute jumps
  Indirect jumps

In this level we will ask you to do a relative jump.

You will need to fill space in your code with something to make this relative jump possible.

We suggest using the `nop` instruction. It's 1 byte long and very predictable.

In fact, the as assembler that we're using has a handy .rept directive that you can use to
repeat assembly instructions some number of times:
  https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html

Useful instructions for this level:
  jmp (reg1 | addr | offset) ; nop

Hint: for the relative jump, lookup how to use `labels` in x86.

Using the above knowledge, perform the following:
  Make the first instruction in your code a jmp
  Make that jmp a relative jump to 0x51 bytes from the current position
  At the code location where the relative jump will redirect control flow set rax to 0x1

We will now set the following in preparation for your code:
  Loading your given code at: 0x4000ac

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x4000ac:       jmp     0x4000ff
0x4000ae:       nop
0x4000af:       nop
0x4000b0:       nop
0x4000b1:       nop
0x4000b2:       nop
0x4000b3:       nop
0x4000b4:       nop
0x4000b5:       nop
0x4000b6:       nop
0x4000b7:       nop
0x4000b8:       nop
0x4000b9:       nop
0x4000ba:       nop
0x4000bb:       nop
0x4000bc:       nop
0x4000bd:       nop
0x4000be:       nop
0x4000bf:       nop
0x4000c0:       nop
0x4000c1:       nop
0x4000c2:       nop
0x4000c3:       nop
0x4000c4:       nop
0x4000c5:       nop
0x4000c6:       nop
0x4000c7:       nop
0x4000c8:       nop
0x4000c9:       nop
0x4000ca:       nop
0x4000cb:       nop
0x4000cc:       nop
0x4000cd:       nop
0x4000ce:       nop
0x4000cf:       nop
0x4000d0:       nop
0x4000d1:       nop
0x4000d2:       nop
0x4000d3:       nop
0x4000d4:       nop
0x4000d5:       nop
0x4000d6:       nop
0x4000d7:       nop
0x4000d8:       nop
0x4000d9:       nop
0x4000da:       nop
0x4000db:       nop
0x4000dc:       nop
0x4000dd:       nop
0x4000de:       nop
0x4000df:       nop
0x4000e0:       nop
0x4000e1:       nop
0x4000e2:       nop
0x4000e3:       nop
0x4000e4:       nop
0x4000e5:       nop
0x4000e6:       nop
0x4000e7:       nop
0x4000e8:       nop
0x4000e9:       nop
0x4000ea:       nop
0x4000eb:       nop
0x4000ec:       nop
0x4000ed:       nop
0x4000ee:       nop
0x4000ef:       nop
0x4000f0:       nop
0x4000f1:       nop
0x4000f2:       nop
0x4000f3:       nop
0x4000f4:       nop
0x4000f5:       nop
0x4000f6:       nop
0x4000f7:       nop
0x4000f8:       nop
0x4000f9:       nop
0x4000fa:       nop
0x4000fb:       nop
0x4000fc:       nop
0x4000fd:       nop
0x4000fe:       nop
0x4000ff:       mov     rax, 1
--------------------------------------
pwn.college{wERu1WdVXa8SYCvPBoFIU5QJmME.QX2EDOzwyMyITOyEzW}
```

## jump-trampoline

```
hacker@assembly-crash-course~jump-trampoline:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        jmp label
        .rept 0x51
        nop
        .endr

label:
        mov rdi, [rsp]
        mov rax, 0x403000
        jmp rax

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.


Now, we will combine the two prior levels and perform the following:
  Create a two jump trampoline:
    Make the first instruction in your code a jmp
    Make that jmp a relative jump to 0x51 bytes from its current position
    At 0x51 write the following code:
      Place the top value on the stack into register rdi
      jmp to the absolute address 0x403000

We will now set the following in preparation for your code:
  Loading your given code at: 0x400019
  (stack) [0x7fffff1ffff8] = 0xb4

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400019:       jmp     0x40006c
0x40001b:       nop
0x40001c:       nop
0x40001d:       nop
0x40001e:       nop
0x40001f:       nop
0x400020:       nop
0x400021:       nop
0x400022:       nop
0x400023:       nop
0x400024:       nop
0x400025:       nop
0x400026:       nop
0x400027:       nop
0x400028:       nop
0x400029:       nop
0x40002a:       nop
0x40002b:       nop
0x40002c:       nop
0x40002d:       nop
0x40002e:       nop
0x40002f:       nop
0x400030:       nop
0x400031:       nop
0x400032:       nop
0x400033:       nop
0x400034:       nop
0x400035:       nop
0x400036:       nop
0x400037:       nop
0x400038:       nop
0x400039:       nop
0x40003a:       nop
0x40003b:       nop
0x40003c:       nop
0x40003d:       nop
0x40003e:       nop
0x40003f:       nop
0x400040:       nop
0x400041:       nop
0x400042:       nop
0x400043:       nop
0x400044:       nop
0x400045:       nop
0x400046:       nop
0x400047:       nop
0x400048:       nop
0x400049:       nop
0x40004a:       nop
0x40004b:       nop
0x40004c:       nop
0x40004d:       nop
0x40004e:       nop
0x40004f:       nop
0x400050:       nop
0x400051:       nop
0x400052:       nop
0x400053:       nop
0x400054:       nop
0x400055:       nop
0x400056:       nop
0x400057:       nop
0x400058:       nop
0x400059:       nop
0x40005a:       nop
0x40005b:       nop
0x40005c:       nop
0x40005d:       nop
0x40005e:       nop
0x40005f:       nop
0x400060:       nop
0x400061:       nop
0x400062:       nop
0x400063:       nop
0x400064:       nop
0x400065:       nop
0x400066:       nop
0x400067:       nop
0x400068:       nop
0x400069:       nop
0x40006a:       nop
0x40006b:       nop
0x40006c:       mov     rdi, qword ptr [rsp]
0x400070:       mov     rax, 0x403000
0x400077:       jmp     rax
--------------------------------------
pwn.college{sUx-Nci-srMx1S5CpyLdmiZiUOy.dBTMywyMyITOyEzW}
```

## conditional-jump

```
hacker@assembly-crash-course~conditional-jump:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        mov ebx, [rdi]
        cmp ebx, 0x7f454c46
        je if_label
        cmp ebx, 0x00005a4d
        je elseif_label
        jmp else_label

if_label:
        mov eax, [rdi+4]
        add eax, [rdi+8]
        add eax, [rdi+12]
        jmp done

elseif_label:
        mov eax, [rdi+4]
        sub eax, [rdi+8]
        sub eax, [rdi+12]
        jmp done

else_label:
        mov eax, [rdi+4]
        imul eax, [rdi+8]
        imul eax, [rdi+12]

done:
        nop

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.

We will be testing your code multiple times in this level with dynamic values! This means we will
be running your code in a variety of random ways to verify that the logic is robust enough to
survive normal use.


We will now introduce you to conditional jumps--one of the most valuable instructions in x86.
In higher level programming languages, an if-else structure exists to do things like:
  if x is even:
    is_even = 1
  else:
   is_even = 0

This should look familiar, since it is implementable in only bit-logic, which you've done in a prior level.

In these structures, we can control the program's control flow based on dynamic values provided to the program.

Implementing the above logic with jmps can be done like so:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; assume rdi = x, rax is output
; rdx = rdi mod 2
mov rax, rdi
mov rsi, 2
div rsi
; remainder is 0 if even
cmp rdx, 0
; jump to not_even code is its not 0
jne not_even
; fall through to even code
mov rbx, 1
jmp done
; jump to this only when not_even
not_even:
mov rbx, 0
done:
mov rax, rbx
; more instructions here
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Often though, you want more than just a single 'if-else'.

Sometimes you want two if checks, followed by an else.

To do this, you need to make sure that you have control flow that 'falls-through' to the next `if` after it fails.

All must jump to the same `done` after execution to avoid the else.

There are many jump types in x86, it will help to learn how they can be used.

Nearly all of them rely on something called the ZF, the Zero Flag.

The ZF is set to 1 when a cmp is equal. 0 otherwise.

Using the above knowledge, implement the following:
  if [x] is 0x7f454c46:
    y = [x+4] + [x+8] + [x+12]
  else if [x] is 0x00005A4D:
    y = [x+4] - [x+8] - [x+12]
  else:
    y = [x+4] * [x+8] * [x+12]

where:
  x = rdi, y = rax.

Assume each dereferenced value is a signed dword.
This means the values can start as a negative value at each memory position.

A valid solution will use the following at least once:
  jmp (any variant), cmp

We will now run multiple tests on your code, here is an example run:
  (data) [0x404000] = {4 random dwords]}
  rdi = 0x404000

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     ebx, dword ptr [rdi]
0x400002:       cmp     ebx, 0x7f454c46
0x400008:       je      0x400014
0x40000a:       cmp     ebx, 0x5a4d
0x400010:       je      0x40001f
0x400012:       jmp     0x40002a
0x400014:       mov     eax, dword ptr [rdi + 4]
0x400017:       add     eax, dword ptr [rdi + 8]
0x40001a:       add     eax, dword ptr [rdi + 0xc]
0x40001d:       jmp     0x400035
0x40001f:       mov     eax, dword ptr [rdi + 4]
0x400022:       sub     eax, dword ptr [rdi + 8]
0x400025:       sub     eax, dword ptr [rdi + 0xc]
0x400028:       jmp     0x400035
0x40002a:       mov     eax, dword ptr [rdi + 4]
0x40002d:       imul    eax, dword ptr [rdi + 8]
0x400031:       imul    eax, dword ptr [rdi + 0xc]
0x400035:       nop
--------------------------------------
pwn.college{M96E3yIksvzIej-gnVAu48tAfYY.dFTMywyMyITOyEzW}
```

# indirect-jump

```
hacker@assembly-crash-course~indirect-jump:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        cmp rdi, 3
        ja default
        jmp [rsi + rdi*8]
default:
        jmp [rsi + 32]

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.

We will be testing your code multiple times in this level with dynamic values! This means we will
be running your code in a variety of random ways to verify that the logic is robust enough to
survive normal use.


The last jump type is the indirect jump, which is often used for switch statements in the real world.

Switch statements are a special case of if-statements that use only numbers to determine where the control flow will go.

Here is an example:
  switch(number):
    0: jmp do_thing_0
    1: jmp do_thing_1
    2: jmp do_thing_2
    default: jmp do_default_thing

The switch in this example is working on `number`, which can either be 0, 1, or 2.

In the case that `number` is not one of those numbers, the default triggers.

You can consider this a reduced else-if type structure.

In x86, you are already used to using numbers, so it should be no suprise that you can make if statements based on something being an exact number.

In addition, if you know the range of the numbers, a switch statement works very well.

Take for instance the existence of a jump table.

A jump table is a contiguous section of memory that holds addresses of places to jump.

In the above example, the jump table could look like:
  [0x1337] = address of do_thing_0
  [0x1337+0x8] = address of do_thing_1
  [0x1337+0x10] = address of do_thing_2
  [0x1337+0x18] = address of do_default_thing

Using the jump table, we can greatly reduce the amount of cmps we use.

Now all we need to check is if `number` is greater than 2.

If it is, always do:
  jmp [0x1337+0x18]
Otherwise:
  jmp [jump_table_address + number * 8]

Using the above knowledge, implement the following logic:
  if rdi is 0:
    jmp 0x403028
  else if rdi is 1:
    jmp 0x40310a
  else if rdi is 2:
    jmp 0x403194
  else if rdi is 3:
    jmp 0x40328e
  else:
    jmp 0x403342

Please do the above with the following constraints:
  Assume rdi will NOT be negative
  Use no more than 1 cmp instruction
  Use no more than 3 jumps (of any variant)
  We will provide you with the number to 'switch' on in rdi.
  We will provide you with a jump table base address in rsi.

Here is an example table:
  [0x404098] = 0x403028 (addrs will change)
  [0x4040a0] = 0x40310a
  [0x4040a8] = 0x403194
  [0x4040b0] = 0x40328e
  [0x4040b8] = 0x403342

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       cmp     rdi, 3
0x400004:       ja      0x400009
0x400006:       jmp     qword ptr [rsi + rdi*8]
0x400009:       jmp     qword ptr [rsi + 0x20]
--------------------------------------
Completed test 10
Completed test 20
Completed test 30
Completed test 40
Completed test 50
Completed test 60
Completed test 70
Completed test 80
Completed test 90
Completed test 100
pwn.college{QDmG0PoHJfGFpshbOEcSqVFaPqP.dJTMywyMyITOyEzW}
```

## average-loop

```
hacker@assembly-crash-course~average-loop:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        mov rax, 0
        mov rcx, 0
loop_start:
        cmp rcx, rsi
        je loop_end
        add rax, [rdi+8*rcx]
        inc rcx
        jmp loop_start
loop_end:
        mov rdx, 0
        div rsi

We will now set some values in memory dynamically before each run. On each run
the values will change. This means you will need to do some type of formulaic
operation with registers. We will tell you which registers are set beforehand
and where you should put the result. In most cases, its rax.

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.


In a previous level you computed the average of 4 integer quad words, which
was a fixed amount of things to compute, but how do you work with sizes you get when
the program is running?

In most programming languages a structure exists called the
for-loop, which allows you to do a set of instructions for a bounded amount of times.
The bounded amount can be either known before or during the programs run, during meaning
the value is given to you dynamically.

As an example, a for-loop can be used to compute the sum of the numbers 1 to n:
  sum = 0
  i = 1
  while i <= n:
    sum += i
    i += 1

Please compute the average of n consecutive quad words, where:
  rdi = memory address of the 1st quad word
  rsi = n (amount to loop for)
  rax = average computed

We will now set the following in preparation for your code:
  [0x4042f8:0x404588] = {n qwords]}
  rdi = 0x4042f8
  rsi = 82

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, 0
0x400007:       mov     rcx, 0
0x40000e:       cmp     rcx, rsi
0x400011:       je      0x40001c
0x400013:       add     rax, qword ptr [rdi + rcx*8]
0x400017:       inc     rcx
0x40001a:       jmp     0x40000e
0x40001c:       mov     rdx, 0
0x400023:       div     rsi
--------------------------------------
pwn.college{AFun7RZ9F9TounEg8IWQwikYKxC.dNTMywyMyITOyEzW}
```

## count-non-zero

```
hacker@assembly-crash-course~count-non-zero:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global _start

_start:
        mov rax, 0
        cmp rdi, 0
        je end
loop_start:
        mov rbx, [rdi+rax]
        cmp rbx, 0
        je end
        inc rax
        jmp loop_start
end:
        nop

In this level you will be working with control flow manipulation. This involves using instructions
to both indirectly and directly control the special register `rip`, the instruction pointer.
You will use instructions such as: jmp, call, cmp, and their alternatives to implement the requested behavior.

We will be testing your code multiple times in this level with dynamic values! This means we will
be running your code in a variety of random ways to verify that the logic is robust enough to
survive normal use.


In previous levels you discovered the for-loop to iterate for a *number* of times, both dynamically and
statically known, but what happens when you want to iterate until you meet a condition?

A second loop structure exists called the while-loop to fill this demand.

In the while-loop you iterate until a condition is met.

As an example, say we had a location in memory with adjacent numbers and we wanted
to get the average of all the numbers until we find one bigger or equal to 0xff:
  average = 0
  i = 0
  while x[i] < 0xff:
    average += x[i]
    i += 1
  average /= i

Using the above knowledge, please perform the following:
  Count the consecutive non-zero bytes in a contiguous region of memory, where:
    rdi = memory address of the 1st byte
    rax = number of consecutive non-zero bytes

Additionally, if rdi = 0, then set rax = 0 (we will check)!

An example test-case, let:
  rdi = 0x1000
  [0x1000] = 0x41
  [0x1001] = 0x42
  [0x1002] = 0x43
  [0x1003] = 0x00

then: rax = 3 should be set

We will now run multiple tests on your code, here is an example run:
  (data) [0x404000] = {10 random bytes},
  rdi = 0x404000

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       mov     rax, 0
0x400007:       cmp     rdi, 0
0x40000b:       je      0x40001c
0x40000d:       mov     rbx, qword ptr [rdi + rax]
0x400011:       cmp     rbx, 0
0x400015:       je      0x40001c
0x400017:       inc     rax
0x40001a:       jmp     0x40000d
0x40001c:       nop
--------------------------------------
pwn.college{A3U6aEJVyUo3W-nR4hhVYCb3WwH.dRTMywyMyITOyEzW}
```

## string-lower

```
hacker@assembly-crash-course~string-lower:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global str_lower

str_lower:
        xor rcx, rcx    # rcx = i = 0
        cmp rdi, 0      # if src_addr == 0 return
        je .return
.loop:
        mov dl, BYTE PTR [rdi]
        cmp dl, 0       # while [src_addr] != 0
        je .return
        cmp dl, 0x5a
        ja .skip
        # if [src_addr] <= 0x5a
        push rcx
        push rdi
        movzx rdi, dl
        mov rbx, 0x403000
        call rbx        # foo([src_addr])
        pop rdi
        mov BYTE PTR [rdi], al  # [src_addr] = foo([src_addr])
        pop rcx
        inc rcx # i++
.skip:
        inc rdi # src_addr++
        jmp .loop
.return:
        mov rax, rcx
        ret
/nix/store/mkvc0lnnpmi604rqsjdlv1pmhr638nbd-binutils-2.44/bin/ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000

We will be testing your code multiple times in this level with dynamic values! This means we will
be running your code in a variety of random ways to verify that the logic is robust enough to
survive normal use.

In this level you will be working with functions! This will involve manipulating the instruction pointer (rip),
as well as doing harder tasks than normal. You may be asked to use the stack to store values
or call functions that we provide you.


In previous levels you implemented a while loop to count the number of
consecutive non-zero bytes in a contiguous region of memory.

In this level you will be provided with a contiguous region of memory again and will loop
over each performing a conditional operation till a zero byte is reached.
All of which will be contained in a function!

A function is a callable segment of code that does not destroy control flow.

Functions use the instructions "call" and "ret".

The "call" instruction pushes the memory address of the next instruction onto
the stack and then jumps to the value stored in the first argument.

Let's use the following instructions as an example:
  0x1021 mov rax, 0x400000
  0x1028 call rax
  0x102a mov [rsi], rax

1. call pushes 0x102a, the address of the next instruction, onto the stack.
2. call jumps to 0x400000, the value stored in rax.

The "ret" instruction is the opposite of "call".

ret pops the top value off of the stack and jumps to it.

Let's use the following instructions and stack as an example:

                              Stack ADDR  VALUE
  0x103f mov rax, rdx         RSP + 0x8   0xdeadbeef
  0x1042 ret                  RSP + 0x0   0x0000102a

Here, ret will jump to 0x102a

Please implement the following logic:
  str_lower(src_addr):
    i = 0
    if src_addr != 0:
      while [src_addr] != 0x00:
        if [src_addr] <= 0x5a:
          [src_addr] = foo([src_addr])
          i += 1
        src_addr += 1
    return i

foo is provided at 0x403000.
foo takes a single argument as a value and returns a value.

All functions (foo and str_lower) must follow the Linux amd64 calling convention (also known as System V AMD64 ABI):
  https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI

Therefore, your function str_lower should look for src_addr in rdi and place the function return in rax.

An important note is that src_addr is an address in memory (where the string is located) and [src_addr] refers to the byte that exists at src_addr.

Therefore, the function foo accepts a byte as its first argument and returns a byte.

We will now run multiple tests on your code, here is an example run:
  (data) [0x404000] = {10 random bytes},
  rdi = 0x404000

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       xor     rcx, rcx
0x400003:       cmp     rdi, 0
0x400007:       je      0x400030
0x400009:       mov     dl, byte ptr [rdi]
0x40000b:       cmp     dl, 0
0x40000e:       je      0x400030
0x400010:       cmp     dl, 0x5a
0x400013:       ja      0x40002b
0x400015:       push    rcx
0x400016:       push    rdi
0x400017:       movzx   rdi, dl
0x40001b:       mov     rbx, 0x403000
0x400022:       call    rbx
0x400024:       pop     rdi
0x400025:       mov     byte ptr [rdi], al
0x400027:       pop     rcx
0x400028:       inc     rcx
0x40002b:       inc     rdi
0x40002e:       jmp     0x400009
0x400030:       mov     rax, rcx
0x400033:       ret
--------------------------------------
pwn.college{09uvXYiqzDLn66JN_Pzri76lJXg.dVTMywyMyITOyEzW}
```


## most-common-byte

```
hacker@assembly-crash-course~most-common-byte:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
.intel_syntax noprefix
.global most_common_byte

most_common_byte:
        # rdi = src_addr, rsi = size
        # function prologue
        push rbp
        mov rbp, rsp
        sub rsp, 0xff
        xor rcx, rcx    # rcx = i = 0
        xor rbx, rbx
.while_start:
        cmp rcx, rsi
        jb .while_block
        jmp .while_end
.while_block:
        mov bl, BYTE PTR [rdi+rcx]
        mov r9, rbp
        sub r9, rbx
        sub r9, rbx
        mov dx, WORD PTR [r9]
        inc dx
        mov WORD PTR [r9], dx
        inc rcx
        jmp .while_start
.while_end:
        xor rcx, rcx    # rcx = b = 0
        xor rdx, rdx    # rdx = max_freq = 0
        xor r8, r8      # r8 = max_freq_byte = 0
        xor rax, rax
.byte_while_start:
        cmp rcx, 0xff
        ja .return
        mov r9, rbp
        sub r9, rcx
        sub r9, rcx
        mov ax, WORD PTR [r9]
        cmp rax, rdx
        ja .max_if
        jmp .inc_b
.max_if:
        mov dx, ax
        mov r8, rcx
.inc_b:
        inc rcx
        jmp .byte_while_start
        # function epilogue
.return:
        mov rax, r8
        mov rsp, rbp
        pop rbp
        ret

/nix/store/mkvc0lnnpmi604rqsjdlv1pmhr638nbd-binutils-2.44/bin/ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000

We will be testing your code multiple times in this level with dynamic values! This means we will
be running your code in a variety of random ways to verify that the logic is robust enough to
survive normal use.

In this level you will be working with functions! This will involve manipulating the instruction pointer (rip),
as well as doing harder tasks than normal. You may be asked to use the stack to store values
or call functions that we provide you.


In the previous level, you learned how to make your first function and how to call other functions.

Now we will work with functions that have a function stack frame.

A function stack frame is a set of pointers and values pushed onto the stack to save things for later use and allocate space on the stack for function variables.

First, let's talk about the special register rbp, the Stack Base Pointer.

The rbp register is used to tell where our stack frame first started.

As an example, say we want to construct some list (a contigous space of memory) that is only used in our function.

The list is 5 elements long, and each element is a dword.

A list of 5 elements would already take 5 registers, so instead, we can make space on the stack!

The assembly would look like:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; setup the base of the stack as the current top
mov rbp, rsp
; move the stack 0x14 bytes (5 * 4) down
; acts as an allocation
sub rsp, 0x14
; assign list[2] = 1337
mov eax, 1337
mov [rbp-0x8], eax
; do more operations on the list ...
; restore the allocated space
mov rsp, rbp
ret
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Notice how rbp is always used to restore the stack to where it originally was.

If we don't restore the stack after use, we will eventually run out.

In addition, notice how we subtracted from rsp, because the stack grows down.

To make the stack have more space, we subtract the space we need.

The ret and call still works the same.

Once, again, please make function(s) that implements the following:
most_common_byte(src_addr, size):
  i = 0
  while i <= size-1:
    curr_byte = [src_addr + i]
    [stack_base - curr_byte * 2] += 1
    i += 1

  b = 0
  max_freq = 0
  max_freq_byte = 0
  while b <= 0xff:
    if [stack_base - b * 2] > max_freq:
      max_freq = [stack_base - b * 2]
      max_freq_byte = b
    b += 1

  return max_freq_byte

Assumptions:
  There will never be more than 0xffff of any byte
  The size will never be longer than 0xffff
  The list will have at least one element
Constraints:
  You must put the "counting list" on the stack
  You must restore the stack like in a normal function
  You cannot modify the data at src_addr

Extracting binary code from provided ELF file...
Executing your code...
---------------- CODE ----------------
0x400000:       push    rbp
0x400001:       mov     rbp, rsp
0x400004:       sub     rsp, 0xff
0x40000b:       xor     rcx, rcx
0x40000e:       xor     rbx, rbx
0x400011:       cmp     rcx, rsi
0x400014:       jb      0x400018
0x400016:       jmp     0x400034
0x400018:       mov     bl, byte ptr [rdi + rcx]
0x40001b:       mov     r9, rbp
0x40001e:       sub     r9, rbx
0x400021:       sub     r9, rbx
0x400024:       mov     dx, word ptr [r9]
0x400028:       inc     dx
0x40002b:       mov     word ptr [r9], dx
0x40002f:       inc     rcx
0x400032:       jmp     0x400011
0x400034:       xor     rcx, rcx
0x400037:       xor     rdx, rdx
0x40003a:       xor     r8, r8
0x40003d:       xor     rax, rax
0x400040:       cmp     rcx, 0xff
0x400047:       ja      0x400068
0x400049:       mov     r9, rbp
0x40004c:       sub     r9, rcx
0x40004f:       sub     r9, rcx
0x400052:       mov     ax, word ptr [r9]
0x400056:       cmp     rax, rdx
0x400059:       ja      0x40005d
0x40005b:       jmp     0x400063
0x40005d:       mov     dx, ax
0x400060:       mov     r8, rcx
0x400063:       inc     rcx
0x400066:       jmp     0x400040
0x400068:       mov     rax, r8
0x40006b:       mov     rsp, rbp
0x40006e:       pop     rbp
0x40006f:       ret
--------------------------------------
pwn.college{c5GVAmk_Z3cEisSTLzINxG23kah.dZTMywyMyITOyEzW}
```
