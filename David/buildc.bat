del l3c.obj
del l3c.exe 

nasm -f win32 l3c.asm
nlink l3c.obj -lio -lmio -o l3c.exe

l3c.exe