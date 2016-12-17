del l3p.obj
del l3p.exe 

nasm -f win32 l3p.asm
nlink l3p.obj -lio -lmio -o l3p.exe

l3p.exe