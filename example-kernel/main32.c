void entry()
{
    char *vram = (char*)0xb8000;
    *vram = 'X';
    
    for (;;);
}