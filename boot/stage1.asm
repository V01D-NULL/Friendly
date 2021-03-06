bits 16
org 0x7c00

mov [bootdrive], dl
jmp 0x0000:friendly_entry

friendly_entry:
    xor ax, ax
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov es, ax
    mov ss, ax
    mov bp, 0x9000
    mov sp, bp
    
    ; Enable a20
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Clear screen
    mov ah, 0
    mov al, 3
    int 0x10

    jmp stage1_load

bootdrive:
    db 0x0

stage1_load:
    ; Load extended realmode code from disk
    mov bx, extended
    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov dl, [bootdrive]
    int 0x13
    jc disk_error
    
    jmp extended
    jmp $


bits 16
disk_error:
    mov si, disk_err
    call easy_print
    hlt
    jmp $

disk_err: db "Error reading from disk", 0

%include "handover.asm"
%include "rm/print16.asm"
%include "pm/gdt32.asm"

times 510-($-$$) db 0
dw 0xaa55

extended:
    call fill_handover
    switch32 stage2_load
    jmp $
    
%include "boot/stage2.asm"
