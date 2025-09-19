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
