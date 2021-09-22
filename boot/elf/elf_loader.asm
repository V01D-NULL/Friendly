bits 32
section .text
ELF_MAGIC equ 0x464c457f ; 0x7F ELF encoded in LE format
PT_LOAD equ 1

; Perform basic sanity checks on the elf header and return, panics if there is something wrong with the elf
verify_elf_header:
    ; Header magic
    mov ax, word [elf]
    cmp ax, ELF_MAGIC
    je .valid_header_magic

    .invalid_header_magic:
        panic "Invalid header magic!"

    .valid_header_magic:
        
    ; 32 or 64 bit?
    mov ah, byte [elf+4]
    cmp ah, 1
    je .32bit
    .no_64bit_support:
        panic "64 bit kernels are not supported!"

    .32bit:

    mov ah, byte [elf+16]
    cmp ah, 2 ; Check elf against type 2 (Executable)
    je .elf_executable
    
    .elf_not_executable:
        panic "This is not an executable ELF file!"

    .elf_executable:

    ; Check instruction set
    mov ah, byte [elf+18]
    cmp ah, 0
    je .no_specific_instruction_set

    .not_x86_instruction_set:
        panic "The instruction set of this ELF file is neither x86 nor not specific!"

    .no_specific_instruction_set:
        logwarn "No specific instruction set has been detected, assuming x86..."
    
    ; Program entry position
    mov eax, dword [elf+24]
    cmp eax, 0
    jne .valid_entry_position
    .no_entry_position:
        panic "The entry address of the ELF file is 0!"

    .valid_entry_position:
        mov [elf_entry_address], eax
    
    puts "verify_elf", "Valid ELF header"
    ret

; Load the program headers
elf_load_phdrs:
    puts "load_phdrs", "Loading phdrs"
    
    mov [elf_found_loadable_phdr], byte 0 ; found_loadable_phdr = false

    ; Program header table position (e_phoff)
    xor eax, eax
    mov eax, dword [elf+28]
    cmp eax, 0
    jne .phdr_exists
    .phdr_does_not_exist:
        panic "There is no program header for this ELF file!"
    .phdr_exists:
    ; elf_phdr_offset is just an offset into the file which is why the address of `elf` is added to eax
    mov ebx, elf
    add eax, ebx
    mov [elf_phdr_offset], eax
    
    ; Number of program headers (e_phnum)
    mov ah, byte [elf+44]
    xor bh, bh
    mov ecx, dword [elf_phdr_offset]
    
    .next_header:
        ; Check against PT_LOAD
        cmp [ecx], byte PT_LOAD
        jne .segment_not_loadable
        
        ; Segment is loadable
        puts "load_phdrs", "Found a loadable segment"
        mov [elf_found_loadable_phdr], byte 1 ; Found a loadable segment, this tell's friendly not to panic after it finished parsing all segments

        ; Segment is not loadable, ignore it and try the next
        .segment_not_loadable:
        add [ecx], edx

        inc bh
        cmp bh, ah
        jl .next_header

    ; Was there at least one segment with the type PT_LOAD (1)?
    cmp [elf_found_loadable_phdr], byte 1
    je .loadable_headers_detected
    .no_loadable_headers_detected:
        panic "No phdr with type PT_LOAD (1) was detected!"

    ; Loadable headers have been detected, do nothing
    .loadable_headers_detected:

    ret

section .data
elf:
    incbin "elf/kernel.elf"

elf_phdr_offset:
    dd 0

; Number of entries in the program header table
elf_phnum:
    db 0

; Size of an entry in the program header
elf_phdr_entry_size:
    db 0

elf_entry_address:
    dw 0

; If this is 1, at least a single phdr has been found, otherwise none have been found and Friendly will panic
elf_found_loadable_phdr:
    db 0