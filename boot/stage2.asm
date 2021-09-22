%include "pm/print32.asm"

stage2_load:
  cld
  lidt [ivtptr]
  call vga_init

  puts "stage2", "Loaded stage2"
  call verify_elf_header
  call elf_load_phdrs

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

%include "elf/elf_loader.asm"