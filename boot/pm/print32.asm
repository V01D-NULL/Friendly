bits 32

VGA_BASE equ 0xb8000
offset: db 0
cursor_x: db 0
cursor_y: db 0

vga_init:
    mov edi, VGA_BASE
    mov [offset], edi
    ret

;
; offset = vga_base + (y * 80 + x)
;

; Parameters:
; si = string
puts:
    mov edi, [offset]
    mov ebx, [cursor_x]
    mov edx, [cursor_y]

    .loop:
        lodsb
        cmp al, 0
        je .done

        or ah, 0xF ; Color: White on black
        mov [edi], eax
        
        mov eax, 2
        add edi, eax
        
        jmp .loop

    .done:
        mov [offset], edi
        mov [cursor_x], ebx
        mov [cursor_y], edx
        ret

putln:
    
    ret