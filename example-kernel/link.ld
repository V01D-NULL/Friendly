OUTPUT_FORMAT(elf32-little)
ENTRY(entry)

SECTIONS
{
    . = 0x10000;
    .text :
    {
        *(.text)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(.bss)
    }

    .rodata :
    {
        *(.rodata)
    }
}