bits 32
section .text
ELF_MAGIC equ 0x464c457f ; 0x7F ELF encoded in LE format

verify_elf:
    mov eax, dword [elf]
    cmp eax, ELF_MAGIC
    je .valid_header_magic

    .invalid_header_magic:
        panic "Invalid header magic!"

    .valid_header_magic:
        puts "Valid header magic"

    mov ah, byte [elf+4]
    cmp ah, byte 1
    je .32bit
    .no_64bit_support:
        panic "64 bit kernels are not supported yet"

    .32bit:

    mov ah, byte [elf+16]
    cmp ah, 2 ; Check elf against type 2 (Executable)
    je .elf_executable
    
    .elf_not_executable:
        panic "Bits 16-17 in the ELF file are not marked as exectable!"

    .elf_executable:
        puts "Elf is executable"

    ; Check instruction set
    mov ah, byte [elf+18]
    cmp ah, 0
    je .no_specific_instruction_set

    .not_x86_instruction_set:
        panic "The instruction set of this ELF file is neither x86 nor not specific!"

    .no_specific_instruction_set:
        puts "No specific instruction set has been detected, assuming x86..."

    ; Program entry position
    mov ebx, dword [elf+24]
    mov [elf_entry_address], ebx
    
    ret

elf:
    incbin "friendly-exec/kernel.elf"

elf_entry_address:
    dw 0