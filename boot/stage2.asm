bits 32
stage2_load:
  cld
  call vga_init
  
  mov esi, pmmode
  call puts

  jmp $

pmmode: db "(Friendly) Loaded stage2", 0

ivt:
    dw 0
    dd 0
_ivt:

ivtptr:
    dw _ivt - ivt - 1
    dd 0

%include "boot/pm/print32.asm"