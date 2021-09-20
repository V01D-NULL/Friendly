; Todo: Put in trivial things such as a memory map, vesa, etc
struc Handover
    .value:  resw 1
endstruc

fill_handover:
    mov [Handover.value], word 0x1234
    ret