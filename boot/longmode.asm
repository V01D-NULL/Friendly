bits 32

paging_table_root equ 0x1000
pagesize equ 0x1000

configure_lm:
    mov eax, 0x80000001
    cpuid
    bt edx, 29
    jnc NoLongMode

    call create_initial_mapping

    ; PAE bit
    mov eax, cr4
    bts eax, 5
    mov cr4, eax

    ; Set LME
    mov ecx, 0xC0000080
    rdmsr
    bts eax, 8
    wrmsr

    ; Enable paging
    mov eax, cr0
    bts eax, 31
    mov cr0, eax

    ret

create_initial_mapping:
    mov edi, paging_table_root
    mov cr3, edi
    mov dword [edi], 0x2003
    add edi, pagesize
    mov dword [edi], 0x3003
    add edi, pagesize
    mov dword [edi], 0x4003
    add edi, pagesize

    mov eax, 0x3
    mov ecx, 512
    .fill:
        mov dword [edi], eax
        add eax, pagesize
        add edi, 8
        loop .fill
    ret

NoLongMode:
    mov esi, NoLongModeStr
    call puts
    hlt
    jmp $

NoLongModeStr: db "Long mode is not supported on this CPU, refusing to boot", 0