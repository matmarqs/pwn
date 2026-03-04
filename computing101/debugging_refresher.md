# debugging-refresher

## level 1

```
hacker@debugging-refresher~level1:~$ /challenge/embryogdb_level1
(gdb) r
Starting program: /challenge/embryogdb_level1
###
### Welcome to /challenge/embryogdb_level1!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

You are running in gdb! The program is currently paused. This is because it has set its own breakpoint here.

You can use the command `start` to start a program, with a breakpoint set on `main`. You can use the command `starti` to
start a program, with a breakpoint set on `_start`. You can use the command `run` to start a program, with no breakpoint
set. You can use the command `attach <PID>` to attach to some other already running program. You can use the command
`core <PATH>` to analyze the coredump of an already run program.

When starting or running a program, you can specify arguments in almost exactly the same way as you would on your shell.
For example, you can use `start <ARGV1> <ARGV2> <ARGVN> < <STDIN_PATH>`.

Use the command `continue`, or `c` for short, in order to continue program execution.


Program received signal SIGTRAP, Trace/breakpoint trap.
0x00005dc5ffb5dbe3 in main ()
(gdb) continue
Continuing.
You win! Here is your flag:
pwn.college{0I7dFHjGVO68fwV3rSL_PMf6Bd8.dRDNywyMyITOyEzW}


[Inferior 1 (process 163) exited normally]
```

## level2

```
hacker@debugging-refresher~level2:~$ /challenge/embryogdb_level2
(gdb) run
Starting program: /challenge/embryogdb_level2
###
### Welcome to /challenge/embryogdb_level2!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

You can see the values for all your registers with `info registers`. Alternatively, you can also just print a particular
register's value with the `print` command, or `p` for short. For example, `p $rdi` will print the value of $rdi in
decimal. You can also print it's value in hex with `p/x $rdi`.

In order to solve this level, you must figure out the current random value of register r12 in hex.

The random value has been set!


Program received signal SIGTRAP, Trace/breakpoint trap.
0x00006182b4e15bfd in main ()
(gdb) p/x $r12
$1 = 0x7c8a8305e86b1896
(gdb) x/s 0x7c8a8305e86b1896
0x7c8a8305e86b1896:     <error: Cannot access memory at address 0x7c8a8305e86b1896>
(gdb) x/20x 0x7c8a8305e86b1896
0x7c8a8305e86b1896:     Cannot access memory at address 0x7c8a8305e86b1896
(gdb) continue
Continuing.
Random value: 0x7c8a8305e86b1896
You input: 7c8a8305e86b1896
The correct answer is: 7c8a8305e86b1896
You win! Here is your flag:
pwn.college{E02dM-lE3pW7LHVFuQdaXA7ORGn.dVDNywyMyITOyEzW}


[Inferior 1 (process 164) exited normally]
```

## level3

```
hacker@debugging-refresher~level3:~$ /challenge/embryogdb_level3
(gdb) run
Starting program: /challenge/embryogdb_level3
###
### Welcome to /challenge/embryogdb_level3!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

You can examine the contents of memory using the `x/<n><u><f> <address>` parameterized command. In this format `<u>` is
the unit size to display, `<f>` is the format to display it in, and `<n>` is the number of elements to display. Valid
unit sizes are `b` (1 byte), `h` (2 bytes), `w` (4 bytes), and `g` (8 bytes). Valid formats are `d` (decimal), `x`
(hexadecimal), `s` (string) and `i` (instruction). The address can be specified using a register name, symbol name, or
absolute address. Additionally, you can supply mathematical expressions when specifying the address.

For example, `x/8i $rip` will print the next 8 instructions from the current instruction pointer. `x/16i main` will
print the first 16 instructions of main. You can also use `disassemble main`, or `disas main` for short, to print all of
the instructions of main. Alternatively, `x/16gx $rsp` will print the first 16 values on the stack. `x/gx $rbp-0x32`
will print the local variable stored there on the stack.

You will probably want to view your instructions using the CORRECT assembly syntax. You can do that with the command
`set disassembly-flavor intel`.

In order to solve this level, you must figure out the random value on the stack (the value read in from `/dev/urandom`).
Think about what the arguments to the read system call are.


Program received signal SIGTRAP, Trace/breakpoint trap.
0x000056f10dc92c1f in main ()
(gdb) continue
Continuing.
The random value has been set!


Program received signal SIGTRAP, Trace/breakpoint trap.
0x000056f10dc92c64 in main ()
(gdb) x/20gx $rsp
0x7fff943992a0: 0x0000000000000002      0x00007fff943993e8
0x7fff943992b0: 0x00007fff943993d8      0x000000010dc92d10
0x7fff943992c0: 0x0000000000000000      0x95bb6c5e9c29a175
0x7fff943992d0: 0x00007fff943993d0      0x098172bcb836f100
0x7fff943992e0: 0x0000000000000000      0x000077e898868083
0x7fff943992f0: 0x000077e898a73620      0x00007fff943993d8
0x7fff94399300: 0x0000000100000000      0x000056f10dc92aa6
0x7fff94399310: 0x000056f10dc92d10      0x54808c183707da0d
0x7fff94399320: 0x000056f10dc922a0      0x00007fff943993d0
0x7fff94399330: 0x0000000000000000      0x0000000000000000
(gdb) set disassembly-flavor intel
(gdb) x/20i 0x000056f10dc92c1f
   0x56f10dc92c1f <main+377>:   nop
   0x56f10dc92c20 <main+378>:   mov    DWORD PTR [rbp-0x1c],0x0
   0x56f10dc92c27 <main+385>:   jmp    0x56f10dc92cd9 <main+563>
   0x56f10dc92c2c <main+390>:   mov    esi,0x0
   0x56f10dc92c31 <main+395>:   lea    rdi,[rip+0xbd5]        # 0x56f10dc9380d
   0x56f10dc92c38 <main+402>:   mov    eax,0x0
   0x56f10dc92c3d <main+407>:   call   0x56f10dc92250 <open@plt>
   0x56f10dc92c42 <main+412>:   mov    ecx,eax
   0x56f10dc92c44 <main+414>:   lea    rax,[rbp-0x18]
   0x56f10dc92c48 <main+418>:   mov    edx,0x8
   0x56f10dc92c4d <main+423>:   mov    rsi,rax
   0x56f10dc92c50 <main+426>:   mov    edi,ecx
   0x56f10dc92c52 <main+428>:   call   0x56f10dc92210 <read@plt>
   0x56f10dc92c57 <main+433>:   lea    rdi,[rip+0xbc2]        # 0x56f10dc93820
   0x56f10dc92c5e <main+440>:   call   0x56f10dc92190 <puts@plt>
   0x56f10dc92c63 <main+445>:   int3
=> 0x56f10dc92c64 <main+446>:   nop
   0x56f10dc92c65 <main+447>:   lea    rdi,[rip+0xbd4]        # 0x56f10dc93840
   0x56f10dc92c6c <main+454>:   mov    eax,0x0
   0x56f10dc92c71 <main+459>:   call   0x56f10dc921d0 <printf@plt>
(gdb) x/s 0x56f10dc9380d
0x56f10dc9380d: "/dev/urandom"
(gdb) x/gx $rbp-0x18
0x7fff943992c8: 0x95bb6c5e9c29a175
(gdb) x/s 0x56f10dc93820
0x56f10dc93820: "The random value has been set!\n"
(gdb) x/8bx $rbp-0x18
0x7fff943992c8: 0x75    0xa1    0x29    0x9c    0x5e    0x6c    0xbb    0x95
(gdb) continue
Continuing.
Random value: 0x95bb6c5e9c29a175
You input: 95bb6c5e9c29a175
The correct answer is: 95bb6c5e9c29a175
You win! Here is your flag:
pwn.college{M1-O19VuNZcB0ov0QPRdbHUtWYJ.dZDNywyMyITOyEzW}


[Inferior 1 (process 163) exited normally]
```

## level4

```
hacker@debugging-refresher~level4:~$ /challenge/embryogdb_level4
(gdb) run
Starting program: /challenge/embryogdb_level4
###
### Welcome to /challenge/embryogdb_level4!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

A critical part of dynamic analysis is getting your program to the state you are interested in analyzing. So far, these
challenges have automatically set breakpoints for you to pause execution at states you may be interested in analyzing.
It is important to be able to do this yourself.

There are a number of ways to move forward in the program's execution. You can use the `stepi <n>` command, or `si <n>`
for short, in order to step forward one instruction. You can use the `nexti <n>` command, or `ni <n>` for short, in
order to step forward one instruction, while stepping over any function calls. The `<n>` parameter is optional, but
allows you to perform multiple steps at once. You can use the `finish` command in order to finish the currently
executing function. You can use the `break *<address>` parameterized command in order to set a breakpoint at the
specified-address. You have already used the `continue` command, which will continue execution until the program hits a
breakpoint.

While stepping through a program, you may find it useful to have some values displayed to you at all times. There are
multiple ways to do this. The simplest way is to use the `display/<n><u><f>` parameterized command, which follows
exactly the same format as the `x/<n><u><f>` parameterized command. For example, `display/8i $rip` will always show you
the next 8 instructions. On the other hand, `display/4gx $rsp` will always show you the first 4 values on the stack.
Another option is to use the `layout regs` command. This will put gdb into its TUI mode and show you the contents of all
of the registers, as well as nearby instructions.

In order to solve this level, you must figure out a series of random values which will be placed on the stack. You are
highly encouraged to try using combinations of `stepi`, `nexti`, `break`, `continue`, and `finish` to make sure you have
a good internal understanding of these commands. The commands are all absolutely critical to navigating a program's
execution.


Program received signal SIGTRAP, Trace/breakpoint trap.
0x00005f3e54c8dc73 in main ()
2: x/xg $rbp-0x18  0x7ffca45a58f8:      0x00005f3e54c8d2a0
(gdb) x/20i $rip
=> 0x5f3e54c8dc73 <main+461>:   nop
   0x5f3e54c8dc74 <main+462>:   mov    DWORD PTR [rbp-0x1c],0x0
   0x5f3e54c8dc7b <main+469>:   jmp    0x5f3e54c8dd2b <main+645>
   0x5f3e54c8dc80 <main+474>:   mov    esi,0x0
   0x5f3e54c8dc85 <main+479>:   lea    rdi,[rip+0xe3c]        # 0x5f3e54c8eac8
   0x5f3e54c8dc8c <main+486>:   mov    eax,0x0
   0x5f3e54c8dc91 <main+491>:   call   0x5f3e54c8d250 <open@plt>
   0x5f3e54c8dc96 <main+496>:   mov    ecx,eax
   0x5f3e54c8dc98 <main+498>:   lea    rax,[rbp-0x18]
   0x5f3e54c8dc9c <main+502>:   mov    edx,0x8
   0x5f3e54c8dca1 <main+507>:   mov    rsi,rax
   0x5f3e54c8dca4 <main+510>:   mov    edi,ecx
   0x5f3e54c8dca6 <main+512>:   call   0x5f3e54c8d210 <read@plt>
   0x5f3e54c8dcab <main+517>:   lea    rdi,[rip+0xe26]        # 0x5f3e54c8ead8
   0x5f3e54c8dcb2 <main+524>:   call   0x5f3e54c8d190 <puts@plt>
   0x5f3e54c8dcb7 <main+529>:   lea    rdi,[rip+0xe3a]        # 0x5f3e54c8eaf8
   0x5f3e54c8dcbe <main+536>:   mov    eax,0x0
   0x5f3e54c8dcc3 <main+541>:   call   0x5f3e54c8d1d0 <printf@plt>
   0x5f3e54c8dcc8 <main+546>:   lea    rax,[rbp-0x10]
   0x5f3e54c8dccc <main+550>:   mov    rsi,rax
(gdb) b *0x5f3e54c8dcb7
Breakpoint 2 at 0x5f3e54c8dcb7
(gdb) display/gx $rbp-0x18
3: x/xg $rbp-0x18  0x7ffca45a58f8:      0x00005f3e54c8d2a0
(gdb) continue
Continuing.
The random value has been set!


Breakpoint 2, 0x00005f3e54c8dcb7 in main ()
2: x/xg $rbp-0x18  0x7ffca45a58f8:      0xb88a563cb2b3b0b3
3: x/xg $rbp-0x18  0x7ffca45a58f8:      0xb88a563cb2b3b0b3
(gdb) del display 3
(gdb) continue
Continuing.
Random value: b88a563cb2b3b0b3
You input: b88a563cb2b3b0b3
The correct answer is: b88a563cb2b3b0b3
The random value has been set!


Breakpoint 2, 0x00005f3e54c8dcb7 in main ()
2: x/xg $rbp-0x18  0x7ffca45a58f8:      0x5661a53fc035f01e
(gdb) c
Continuing.
Random value: 5661a53fc035f01e
You input: 5661a53fc035f01e
The correct answer is: 5661a53fc035f01e
The random value has been set!


Breakpoint 2, 0x00005f3e54c8dcb7 in main ()
2: x/xg $rbp-0x18  0x7ffca45a58f8:      0xb7fe79240cb717fa
(gdb) c
Continuing.
Random value: b7fe79240cb717fa
You input: b7fe79240cb717fa
The correct answer is: b7fe79240cb717fa
The random value has been set!


Breakpoint 2, 0x00005f3e54c8dcb7 in main ()
2: x/xg $rbp-0x18  0x7ffca45a58f8:      0x17a189267d63f57d
(gdb) c
Continuing.
Random value: 17a189267d63f57d
You input: 17a189267d63f57d
The correct answer is: 17a189267d63f57d
You win! Here is your flag:
pwn.college{oCx_fH-HDKojSe5BKf8FUaV4GSX.ddDNywyMyITOyEzW}


[Inferior 1 (process 177) exited normally]
```

## level5

Here is `level5.gdb`:

```
run
set disassembly-flavor intel
break *main+721
continue
commands
    silent
    set $buffer = *(unsigned long long *)($rbp-0x18)
    printf "Current value: %llx\n", $buffer
    continue
end
continue
```

We execute with the arguments `-x level5.gdb`:

```
hacker@debugging-refresher~level5:~$ /challenge/embryogdb_level5 -x level5.gdb
Temporary breakpoint 1 at 0x1aa6

Temporary breakpoint 1, 0x0000602aeafd5aa6 in main ()
Breakpoint 2 at 0x602aeafd5d77
###
### Welcome to /challenge/embryogdb_level5!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

We write code in order to express an idea which can be reproduced and refined. We can think of our analysis as a program
which injests the target to be analyzed as data. As the saying goes, code is data and data is code.

While using gdb interactively as we've done with the past levels is incredibly powerful, another powerful tool is gdb
scripting. By scripting gdb, you can very quickly create a custom-tailored program analysis tool. If you know how to
interact with gdb, you already know how to write a gdb script--the syntax is exactly the same. You can write your
commands to some file, for example `x.gdb`, and then launch gdb using the flag `-x <PATH_TO_SCRIPT>`. This file will
execute all of the gdb commands after gdb launches. Alternatively, you can execute individual commands with `-ex
'<COMMAND>'`. You can pass multiple commands with multiple `-ex` arguments. Finally, you can have some commands be
always executed for any gdb session by putting them in `~/.gdbinit`. You probably want to put `set disassembly-flavor
intel` in there.

Within gdb scripting, a very powerful construct is breakpoint commands. Consider the following gdb script:

  start
  break *main+42
  commands
    x/gx $rbp-0x32
    continue
  end
  continue

In this case, whenever we hit the instruction at `main+42`, we will output a particular local variable and then continue
execution.

Now consider a similar, but slightly more advanced script using some commands you haven't yet seen:

  start
  break *main+42
  commands
    silent
    set $local_variable = *(unsigned long long*)($rbp-0x32)
    printf "Current value: %llx\n", $local_variable
    continue
  end
  continue

In this case, the `silent` indicates that we want gdb to not report that we have hit a breakpoint, to make the output a
bit cleaner. Then we use the `set` command to define a variable within our gdb session, whose value is our local
variable. Finally, we output the current value using a formatted string.

Use gdb scripting to help you collect the random values.


Program received signal SIGTRAP, Trace/breakpoint trap.
0x0000602aeafd5d33 in main ()
The random value has been set!

Current value: 3dd5d6aa1e1248be
Random value: 3dd5d6aa1e1248be
You input: 3dd5d6aa1e1248be
The correct answer is: 3dd5d6aa1e1248be
The random value has been set!

Current value: c1244b9aa9289a6e
Random value: c1244b9aa9289a6e
You input: c1244b9aa9289a6e
The correct answer is: c1244b9aa9289a6e
The random value has been set!

Current value: 7fd92f84baf993d6
Random value: 7fd92f84baf993d6
You input: 7fd92f84baf993d6
The correct answer is: 7fd92f84baf993d6
The random value has been set!

Current value: e024a80115d73de2
Random value: e024a80115d73de2
You input: e024a80115d73de2
The correct answer is: e024a80115d73de2
The random value has been set!

Current value: 4d74378711d90f2d
Random value: 4d74378711d90f2d
You input: 4d74378711d90f2d
The correct answer is: 4d74378711d90f2d
The random value has been set!

Current value: c76779c84a7cb73d
Random value: c76779c84a7cb73d
You input: c76779c84a7cb73d
The correct answer is: c76779c84a7cb73d
The random value has been set!

Current value: 89a511af61bb0715
Random value: 89a511af61bb0715
You input: 89a511af61bb0715
The correct answer is: 89a511af61bb0715
The random value has been set!

Current value: 47ee3c5b0a8ef00d
Random value: 47ee3c5b0a8ef00d
You input: 47ee3c5b0a8ef00d
The correct answer is: 47ee3c5b0a8ef00d
You win! Here is your flag:
pwn.college{44yZVOzz2jUnSpQsMy5ucNjdPhd.dhDNywyMyITOyEzW}


[Inferior 1 (process 165) exited normally]
```

## level6

First of all, let's create an input file `infile` that has `0x40` lines. This is the number of checks the program does, since it has a for loop:

```asm
   0x5c9e75fb5d67 <main+705>:   cmp    DWORD PTR [rbp-0x1c],0x3f
   0x5c9e75fb5d6b <main+709>:   jle    0x5c9e75fb5cbc <main+534>
```

We can do this with

```bash
hacker@debugging-refresher~level6:~$ python3 -c 'print("deadbeef\n" * 0x40, end="")' > infile
```

Now we construct the gdb script `level6.gdb`:

```
set disassembly-flavor intel
run < infile
break *main+686
commands
    silent
    set $rdx = $rax
    continue
end
continue
```

The instruction at `main+686` is where the `cmp` happens:

```asm
   0x5c9e75fb5d4c <main+678>:   mov    rdx,QWORD PTR [rbp-0x10]
   0x5c9e75fb5d50 <main+682>:   mov    rax,QWORD PTR [rbp-0x18]
=> 0x5c9e75fb5d54 <main+686>:   cmp    rdx,rax
   0x5c9e75fb5d57 <main+689>:   je     0x5c9e75fb5d63 <main+701>
   0x5c9e75fb5d59 <main+691>:   mov    edi,0x1
   0x5c9e75fb5d5e <main+696>:   call   0x5c9e75fb5280 <exit@plt>
   0x5c9e75fb5d63 <main+701>:   add    DWORD PTR [rbp-0x1c],0x1
   0x5c9e75fb5d67 <main+705>:   cmp    DWORD PTR [rbp-0x1c],0x3f
   0x5c9e75fb5d6b <main+709>:   jle    0x5c9e75fb5cbc <main+534>
   0x5c9e75fb5d71 <main+715>:   mov    eax,0x0
   0x5c9e75fb5d76 <main+720>:   call   0x5c9e75fb597d <win>
```

We just `set $rdx = $rax` to take the jump at all cases. This will solve the challenge. Of course, another simple way to solve the challenge is just jumping directly to the `call win` at `<main+720>`.

```
hacker@debugging-refresher~level6:~$ /challenge/embryogdb_level6 -x level6.gdb
###
### Welcome to /challenge/embryogdb_level6!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

As it turns out, gdb has FULL control over the target process. Not only can you analyze the program's state, but you can
also modify it. While gdb probably isn't the best tool for doing long term maintenance on a program, sometimes it can be
useful to quickly modify the behavior of your target process in order to more easily analyze it.

You can modify the state of your target program with the `set` command. For example, you can use `set $rdi = 0` to zero
out $rdi. You can use `set *((uint64_t *) $rsp) = 0x1234` to set the first value on the stack to 0x1234. You can use
`set *((uint16_t *) 0x31337000) = 0x1337` to set 2 bytes at 0x31337000 to 0x1337.

Suppose your target is some networked application which reads from some socket on fd 42. Maybe it would be easier for
the purposes of your analysis if the target instead read from stdin. You could achieve something like that with the
following gdb script:

  start
  catch syscall read
  commands
    silent
    if ($rdi == 42)
      set $rdi = 0
    end
    continue
  end
  continue

This example gdb script demonstrates how you can automatically break on system calls, and how you can use conditions
within your commands to conditionally perform gdb commands.

In the previous level, your gdb scripting solution likely still required you to copy and paste your solutions. This
time, try to write a script that doesn't require you to ever talk to the program, and instead automatically solves each
challenge by correctly modifying registers / memory.


Program received signal SIGTRAP, Trace/breakpoint trap.
0x000061b4e8b75caf in main ()
Breakpoint 1 at 0x61b4e8b75d54
The random value has been set!

Random value: You input: deadbeef
The correct answer is: 1a84ed4730a20d12
The random value has been set!

Random value: You input: deadbeef
The correct answer is: 3ad96d4370d5064c
The random value has been set!

Random value: You input: deadbeef
The correct answer is: 264f11a7c4a3c664
The random value has been set!

...

<SNIP>

...

Random value: You input: deadbeef
The correct answer is: 61e5cafc9cad4900
The random value has been set!

Random value: You input: deadbeef
The correct answer is: d0e84439cee6cb7b
You win! Here is your flag:
pwn.college{MlZ_S1I81NJxg9s9tpdZMdZDEbl.dlDNywyMyITOyEzW}


[Inferior 1 (process 245) exited normally]
```

## level7

```
hacker@debugging-refresher~level7:~$ /challenge/embryogdb_level7
(gdb) run
Starting program: /challenge/embryogdb_level7
###
### Welcome to /challenge/embryogdb_level7!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

As we demonstrated in the previous level, gdb has FULL control over the target process. Under normal circumstances, gdb
running as your regular user cannot attach to a privileged process. This is why gdb isn't a massive security issue which
would allow you to just immediately solve all the levels. Nevertheless, gdb is still an extremely powerful tool.

Running within this elevated instance of gdb gives you elevated control over the entire system. To clearly demonstrate
this, see what happens when you run the command `call (void)win()`. As it turns out, all of the levels in this module
can be solved in this way.

GDB is very powerful!


Program received signal SIGTRAP, Trace/breakpoint trap.
0x00006360ecebfbb7 in main ()
(gdb) call (void)win()
You win! Here is your flag:
pwn.college{0yS1WAp8N07gLuRB7vAIoXFKrRC.dBTNywyMyITOyEzW}
```

## level8

In this level, we `call (void)win()` but the first instructions of the function are corrupted.

Therefore, we just skip them by jumping to the instruction that print the flag: `<win+35>`.

```
(gdb) run
###
### Welcome to /challenge/embryogdb_level8!
###

GDB is a very powerful dynamic analysis tool which you can use in order to understand the state of a program throughout
its execution. You will become familiar with some of gdb's capabilities in this module.

As we demonstrated in the previous level, gdb has FULL control over the target process. Under normal circumstances, gdb
running as your regular user cannot attach to a privileged process. This is why gdb isn't a massive security issue which
would allow you to just immediately solve all the levels. Nevertheless, gdb is still an extremely powerful tool.

Running within this elevated instance of gdb gives you elevated control over the entire system. To clearly demonstrate
this, see what happens when you run the command `call (void)win()`.

Note that this will _not_ get you the flag (it seems that we broke the win function!), so you'll need to work a bit
harder to get this flag!

As it turns out, all of the levels other levels in module could be solved in this way.

GDB is very powerful!


Program received signal SIGTRAP, Trace/breakpoint trap.
0x00005763848bdb99 in main ()
1: x/5i $rip
=> 0x5763848bdb99 <main+292>:   nop
   0x5763848bdb9a <main+293>:   mov    edi,0x2a
   0x5763848bdb9f <main+298>:   call   0x5763848bd260 <exit@plt>
   0x5763848bdba4:      nop    WORD PTR cs:[rax+rax*1+0x0]
   0x5763848bdbae:      xchg   ax,ax
(gdb) call (void)win()

Breakpoint 1, 0x00005763848bd951 in win ()
1: x/5i $rip
=> 0x5763848bd951 <win>:        endbr64
   0x5763848bd955 <win+4>:      push   rbp
   0x5763848bd956 <win+5>:      mov    rbp,rsp
   0x5763848bd959 <win+8>:      sub    rsp,0x10
   0x5763848bd95d <win+12>:     mov    QWORD PTR [rbp-0x8],0x0
The program being debugged stopped while in a function called from GDB.
Evaluation of the expression containing the function
(win) will be abandoned.
When the function is done executing, GDB will silently stop.
(gdb) b *win+24
Breakpoint 3 at 0x5763848bd969
(gdb) c
Continuing.

Breakpoint 3, 0x00005763848bd969 in win ()
1: x/5i $rip
=> 0x5763848bd969 <win+24>:     mov    eax,DWORD PTR [rax]
   0x5763848bd96b <win+26>:     lea    edx,[rax+0x1]
   0x5763848bd96e <win+29>:     mov    rax,QWORD PTR [rbp-0x8]
   0x5763848bd972 <win+33>:     mov    DWORD PTR [rax],edx
   0x5763848bd974 <win+35>:     lea    rdi,[rip+0x73e]        # 0x5763848be0b9
(gdb) x/30i $rip
=> 0x5763848bd969 <win+24>:     mov    eax,DWORD PTR [rax]
   0x5763848bd96b <win+26>:     lea    edx,[rax+0x1]
   0x5763848bd96e <win+29>:     mov    rax,QWORD PTR [rbp-0x8]
   0x5763848bd972 <win+33>:     mov    DWORD PTR [rax],edx
   0x5763848bd974 <win+35>:     lea    rdi,[rip+0x73e]        # 0x5763848be0b9
   0x5763848bd97b <win+42>:     call   0x5763848bd180 <puts@plt>
   0x5763848bd980 <win+47>:     mov    esi,0x0
   0x5763848bd985 <win+52>:     lea    rdi,[rip+0x749]        # 0x5763848be0d5
   0x5763848bd98c <win+59>:     mov    eax,0x0
   0x5763848bd991 <win+64>:     call   0x5763848bd240 <open@plt>
   0x5763848bd996 <win+69>:     mov    DWORD PTR [rip+0x26a4],eax        # 0x5763848c0040 <flag_fd.5712>
   0x5763848bd99c <win+75>:     mov    eax,DWORD PTR [rip+0x269e]        # 0x5763848c0040 <flag_fd.5712>
   0x5763848bd9a2 <win+81>:     test   eax,eax
   0x5763848bd9a4 <win+83>:     jns    0x5763848bd9ef <win+158>
   0x5763848bd9a6 <win+85>:     call   0x5763848bd170 <__errno_location@plt>
   0x5763848bd9ab <win+90>:     mov    eax,DWORD PTR [rax]
   0x5763848bd9ad <win+92>:     mov    edi,eax
   0x5763848bd9af <win+94>:     call   0x5763848bd270 <strerror@plt>
   0x5763848bd9b4 <win+99>:     mov    rsi,rax
   0x5763848bd9b7 <win+102>:    lea    rdi,[rip+0x722]        # 0x5763848be0e0
   0x5763848bd9be <win+109>:    mov    eax,0x0
   0x5763848bd9c3 <win+114>:    call   0x5763848bd1c0 <printf@plt>
   0x5763848bd9c8 <win+119>:    call   0x5763848bd1f0 <geteuid@plt>
   0x5763848bd9cd <win+124>:    test   eax,eax
   0x5763848bd9cf <win+126>:    je     0x5763848bda66 <win+277>
   0x5763848bd9d5 <win+132>:    lea    rdi,[rip+0x734]        # 0x5763848be110
   0x5763848bd9dc <win+139>:    call   0x5763848bd180 <puts@plt>
   0x5763848bd9e1 <win+144>:    lea    rdi,[rip+0x750]        # 0x5763848be138
   0x5763848bd9e8 <win+151>:    call   0x5763848bd180 <puts@plt>
   0x5763848bd9ed <win+156>:    jmp    0x5763848bda66 <win+277>
(gdb) set $rip = *win+35
(gdb) c
Continuing.
You win! Here is your flag:
pwn.college{AQf_r_41dcX-pmObGcZuiTJZl5m.QX5MzMzwyMyITOyEzW}
```

