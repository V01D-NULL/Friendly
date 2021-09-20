%include "boot/pm/print32.asm"

stage2_load:
  cld
  call vga_init

  ; Using the non macro version of puts because it's easier for me (the git branch get's written to 'bootloader_msg')
  mov esi, bootloader_msg
  call _puts
  
  puts "Loaded stage2"
  
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


bootloader_msg: db "(Friendly) Version: b0c4dc2", 0
