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
