bits 32

VGA_BASE equ 0xb8000
offset: dd 0
cursor_x: dw 0
cursor_y: dw 0

vga_init:
    mov edi, VGA_BASE
    mov [offset], edi
    ret

%macro puts 1
    jmp %%doprint
    %%string: db "(Friendly) ", %1, 0
    
    %%doprint:
    mov esi, %%string
    call _puts
%endmacro

; Parameters:
; si = string
_puts:    
    mov edi, [offset]
    .loop:
        lodsb
        cmp al, 0
        je .done

        or ah, 0xF ; Color: White on black
        mov [edi], ax
        add edi, 2
        inc word [cursor_x]

        jmp .loop

    .done:
        call putln
        ret


; Update the vga address 'offset' to print characters on a newline
; Calculation: offset = 0xb8000 + (y * 80 + x)
putln:
    pusha
    add [cursor_y], word 2
    mov [cursor_x], word 0

    mov ax, [cursor_y]
    mov cx, 80
    mul cx

    mov bx, [cursor_x]
    add bx, ax

    add bx, VGA_BASE

    mov [offset], bx
    popa
    ret

