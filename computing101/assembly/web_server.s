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
