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
        # make stack frame for locals (keep it aligned)
        sub rsp, 0x80

        # socket(AF_INET = 2, SOCK_STREAM = 1, 0)
        mov rax, 41          # sys_socket
        mov rdi, 2           # AF_INET
        mov rsi, 1           # SOCK_STREAM
        mov rdx, 0           # protocol
        syscall
        mov QWORD PTR [rsp+0x00], rax   # save sockfd

        # prepare sockaddr_in on stack at rsp+0x20 (16 bytes)
        # layout: 2 bytes family, 2 bytes port (network), 4 bytes addr, 8 bytes zero/padding
        # We'll write the 8-byte low and high halves as qwords.
        # Create qword value as before: 0x0000000050000002
        mov rax, 0x0000000050000002
        mov QWORD PTR [rsp+0x20], rax
        mov QWORD PTR [rsp+0x28], 0x0

        # bind(sockfd, &sockaddr, 16)
        mov rax, 49          # sys_bind
        mov rdi, QWORD PTR [rsp+0x00]   # sockfd
        lea rsi, [rsp+0x20]  # pointer to sockaddr
        mov rdx, 0x10        # addrlen = 16
        syscall

        # listen(sockfd, backlog=0)
        mov rax, 50          # sys_listen
        mov rdi, QWORD PTR [rsp+0x00]
        mov rsi, 0           # backlog
        syscall

        # accept(sockfd, NULL, NULL)
        mov rax, 43          # sys_accept
        mov rdi, QWORD PTR [rsp+0x00]
        mov rsi, 0
        mov rdx, 0
        syscall
        mov QWORD PTR [rsp+0x08], rax   # save connfd

        # read(connfd, buffer, 1024)
        mov rax, 0           # sys_read
        mov rdi, QWORD PTR [rsp+0x08]
        mov rsi, offset buffer
        mov rdx, 1024
        syscall

        # call get_file_path(buffer, fpath)
        mov rdi, offset buffer
        mov rsi, offset fpath
        call get_file_path

        # open(fpath, O_RDONLY)
        mov rax, 2           # sys_open
        mov rdi, offset fpath
        mov rsi, 0           # O_RDONLY
        mov rdx, 0
        syscall
        mov QWORD PTR [rsp+0x10], rax   # save filefd

        # read(filefd, content, 256)
        mov rax, 0           # sys_read
        mov rdi, QWORD PTR [rsp+0x10]
        mov rsi, offset content
        mov rdx, 256
        syscall
        mov QWORD PTR [rsp+0x18], rax   # save length read

        # close(filefd)
        mov rax, 3           # sys_close
        mov rdi, QWORD PTR [rsp+0x10]
        syscall

        # write(connfd, http_ok, 19)
        mov rax, 1           # sys_write
        mov rdi, QWORD PTR [rsp+0x08]
        mov rsi, offset http_ok
        mov rdx, 19
        syscall

        # write(connfd, content, content_len)
        mov rax, 1           # sys_write
        mov rdi, QWORD PTR [rsp+0x08]
        mov rsi, offset content
        mov rdx, QWORD PTR [rsp+0x18]
        syscall

        # close(connfd)
        mov rax, 3           # sys_close
        mov rdi, QWORD PTR [rsp+0x08]
        syscall

        # restore stack and exit(0)
        add rsp, 0x80
        mov rax, 60          # sys_exit
        xor rdi, rdi
        syscall

# get_file_path: rdi = buffer (request), rsi = fpath (output)
get_file_path:
        # skip the method and the following space: find first space, then skip it
        # To be method-agnostic we scan for first space, then start copying after it.
        push rbp
        mov rbp, rsp

        mov rdx, rdi        # rdx = pointer into buffer
.find_space:
        mov al, BYTE PTR [rdx]
        cmp al, 0x20        # space?
        je .after_space
        inc rdx
        jmp .find_space

.after_space:
        inc rdx             # now rdx points at first char of path (e.g. '/')

.copy_loop:
        mov al, BYTE PTR [rdx]
        cmp al, 0x20        # stop at next space
        je .done
        mov BYTE PTR [rsi], al
        inc rdx
        inc rsi
        jmp .copy_loop

.done:
        mov BYTE PTR [rsi], 0
        mov rsp, rbp
        pop rbp
        ret
