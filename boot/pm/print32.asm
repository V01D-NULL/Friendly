bits 32

VGA_BASE equ 0xb8000
offset: dd 0
cursor_x: dw 0
cursor_y: dw 0

vga_init:
    mov edi, VGA_BASE
    mov [offset], edi
    ret

%macro logwarn 1
    jmp %%do_print
    %%string: db "(Friendly) ", %1, 0

    %%do_print:
    mov esi, %%string
    mov ch, 0x0E
    call _puts
%endmacro

%macro puts 2
    jmp %%do_print
    %%string: db "(Friendly) <", %1, "> ", %2, 0
    
    %%do_print:
    mov esi, %%string
    mov ch, 0x0F ; White on black
    call _puts
%endmacro

%macro panic 1
    jmp %%do_print
    %%string: db "(Panic) ", %1, 0
    %%halted: db "Halted CPU", 0
    %%do_print:
        mov esi, %%string
        mov ch, 0x04 ; Red on black
        call _puts
        
        mov esi, %%halted
        call _puts
        hlt
        jmp $
    
%endmacro

; Parameters:
; si = string
_puts:
    pusha
    xor eax, eax

    mov edi, [offset]
    .loop:
        lodsb
        cmp al, 0
        je .done

        or ah, ch ; Set color
        mov [edi], ax
        add edi, 2
        inc word [cursor_x]

        jmp .loop

    .done:
        popa
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

