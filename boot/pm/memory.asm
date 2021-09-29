; memcpy(src, dest, n)
%macro memcpy 3
push edi
push esi
push ecx

cld
mov edi, %1 ; src
mov esi, %2 ; dest
mov ecx, %3 ; n
rep movsb

pop ecx
pop esi
pop edi
%endmacro

; memset(dest, val, n)
%macro memset 3
push edi
push eax
push ecx

cld
mov edi, %1
mov al, %2
mov ecx, %3
rep stosb

pop ecx
pop eax
pop edi
%endmacro

; memset0(dest, n)
%macro memset0 2
memset %1, 0, %2
%endmacro