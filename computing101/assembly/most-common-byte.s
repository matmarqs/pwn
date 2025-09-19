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
