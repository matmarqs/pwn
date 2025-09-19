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
