bits 16
easy_print:
    .loop:
        lodsb
        mov ah, 0x0E
        cmp al, 0
        je .done
        int 0x10
        jmp .loop
    .done:
        ret
