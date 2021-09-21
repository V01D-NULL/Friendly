%include "pm/print32.asm"

stage2_load:
  cld
  call vga_init

  puts "Loaded stage2"
  call verify_elf

  ; This would be important boot info such as a memory map and be passed to the kernel
  ; mov eax, [Handover.value]

  jmp $

ivt:
    dw 0
    dd 0
_ivt:

ivtptr:
    dw _ivt - ivt - 1
    dd 0


%include "elf_loader.asm"