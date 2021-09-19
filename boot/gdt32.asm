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

SEG_CS equ __cs - gdt
SEG_DS equ __ds - gdt