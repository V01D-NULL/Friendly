%ifndef GDT_32
%define GDT_32

gdt:
    dq 0
__cs:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0
__ds:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0
_gdt:

gdtptr:
    dw _gdt - gdt - 1
    dq gdt

%macro switch32 1
    cli
    lgdt [gdtptr]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    mov ax, SEG_DS
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov es, ax
    mov ss, ax
    jmp SEG_CS:%1
%endmacro


SEG_CS equ __cs - gdt
SEG_DS equ __ds - gdt

%endif