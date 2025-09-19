# Building a Web Server

## exit

```
hacker@building-a-web-server~exit:~$ cat asm.s && ./assemble.sh asm.s && /challenge/run a.out 
.intel_syntax noprefix
.global _start

_start:
        mov rax, 60
        mov rdi, 0
        syscall
===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will exit a program.


===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7fcb318b3a60 /* 0 vars */) = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{AryK1li8Mq7qxnqv4jP8TQQM9C4.QXwQzMzwyMyITOyEzW}
```

## socket

In order to get the corresponding values of `AF_INET` and `SOCK_STREAM`, we use the `grep` commands:
```bash
[sekai@void ~]$ grep -R "AF_INET" /usr/include/ | grep '^#define'
[sekai@void ~]$ grep -R "AF_INET" /usr/include/ | grep '#define'
/usr/include/bits/socket.h:#define AF_INET              PF_INET
/usr/include/bits/socket.h:#define AF_INET6     PF_INET6
[sekai@void ~]$ grep -R "PF_INET" /usr/include/ | grep '#define'
/usr/include/bits/socket.h:#define PF_INET              2       /* IP protocol family.  */
/usr/include/bits/socket.h:#define PF_INET6     10      /* IP version 6.  */
/usr/include/bits/socket.h:#define AF_INET              PF_INET
/usr/include/bits/socket.h:#define AF_INET6     PF_INET6
[sekai@void ~]$ grep -R "SOCK_STREAM" /usr/include/ | grep '#define'
/usr/include/bits/socket_type.h:#define SOCK_STREAM SOCK_STREAM
[sekai@void ~]$ grep -R "SOCK_STREAM" /usr/include
/usr/include/bits/socket_type.h:  SOCK_STREAM = 1,              /* Sequenced, reliable, connection-based
/usr/include/bits/socket_type.h:#define SOCK_STREAM SOCK_STREAM
```


```
hacker@building-a-web-server~socket:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out 
In this challenge, you’ll begin your journey into networking by creating a socket using the [socket](https://man7.org/linux/man-pages/man2/socket.2.html) syscall.
A socket is the basic building block for network communication; it serves as an endpoint for sending and receiving data.
When you invoke [socket](https://man7.org/linux/man-pages/man2/socket.2.html), you provide three key arguments: the domain (for example, `AF_INET` for IPv4), the type (such as `SOCK_STREAM` for TCP), and the protocol (usually set to `0` to choose the default).
Mastering this syscall is important because it lays the foundation for all subsequent network interactions.

----
**NOTE:**
Looking through documentation, the arguments of the system calls are listed as names in all capitals.
For instance, we may wish to call `socket(AF_INET, SOCK_STREAM, 0)` but we cannot simply perform `mov rdi, AF_INET`: `AF_INET` is simply not a concept at the assembly level.
We need to find the integer which corresponds to `AF_INET`.
These numbers are not even found in the man pages, but these numbers do exist on your machine.
Check out the `/usr/include` directory.
All the system's general-use include files for C programming are placed here. (For those who have written C, think of any header files you've included in your code "`#include <stdio.h>`". All those Functions and constants are defined somewhere here).
Since C is compiled to assembly, these numbers are present somewhere in this directory.
Rather than manually searching, you can [grep](https://pwn.college/linux-luminarium/commands/) for them.
.intel_syntax noprefix
.global _start

_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall
===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will create a socket.


===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f35a4f3fa60 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{MCNP9iK6RchbkpfgWUGPIQi9co9.QXxQzMzwyMyITOyEzW}
```

## bind

```
hacker@building-a-web-server~bind:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
After creating a socket, the next step is to assign it a network identity.
In this challenge, you will use the [bind](https://man7.org/linux/man-pages/man2/bind.2.html) syscall to connect your socket to a specific IP address and port number.
The call requires you to provide the socket file descriptor, a pointer to a `struct sockaddr` (specifically a `struct sockaddr_in` for IPv4 that holds fields like the address family, port, and IP address), and the size of that structure.
Binding is essential because it ensures your server listens on a known address, making it reachable by clients.
.intel_syntax noprefix
.global _start

_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov rdi, rax    # sockfd
        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind (sockfd, addr, addrlen)
        mov rax, 49
        mov rsi, rsp
        mov rdx, 0x10
        syscall
        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will bind an address to a socket.


===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f0673f1fa60 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{M9IeS42idE8Dri9fXJu7W6NEeIk.QXyQzMzwyMyITOyEzW}
```

## listen

```
hacker@building-a-web-server~listen:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
With your socket bound to an address, you now need to prepare it to accept incoming connections.
The [listen](https://man7.org/linux/man-pages/man2/listen.2.html) syscall transforms your socket into a passive one that awaits client connection requests.
It requires the socket’s file descriptor and a backlog parameter, which sets the maximum number of queued connections.
This step is vital because without marking the socket as listening, your server wouldn’t be able to receive any connection attempts.
.intel_syntax noprefix
.global _start

_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov rdi, rax    # rdi = sockfd
        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rsi, rsp
        mov rdx, 0x10
        syscall
        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rsi, 0      # backlog = 0
        syscall
        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will listen on a socket.


===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f4b407d6a60 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{Q0UUHom56PTqVpU6xcm98LwnD-L.QXzQzMzwyMyITOyEzW}
```

## accept

```
hacker@building-a-web-server~accept:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
Once your socket is listening, it’s time to actively accept incoming connections.
In this challenge, you will use the [accept](https://man7.org/linux/man-pages/man2/accept.2.html) syscall, which waits for a client to connect.
When a connection is established, it returns a new socket file descriptor dedicated to communication with that client and fills in a provided address structure (such as a `struct sockaddr_in`) with the client’s details.
This process is a critical step in transforming your server from a passive listener into an active communicator.
.intel_syntax noprefix
.global _start

_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov rdi, rax    # rdi = sockfd
        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rsi, rsp
        mov rdx, 0x10
        syscall
        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rsi, 0      # backlog = 0
        syscall
        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rsi, 0
        mov rdx, 0
        syscall
        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will accept a connection.

Performing operation: connect

===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] accept(3, NULL, NULL) = 4
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7fbff4ceca60 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] accept(3, NULL, NULL)                   = 4
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{UGQv2s6XS88OSALdSTFu-Tf7RGC.QX0QzMzwyMyITOyEzW}
```

## static response

```
hacker@building-a-web-server~static-response:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
Now that your server can establish connections, it’s time to learn how to send data.
In this challenge, your goal is to send a fixed HTTP response (`HTTP/1.0 200 OK\r\n\r\n`) to any client that connects.
You will use the [write](https://man7.org/linux/man-pages/man2/write.2.html) syscall, which requires a file descriptor, a pointer to a data buffer, and the number of bytes to write.
This exercise is important because it teaches you how to format and deliver data over the network.
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer

.section .data
hello:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov rdi, rax    # rdi = sockfd
        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rsi, rsp
        mov rdx, 0x10
        syscall
        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rsi, 0      # backlog = 0
        syscall
        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rsi, 0
        mov rdx, 0
        syscall
        mov rdi, rax
        # read(int fd, buf, count = NULL)
        mov rax, 0
        mov rsi, offset buffer
        mov rdx, 1024
        syscall
        # write(int fd, char *buf, size_t count)
        mov rax, 1
        mov rsi, offset hello
        mov rdx, 19
        syscall
        # close(int fd)
        mov rax, 3
        syscall
        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will respond to an http request.

Performing operation: validated connect

===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] accept(3, NULL, NULL) = 4
[ ] read(4, <read_request>, <read_request_count>) = <read_request_result>
[ ] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[ ] close(4) = 0
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f0a47bb2af0 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] accept(3, NULL, NULL)                   = 4
[✓] read(4, "GET / HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.32.4\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\n\r\n", 1024) = 146
[✓] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[✓] close(4)                                = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{shrc1HoLr_0gPOHFFQtlINV8G-J.QX1QzMzwyMyITOyEzW}
```

## dynamic response

```
hacker@building-a-web-server~dynamic-response:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
In this challenge, your server evolves to handle dynamic content based on HTTP GET requests.
You will first use the [read](https://man7.org/linux/man-pages/man2/read.2.html) syscall to receive the incoming HTTP request from the client socket.
By examining the request line--particularly, in this case, the URL path--you can determine what the client is asking for.
Next, use the [open](https://man7.org/linux/man-pages/man2/open.2.html) syscall to open the requested file and [read](https://man7.org/linux/man-pages/man2/read.2.html) to read its contents.
Send the file contents back to the client using the [write](https://man7.org/linux/man-pages/man2/write.2.html) syscall.
This marks a significant step toward interactivity, as your server begins tailoring its output rather than simply echoing a static message.
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer
fpath:
        .space 64       # allocate 64 bytes for file_path string
content:
        .space 256      # allocate 256 bytes for temporary file content

.section .data
http_ok:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov r8, rax    # r8 = sockfd

        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rdi, r8
        mov rsi, rsp
        mov rdx, 0x10
        syscall

        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rdi, r8
        mov rsi, 0      # backlog = 0
        syscall

        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rdi, r8
        mov rsi, 0
        mov rdx, 0
        syscall
        mov r9, rax    # r9 = connfd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r9
        mov rsi, offset buffer
        mov rdx, 1024
        syscall

        # void get_file_path(char *buffer, char *fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call get_file_path

        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0      # O_RDONLY = 0
        mov rdx, 0
        syscall
        mov r10, rax    # r10 = filefd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r10
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov r12, rax    # r11 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

get_file_path:
        # rdi = buffer (full request)
        # rsi = fpath (output)

        lea rcx, [rdi+4]       # skip "GET " (3 chars + space)

.loop:
        mov al, BYTE PTR [rcx]
        cmp al, 0x20           # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rcx
        inc rsi
        jmp .loop

.done:
        mov BYTE PTR [rsi], 0  # null terminate
        ret

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will respond to a GET request for the contents of a specified file.

Performing operation: HTTP GET request

===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] accept(3, NULL, NULL) = 4
[ ] read(4, <read_request>, <read_request_count>) = <read_request_result>
[ ] open("<open_path>", O_RDONLY) = 5
[ ] read(5, <read_file>, <read_file_count>) = <read_file_result>
[ ] close(5) = 0
[ ] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[ ] write(4, <write_file>, <write_file_count>) = <write_file_result>
[ ] close(4) = 0
[ ] exit(0) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7fdb1ed71af0 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] accept(3, NULL, NULL)                   = 4
[✓] read(4, "GET /tmp/tmp34997_un HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.32.4\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\n\r\n", 1024) = 161
[✓] open("/tmp/tmp34997_un", O_RDONLY)      = 5
[✓] read(5, "nhXI6bGBOHILb2aKED7lysH7jd9kul4TWWBATRNNOMt6EuO01WATSFZBZwpONQ36G7FIJYlc2tfQDimse3so2LTciiutbeXfpyQa84N2A2m9Mc0IFt0vLjmtJWlqAy2DCSvb7IlGqOi4dWWl", 256) = 144
[✓] close(5)                                = 0
[✓] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[✓] write(4, "nhXI6bGBOHILb2aKED7lysH7jd9kul4TWWBATRNNOMt6EuO01WATSFZBZwpONQ36G7FIJYlc2tfQDimse3so2LTciiutbeXfpyQa84N2A2m9Mc0IFt0vLjmtJWlqAy2DCSvb7IlGqOi4dWWl", 144) = 144
[✓] close(4)                                = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{sTl5F7ZMmxQiROjV-9kQ3pjKyiX.QX2QzMzwyMyITOyEzW}
```

## iterative GET server

```
hacker@building-a-web-server~iterative-get-server:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
Previously, your server served just one GET request before terminating.
Now, you will modify it so that it can handle multiple GET requests sequentially.
This involves wrapping the accept-read-write-close sequence in a loop.
Each time a client connects, your server will accept the connection, process the GET request, and then cleanly close the client session while remaining active for the next request.
This iterative approach is essential for building a persistent server.
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer
fpath:
        .space 64       # allocate 64 bytes for file_path string
content:
        .space 256      # allocate 256 bytes for temporary file content

.section .data
http_ok:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov r8, rax    # r8 = sockfd

        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rdi, r8
        mov rsi, rsp
        mov rdx, 0x10
        syscall

        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rdi, r8
        mov rsi, 0      # backlog = 0
        syscall

.accept_request_loop:

        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rdi, r8
        mov rsi, 0
        mov rdx, 0
        syscall
        mov r9, rax    # r9 = connfd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r9
        mov rsi, offset buffer
        mov rdx, 1024
        syscall

        # void get_file_path(char *buffer, char *fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call get_file_path

        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0      # O_RDONLY = 0
        mov rdx, 0
        syscall
        mov r10, rax    # r10 = filefd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r10
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov r12, rax    # r11 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        jmp .accept_request_loop

        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

get_file_path:
        # rdi = buffer (full request)
        # rsi = fpath (output)

        lea rcx, [rdi+4]       # skip "GET " (3 chars + space)

.loop:
        mov al, BYTE PTR [rcx]
        cmp al, 0x20           # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rcx
        inc rsi
        jmp .loop

.done:
        mov BYTE PTR [rsi], 0  # null terminate
        ret

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will accept multiple requests.

Performing operation: HTTP GET request
Performing operation: connect

===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] accept(3, NULL, NULL) = 4
[ ] read(4, <read_request>, <read_request_count>) = <read_request_result>
[ ] open("<open_path>", O_RDONLY) = 5
[ ] read(5, <read_file>, <read_file_count>) = <read_file_result>
[ ] close(5) = 0
[ ] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[ ] write(4, <write_file>, <write_file_count>) = <write_file_result>
[ ] close(4) = 0
[ ] accept(3, NULL, NULL) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f60b56beaf0 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] accept(3, NULL, NULL)                   = 4
[✓] read(4, "GET /tmp/tmpsvsbdbuz HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.32.4\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\n\r\n", 1024) = 161
[✓] open("/tmp/tmpsvsbdbuz", O_RDONLY)      = 5
[✓] read(5, "5qHzylqLRYlmjkpSz2PY8kaBH3AxwcOdD5K1opRGTAQu8AcZ2vjKtInsnEpPegWeP1CksWeFsSUOhlGU2Jx8RfVU0blxNmi8RLHURQEUi65m7sIjpdkxjKjkY1hrDODXF0jl8yIC", 256) = 136
[✓] close(5)                                = 0
[✓] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[✓] write(4, "5qHzylqLRYlmjkpSz2PY8kaBH3AxwcOdD5K1opRGTAQu8AcZ2vjKtInsnEpPegWeP1CksWeFsSUOhlGU2Jx8RfVU0blxNmi8RLHURQEUi65m7sIjpdkxjKjkY1hrDODXF0jl8yIC", 136) = 136
[✓] close(4)                                = 0
[✓] accept(3, NULL, NULL)                   = ?
[?] +++ killed by SIGKILL +++

===== Result =====
[✓] Success

pwn.college{U21HjRs2w6lbGM53AaMCk1qQW3r.QX3QzMzwyMyITOyEzW}
```

## concurrent GET server

```
hacker@building-a-web-server~concurrent-get-server:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
To enable your server to handle several clients at once, you will introduce concurrency using the [fork](https://man7.org/linux/man-pages/man2/fork.2.html) syscall.
When a client connects, [fork](https://man7.org/linux/man-pages/man2/fork.2.html) creates a child process dedicated to handling that connection.
Meanwhile, the parent process immediately returns to accept additional connections.
With this design, the child uses [read](https://man7.org/linux/man-pages/man2/read.2.html) and [write](https://man7.org/linux/man-pages/man2/write.2.html) to interact with the client, while the parent continues to listen.
This concurrent model is a key concept in building scalable, real-world servers.
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer
fpath:
        .space 64       # allocate 64 bytes for file_path string
content:
        .space 256      # allocate 256 bytes for temporary file content

.section .data
http_ok:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov r8, rax    # r8 = sockfd

        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rdi, r8
        mov rsi, rsp
        mov rdx, 0x10
        syscall

        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rdi, r8
        mov rsi, 0      # backlog = 0
        syscall

.accept_request_loop:

        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rdi, r8
        mov rsi, 0
        mov rdx, 0
        syscall
        mov r9, rax    # r9 = connfd

        # pid_t fork()
        mov rax, 57
        syscall
        mov r15, rax    # r15 = pid

        cmp r15, 0      # if != 0: parent, if == 0: child
        je .child_process

.parent_process:
        # close the connection just accepted, let the child handle it
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        jmp .accept_request_loop

.child_process:
        # close the sockfd
        # close(int fd)
        mov rax, 3
        mov rdi, r8
        syscall

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r9
        mov rsi, offset buffer
        mov rdx, 1024
        syscall

        # void get_file_path(char *buffer, char *fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call get_file_path

        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0      # O_RDONLY = 0
        mov rdx, 0
        syscall
        mov r10, rax    # r10 = filefd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r10
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov r12, rax    # r11 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

get_file_path:
        # rdi = buffer (full request)
        # rsi = fpath (output)

        lea rcx, [rdi+4]       # skip "GET " (3 chars + space)

.loop:
        mov al, BYTE PTR [rcx]
        cmp al, 0x20           # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rcx
        inc rsi
        jmp .loop

.done:
        mov BYTE PTR [rsi], 0  # null terminate
        ret

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will concurrently accept multiple requests.

Performing operation: HTTP GET request
Performing operation: connect

===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] accept(3, NULL, NULL) = 4
[ ] fork() = <fork_result>
[ ] close(4) = 0
[ ] accept(3, NULL, NULL) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f9ba5284af0 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] accept(3, NULL, NULL)                   = 4
[✓] fork()                                  = 7
[✓] close(4)                                = 0
[✓] accept(3, NULL, NULL)                   = ?
[?] +++ killed by SIGKILL +++

===== Expected: Child Process =====
[ ] close(3) = 0
[ ] read(4, <read_request>, <read_request_count>) = <read_request_result>
[ ] open("<open_path>", O_RDONLY) = 3
[ ] read(3, <read_file>, <read_file_count>) = <read_file_result>
[ ] close(3) = 0
[ ] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[ ] write(4, <write_file>, <write_file_count>) = <write_file_result>
[ ] exit(0) = ?

===== Trace: Child Process =====
[✓] close(3)                                = 0
[✓] read(4, "GET /tmp/tmptsteibk3 HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.32.4\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\n\r\n", 1024) = 161
[✓] open("/tmp/tmptsteibk3", O_RDONLY)      = 3
[✓] read(3, "NF3YkFmKpFlDyKwnnzHGuA8PBEEtHEod6r4X4a6yFkxioJ", 256) = 46
[✓] close(3)                                = 0
[✓] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[✓] write(4, "NF3YkFmKpFlDyKwnnzHGuA8PBEEtHEod6r4X4a6yFkxioJ", 46) = 46
[?] close(4)                                = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{0Y6DMpsfNqNqnCjHXhoD1sX-lep.QX4QzMzwyMyITOyEzW}
```

## concurrent POST server

```
hacker@building-a-web-server~concurrent-post-server:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
Expanding your server’s capabilities further, this challenge focuses on handling HTTP POST requests concurrently.
POST requests are more complex because they include both headers and a message body.
You will once again use [fork](https://man7.org/linux/man-pages/man2/fork.2.html) to manage multiple connections, while using [read](https://man7.org/linux/man-pages/man2/read.2.html) to capture the entire request.
Again, you will parse the URL path to determine the specified file, but this time instead of reading from that file, you will instead write to it with the incoming POST data.
In order to do so, you must determine the length of the incoming POST data.
The *obvious* way to do this is to parse the `Content-Length` header, which specifies exactly that.
Alternatively, consider using the return value of [read](https://man7.org/linux/man-pages/man2/read.2.html) to determine the total length of the request, parsing the request to find the total length of the headers (which end with `\r\n\r\n`), and using that difference to determine the length of the body--this seemingly more complicated algorithm may actually be easier to implement.
Finally, return just a `200 OK` response to the client to indicate that the POST request was successful.
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer
fpath:
        .space 64       # allocate 64 bytes for file_path string
content:
        .space 256      # allocate 256 bytes for temporary file content
psdata:
        .space 256      # allocate 256 bytes for POST data

.section .data
http_ok:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov r8, rax    # r8 = sockfd

        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rdi, r8
        mov rsi, rsp
        mov rdx, 0x10
        syscall

        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rdi, r8
        mov rsi, 0      # backlog = 0
        syscall

.accept_request_loop:

        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rdi, r8
        mov rsi, 0
        mov rdx, 0
        syscall
        mov r9, rax    # r9 = connfd

        # pid_t fork()
        mov rax, 57
        syscall
        mov r15, rax    # r15 = pid

        cmp r15, 0      # if != 0: parent, if == 0: child
        je .child_process

.parent_process:
        # close the connection just accepted, let the child handle it
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        jmp .accept_request_loop

.child_process:
        # close the sockfd
        # close(int fd)
        mov rax, 3
        mov rdi, r8
        syscall

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r9
        mov rsi, offset buffer
        mov rdx, 1024
        syscall
        mov r14, rax    # r14 = request_len

        # void interpret_request(char *buffer, char *fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call interpret_request
        mov r13, rax    # r13 = 0 if GET else 1

        cmp r13, 0
        je .main_get_request

.main_post_request:
        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0x41 # O_CREAT | O_WRONLY = 0x41
        mov rdx, 0x1ff # 0777 = 0x1ff, mode rwxrwxrwx
        syscall
        mov r10, rax    # r10 = filefd

        # void get_post_data(char *buffer, int buffer_len, char *post_data)
        mov rdi, offset buffer
        mov rsi, r14
        mov rdx, offset psdata
        call get_post_data

        # write(int filefd, post_data, count)
        mov rdx, rax    # psdata_length
        mov rax, 1
        mov rdi, r10
        mov rsi, offset psdata
        syscall
        mov r12, rax    # r12 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

        jmp .exit

.main_get_request:
        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0      # O_RDONLY = 0
        mov rdx, 0
        syscall
        mov r10, rax    # r10 = filefd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r10
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov r12, rax    # r12 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

.exit:
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

get_post_data:
        # void get_post_data(char *buffer, int buffer_len, char *post_data)
        # rdi = buffer (full request)
        # rsi = buffer_len
        # rdx = post_data (output)
        push rbp
        mov rbp, rsp

        push rdi
        sub rsi, 4  # subtract 4 chars of total length, because of "\r\n\r\n"

        # init i = 0
        xor rcx, rcx

.loop_ini:
        # skip "\r\n\r\n"
        cmp rcx, rsi
        ja .loop_end

        mov rbx, [rbp-0x8]      # buffer = rbp-0x8
        add rbx, rcx    # rbx = buffer + i
        mov rdi, rbx
        call contain_rnrn
        cmp rax, 0
        jne .loop_end

        inc rcx
        jmp .loop_ini

.loop_end:
        pop rdi
        add rsi, 3      # put rsi at the last character of buffer: buffer_len - 1
        add rcx, 4      # jump 4 chars, where the post_data starts

        # the correct length of post_data
        mov rax, rsi
        add rax, 1
        sub rax, rcx

.copy_ini:
        cmp rcx, rsi
        ja .copy_end
        mov bl, BYTE PTR [rdi+rcx]
        mov BYTE PTR [rdx], bl
        inc rcx
        inc rdx
        jmp .copy_ini

.copy_end:
        mov BYTE PTR [rdx], 0x00 # null byte
        mov rsp, rbp
        pop rbp
        ret

contain_rnrn:
        # int get_post_data(char *buffer)
        # rdi = char pointer to see if it matches "\r\n\r\n"
        push rbp
        mov rbp, rsp

        push rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xd     # \r = 0xd, \n = 0xa
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xa     # \n = 0xa
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xd     # \r = 0xd
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xa     # \n = 0xa
        jne .return_false

        # return true
        mov rax, 1
        jmp .end

.return_false:
        mov rax, 0

.end:
        pop rdi
        mov rsp, rbp
        pop rbp
        ret

interpret_request:
        # int interpret_request(char *buffer, char *fpath)
        # rdi = buffer (full request)
        # rsi = fpath (output)
        # return value: 0 if GET, 1 if POST
        push rbp
        mov rbp, rsp

        mov al, BYTE PTR [rdi]
        cmp al, 0x71    # 'G' = 0x71
        je .get_request

.post_request:
        mov rax, 1
        push rax
        mov rdx, 5
        jmp .parse_file_path

.get_request:
        mov rax, 0
        push rax
        mov rdx, 4

.parse_file_path:
        lea rcx, [rdi+rdx]       # skip "GET " or "POST "

.loop:
        mov al, BYTE PTR [rcx]
        cmp al, 0x20           # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rcx
        inc rsi
        jmp .loop

.done:
        mov BYTE PTR [rsi], 0  # null terminate
        pop rax

        mov rsp, rbp
        pop rbp
        ret

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will respond to a POST request with a specified file and update its contents.

Performing operation: HTTP POST request
Performing operation: connect

===== Expected: Parent Process =====
[ ] execve(<execve_args>) = 0
[ ] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[ ] bind(3, {sa_family=AF_INET, sin_port=htons(<bind_port>), sin_addr=inet_addr("<bind_address>")}, 16) = 0
    - Bind to port 80
    - Bind to address 0.0.0.0
[ ] listen(3, 0) = 0
[ ] accept(3, NULL, NULL) = 4
[ ] fork() = <fork_result>
[ ] close(4) = 0
[ ] accept(3, NULL, NULL) = ?

===== Trace: Parent Process =====
[✓] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7fde2715eaf0 /* 0 vars */) = 0
[✓] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[✓] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[✓] listen(3, 0)                            = 0
[✓] accept(3, NULL, NULL)                   = 4
[✓] fork()                                  = 7
[✓] close(4)                                = 0
[✓] accept(3, NULL, NULL)                   = ?
[?] +++ killed by SIGKILL +++

===== Expected: Child Process =====
[ ] close(3) = 0
[ ] read(4, <read_request>, <read_request_count>) = <read_request_result>
[ ] open("<open_path>", O_WRONLY|O_CREAT, 0777) = 3
[ ] write(3, <write_file>, <write_file_count>) = <write_file_result>
[ ] close(3) = 0
[ ] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[ ] exit(0) = ?

===== Trace: Child Process =====
[✓] close(3)                                = 0
[✓] read(4, "POST /tmp/tmpj0vkv2jv HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.32.4\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\nContent-Length: 40\r\n\r\nzMTR6L8MUm2s4j3aSXZNwi8dZSfWzGUv2bkmnxlC", 1024) = 222
[✓] open("/tmp/tmpj0vkv2jv", O_WRONLY|O_CREAT, 0777) = 3
[✓] write(3, "zMTR6L8MUm2s4j3aSXZNwi8dZSfWzGUv2bkmnxlC", 40) = 40
[✓] close(3)                                = 0
[✓] write(4, "HTTP/1.0 200 OK\r\n\r\n", 19) = 19
[?] write(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 40) = 40
[?] close(4)                                = 0
[✓] exit(0)                                 = ?
[?] +++ exited with 0 +++

===== Result =====
[✓] Success

pwn.college{EKhYMgr69gguWt6-MEy12dCuxuK.QX5QzMzwyMyITOyEzW}
```

## web server

```
hacker@building-a-web-server~web-server:~$ cat /challenge/DESCRIPTION.md && cat asm.s && ./assemble.sh asm.s && /challenge/run a.out
In the final challenge, your server must seamlessly support both GET and POST requests within a single program.
After reading the incoming request using [read](https://man7.org/linux/man-pages/man2/read.2.html), your server will inspect the first few characters to determine whether it is dealing with a GET or a POST.
Depending on the request type, it will process the data accordingly and then send back an appropriate response using [write](https://man7.org/linux/man-pages/man2/write.2.html).
Throughout this process, [fork](https://man7.org/linux/man-pages/man2/fork.2.html) is employed to handle each connection concurrently, ensuring that your server can manage multiple requests at the same time.
After completing this, you will have built a simple, but fully functional, web server capable of handling different types of HTTP requests.
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer
fpath:
        .space 64       # allocate 64 bytes for file_path string
content:
        .space 256      # allocate 256 bytes for temporary file content
psdata:
        .space 256      # allocate 256 bytes for POST data

.section .data
http_ok:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov r8, rax    # r8 = sockfd

        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rdi, r8
        mov rsi, rsp
        mov rdx, 0x10
        syscall

        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rdi, r8
        mov rsi, 0      # backlog = 0
        syscall

.accept_request_loop:

        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rdi, r8
        mov rsi, 0
        mov rdx, 0
        syscall
        mov r9, rax    # r9 = connfd

        # pid_t fork()
        mov rax, 57
        syscall
        mov r15, rax    # r15 = pid

        cmp r15, 0      # if != 0: parent, if == 0: child
        je .child_process

.parent_process:
        # close the connection just accepted, let the child handle it
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        jmp .accept_request_loop

.child_process:
        # close the sockfd
        # close(int fd)
        mov rax, 3
        mov rdi, r8
        syscall

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r9
        mov rsi, offset buffer
        mov rdx, 1024
        syscall
        mov r14, rax    # r14 = request_len

        # void interpret_request(char *buffer, char *fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call interpret_request
        mov r13, rax    # r13 = 0 if GET else 1

        cmp r13, 0
        je .main_get_request

.main_post_request:
        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0x41 # O_CREAT | O_WRONLY = 0x41
        mov rdx, 0x1ff # 0777 = 0x1ff, mode rwxrwxrwx
        syscall
        mov r10, rax    # r10 = filefd

        # void get_post_data(char *buffer, int buffer_len, char *post_data)
        mov rdi, offset buffer
        mov rsi, r14
        mov rdx, offset psdata
        call get_post_data

        # write(int filefd, post_data, count)
        mov rdx, rax    # psdata_length
        mov rax, 1
        mov rdi, r10
        mov rsi, offset psdata
        syscall
        mov r12, rax    # r12 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

        jmp .exit

.main_get_request:
        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0      # O_RDONLY = 0
        mov rdx, 0
        syscall
        mov r10, rax    # r10 = filefd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r10
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov r12, rax    # r12 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

.exit:
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

get_post_data:
        # void get_post_data(char *buffer, int buffer_len, char *post_data)
        # rdi = buffer (full request)
        # rsi = buffer_len
        # rdx = post_data (output)
        push rbp
        mov rbp, rsp

        push rdi
        sub rsi, 4  # subtract 4 chars of total length, because of "\r\n\r\n"

        # init i = 0
        xor rcx, rcx

.loop_ini:
        # skip "\r\n\r\n"
        cmp rcx, rsi
        ja .loop_end

        mov rbx, [rbp-0x8]      # buffer = rbp-0x8
        add rbx, rcx    # rbx = buffer + i
        mov rdi, rbx
        call contain_rnrn
        cmp rax, 0
        jne .loop_end

        inc rcx
        jmp .loop_ini

.loop_end:
        pop rdi
        add rsi, 3      # put rsi at the last character of buffer: buffer_len - 1
        add rcx, 4      # jump 4 chars, where the post_data starts

        # the correct length of post_data
        mov rax, rsi
        add rax, 1
        sub rax, rcx

.copy_ini:
        cmp rcx, rsi
        ja .copy_end
        mov bl, BYTE PTR [rdi+rcx]
        mov BYTE PTR [rdx], bl
        inc rcx
        inc rdx
        jmp .copy_ini

.copy_end:
        mov BYTE PTR [rdx], 0x00 # null byte
        mov rsp, rbp
        pop rbp
        ret

contain_rnrn:
        # int get_post_data(char *buffer)
        # rdi = char pointer to see if it matches "\r\n\r\n"
        push rbp
        mov rbp, rsp

        push rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xd     # \r = 0xd, \n = 0xa
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xa     # \n = 0xa
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xd     # \r = 0xd
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xa     # \n = 0xa
        jne .return_false

        # return true
        mov rax, 1
        jmp .end

.return_false:
        mov rax, 0

.end:
        pop rdi
        mov rsp, rbp
        pop rbp
        ret

interpret_request:
        # int interpret_request(char *buffer, char *fpath)
        # rdi = buffer (full request)
        # rsi = fpath (output)
        # return value: 0 if GET, 1 if POST
        push rbp
        mov rbp, rsp

        mov al, BYTE PTR [rdi]
        cmp al, 0x47    # 'G' = 0x47
        je .get_request

.post_request:
        mov rax, 1
        push rax
        mov rdx, 5
        jmp .parse_file_path

.get_request:
        mov rax, 0
        push rax
        mov rdx, 4

.parse_file_path:
        lea rcx, [rdi+rdx]       # skip "GET " or "POST "

.loop:
        mov al, BYTE PTR [rcx]
        cmp al, 0x20           # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rcx
        inc rsi
        jmp .loop

.done:
        mov BYTE PTR [rsi], 0  # null terminate
        pop rax

        mov rsp, rbp
        pop rbp
        ret

===== Welcome to Building a Web Server! =====
In this series of challenges, you will be writing assembly to interact with your environment, and ultimately build a web server
In this challenge you will respond to multiple concurrent GET and POST requests.

Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP GET request
Performing operation: HTTP POST request
Performing operation: HTTP POST request
Performing operation: HTTP GET request
Performing operation: connect

===== Expected: Parent Process =====

===== Trace: Parent Process =====
[?] execve("/proc/self/fd/3", ["/proc/self/fd/3"], 0x7f1682f6da60 /* 0 vars */) = 0
[?] socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
[?] bind(3, {sa_family=AF_INET, sin_port=htons(80), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[?] listen(3, 0)                            = 0
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 7
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 8
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 9
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 10
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 11
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 12
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 13
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 14
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 15
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 16
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 17
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 18
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 19
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 20
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 21
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 22
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 23
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 24
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 25
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 26
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 27
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 28
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 29
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 30
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 31
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 32
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 33
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 34
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 35
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 36
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 37
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 38
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = 4
[?] fork()                                  = 39
[?] close(4)                                = 0
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] accept(3, NULL, NULL)                   = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[?] --- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
[?] +++ killed by SIGALRM +++

===== Result =====
[✓] Success

pwn.college{0md_I71eFxSKUYWQ7g_NWNlEwlg.QXwUzMzwyMyITOyEzW}
```

# Web Server Assembly Code

```asm
.intel_syntax noprefix
.global _start

.section .bss
buffer:
        .space 1024     # allocate 1KB buffer
fpath:
        .space 64       # allocate 64 bytes for file_path string
content:
        .space 256      # allocate 256 bytes for temporary file content
psdata:
        .space 256      # allocate 256 bytes for POST data

.section .data
http_ok:
        .asciz "HTTP/1.0 200 OK\r\n\r\n"

.section .text
_start:
        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41
        mov rdi, 2
        mov rsi, 1
        mov rdx, 0
        syscall
        mov r8, rax    # r8 = sockfd

        # __pad[8] = {0}
        mov rax, 0
        push rax
        # AF_INET (16bit), port 80 (16bit), ip_addr 0.0.0.0 (32bit)
        mov rax, 0x0000000050000002 
        push rax
        # bind(sockfd, addr, addrlen)
        mov rax, 49
        mov rdi, r8
        mov rsi, rsp
        mov rdx, 0x10
        syscall

        # listen(int sockfd, int backlog)
        mov rax, 50
        mov rdi, r8
        mov rsi, 0      # backlog = 0
        syscall

.accept_request_loop:

        # accept(sockfd, addr = NULL, addrlen = NULL)
        mov rax, 43
        mov rdi, r8
        mov rsi, 0
        mov rdx, 0
        syscall
        mov r9, rax    # r9 = connfd

        # pid_t fork()
        mov rax, 57
        syscall
        mov r15, rax    # r15 = pid

        cmp r15, 0      # if != 0: parent, if == 0: child
        je .child_process

.parent_process:
        # close the connection just accepted, let the child handle it
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        jmp .accept_request_loop

.child_process:
        # close the sockfd
        # close(int fd)
        mov rax, 3
        mov rdi, r8
        syscall

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r9
        mov rsi, offset buffer
        mov rdx, 1024
        syscall
        mov r14, rax    # r14 = request_len

        # void interpret_request(char *buffer, char *fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call interpret_request
        mov r13, rax    # r13 = 0 if GET else 1

        cmp r13, 0
        je .main_get_request

.main_post_request:
        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0x41 # O_CREAT | O_WRONLY = 0x41
        mov rdx, 0x1ff # 0777 = 0x1ff, mode rwxrwxrwx
        syscall
        mov r10, rax    # r10 = filefd

        # void get_post_data(char *buffer, int buffer_len, char *post_data)
        mov rdi, offset buffer
        mov rsi, r14
        mov rdx, offset psdata
        call get_post_data

        # write(int filefd, post_data, count)
        mov rdx, rax    # psdata_length
        mov rax, 1
        mov rdi, r10
        mov rsi, offset psdata
        syscall
        mov r12, rax    # r12 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

        jmp .exit

.main_get_request:
        # open(char *path, int flags, int mode)
        mov rax, 2
        mov rdi, offset fpath
        mov rsi, 0      # O_RDONLY = 0
        mov rdx, 0
        syscall
        mov r10, rax    # r10 = filefd

        # read(int fd, buf, count)
        mov rax, 0
        mov rdi, r10
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov r12, rax    # r12 = length(content)

        # close(int fd)
        mov rax, 3
        mov rdi, r10
        syscall

        # write(int connfd, char *buf, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(int connfd, char *fpath, size_t count)
        mov rax, 1
        mov rdi, r9
        mov rsi, offset content
        mov rdx, r12
        syscall

.exit:
        # close(int fd)
        mov rax, 3
        mov rdi, r9
        syscall

        # exit(0)
        mov rax, 60
        mov rdi, 0
        syscall

get_post_data:
        # void get_post_data(char *buffer, int buffer_len, char *post_data)
        # rdi = buffer (full request)
        # rsi = buffer_len
        # rdx = post_data (output)
        push rbp
        mov rbp, rsp

        push rdi
        sub rsi, 4  # subtract 4 chars of total length, because of "\r\n\r\n"

        # init i = 0
        xor rcx, rcx

.loop_ini:
        # skip "\r\n\r\n"
        cmp rcx, rsi
        ja .loop_end

        mov rbx, [rbp-0x8]      # buffer = rbp-0x8
        add rbx, rcx    # rbx = buffer + i
        mov rdi, rbx
        call contain_rnrn
        cmp rax, 0
        jne .loop_end

        inc rcx
        jmp .loop_ini

.loop_end:
        pop rdi
        add rsi, 3      # put rsi at the last character of buffer: buffer_len - 1
        add rcx, 4      # jump 4 chars, where the post_data starts

        # the correct length of post_data
        mov rax, rsi
        add rax, 1
        sub rax, rcx

.copy_ini:
        cmp rcx, rsi
        ja .copy_end
        mov bl, BYTE PTR [rdi+rcx]
        mov BYTE PTR [rdx], bl
        inc rcx
        inc rdx
        jmp .copy_ini

.copy_end:
        mov BYTE PTR [rdx], 0x00 # null byte
        mov rsp, rbp
        pop rbp
        ret

contain_rnrn:
        # int get_post_data(char *buffer)
        # rdi = char pointer to see if it matches "\r\n\r\n"
        push rbp
        mov rbp, rsp

        push rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xd     # \r = 0xd, \n = 0xa
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xa     # \n = 0xa
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xd     # \r = 0xd
        jne .return_false
        inc rdi

        mov al, BYTE PTR [rdi]
        cmp al, 0xa     # \n = 0xa
        jne .return_false

        # return true
        mov rax, 1
        jmp .end

.return_false:
        mov rax, 0

.end:
        pop rdi
        mov rsp, rbp
        pop rbp
        ret

interpret_request:
        # int interpret_request(char *buffer, char *fpath)
        # rdi = buffer (full request)
        # rsi = fpath (output)
        # return value: 0 if GET, 1 if POST
        push rbp
        mov rbp, rsp

        mov al, BYTE PTR [rdi]
        cmp al, 0x47    # 'G' = 0x47
        je .get_request

.post_request:
        mov rax, 1
        push rax
        mov rdx, 5
        jmp .parse_file_path

.get_request:
        mov rax, 0
        push rax
        mov rdx, 4

.parse_file_path:
        lea rcx, [rdi+rdx]       # skip "GET " or "POST "

.loop:
        mov al, BYTE PTR [rcx]
        cmp al, 0x20           # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rcx
        inc rsi
        jmp .loop

.done:
        mov BYTE PTR [rsi], 0  # null terminate
        pop rax

        mov rsp, rbp
        pop rbp
        ret
```
