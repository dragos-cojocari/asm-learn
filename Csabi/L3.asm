;Szabo Csaba, scam0124, 621
;L2

%include 'mio.inc'

global main

section .text

hexakiir:
	push 	eax
	push 	ebx
	push 	ecx
	push 	edx
	
	;0x kiirasa
	mov 	eax,'0'
	call 	mio_writechar
	mov 	eax, 'x'
	call 	mio_writechar
	
	mov 	eax,ecx
	mov 	ebx, 16
	push 	dword -1
	xor 	ecx,ecx
	cmp 	eax, 0
	jge 	.pozciklus
	jl 		.negciklus
	
	
.pozciklus:								;ha a szam pozitiv
	xor 	edx,edx
	div 	ebx
	push 	edx
	inc 	ecx							;ecx=ecx+1
	test 	eax,eax
	jnz 	.pozciklus					;jump if not zero
	
	;0-ak kiirasa
	mov 	eax,8
	sub 	eax,ecx						;kivonjuk a 8-bol hanyszor volt osztas,megkapjuk a kello 0-ak szamat
	mov 	ecx,eax
	cmp 	ecx,0						;ha 8 osztas volt akkor nem kell egy nullat sem rakni
	je 		.ciklus						;jump if equal
	.zerok:								;amig ecx!=0 addig megy a ciklus	
		mov 	eax, '0'
		call 	mio_writechar
		dec 	ecx						;ecx=ecx-1
		cmp 	ecx,0
		jg 		.zerok					;jump if greater
		jmp 	.ciklus					;beugrunk a verem atdolgozasara

.negciklus:								;ha a szam negativ maskepp szamolunk,nem kell nullakat rakni az eredmeny elejebe
	xor 	edx,edx
	div 	ebx
	push 	edx
	inc 	ecx
	test 	eax,eax
	jnz 	.negciklus			;jump if not zero

	
;Kiszedjuk a verembol az elemeket eax-ba
.ciklus:
	pop 	eax
	cmp 	eax, -1			;ellenorizzuk ha a verem vegere ertunk
	je 		.vege
	cmp 	eax, 9
	jg		.betuk
	jle 	.szam
	jmp 	.ciklus
	
	.betuk:						;betuk konvertalasa
		add 	eax, 55
		call 	mio_writechar
		jmp 	.ciklus
		
	.szam:						;szam konvertalasa
		add 	eax,'0'
		call 	mio_writechar
		jmp 	.ciklus

	
.vege:
	call 	mio_writeln
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax

	ret

	
hexabeolvas:
	xor		eax, eax
	xor		ebx,ebx
	
.feldolgoz:
		call	mio_readchar
		call	mio_writechar
		
		cmp		eax, 13				;enterre vegere megyunk
		je		.vege	
		
		cmp		eax, '0'
		jl		.hiba
		cmp		eax, '9'
		jg		.nagybetu			;eloszor nagybetut dolgozzuk fel,az ASCII-ban hamarabb van mint a kisbetu
									;es emiatt konnyen lehet hibat kezelni
		sub		eax, '0'
		shl		ebx, 4				;binarisba 4 bittel csoportositunk, 4-es shiftelessel megkapjuk a szamot
		add		ebx, eax			;ebx-ben az eredmeny
		jmp 	.feldolgoz

		
	.nagybetu:
		;A-F kozott
		cmp		eax, 'A'
		jl		.hiba
		cmp		eax, 'F'
		jg		.kisbetu			
		
		sub		eax, 55
		shl		ebx, 4
		add		ebx, eax
		jmp		.feldolgoz
		
	.kisbetu:
		;a-f kozott
		cmp		eax, 'a'
		jl		.hiba
		cmp		eax, 'f'
		jg		.hiba
		
		sub		eax, 87
		shl		ebx, 4
		add		ebx, eax
		jmp		.feldolgoz
	
.hiba:
	call	mio_writeln
	mov 	eax, str_hiba
	call	mio_writestr
	call	mio_writeln
.vege:
	ret
	

bin:
	; save registers
	push	eax
	push 	ebx
	push 	ecx
	push 	edx
	
	mov 	ecx,32	; ECX will be the counter, 32 bits needed
	
.move_bits:

	mov al, '1'
	sal ebx, 1		; Shift left
	jc .print_bit	; if this is a 1 we already have '1' in AL, jump directly to printing the bit
	mov al, '0'		; this was a 0 ( Carry Flag not set)

.print_bit:

	call	mio_writechar	; print what is in AL '0' or '1'

	dec ecx					; decrement counter
	
	; check if current position is a multiple of 4 ( last 2 bits are 0 if the number is a multiple of 4)
	mov edx, ecx
	and edx, 3	; 3 is 00000011 in binary 
	jnz .check_finished
	
	mov al, ' '
	call	mio_writechar	; print space if the current char ends a 4 digit group
	
.check_finished:
	
	
	cmp ecx, 0				; check if finished
	jnz .move_bits			; continue the comparison if CX is not 0
	
.vege:
	call mio_writeln
	
	; restore registers
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
	ret

ki_bin:
	mov 	ecx,32
	mov 	edx,28

.loop:
	cmp 	ecx,0
	je 		.vege
	
	cmp 	ecx,edx
	je 		.szokoz
	jmp 	.nem_szokoz

.szokoz:
	mov 	al,' '
	call 	mio_writechar
	sub		edx,4

.nem_szokoz:
	
	shl 	eax,1
	jc 		.egy
	jmp 	.nulla

.egy:
	mov 	al,'1'
	dec 	ecx
	call 	mio_writechar
	jmp 	.loop
	
.nulla:
	mov 	al,'0'
	dec 	ecx
	call 	mio_writechar
	jmp 	.loop

.vege:

	ret

	
main:
	
	mov		eax, str_hexabe
	call	mio_writestr
	call 	hexabeolvas
	call 	mio_writeln
	
	mov 	[H1], ebx
	mov		ecx, ebx			;ebx-be van az eredmeny hexabeolvasas utan
		
	mov 	eax, str_hexakiir
	call 	mio_writestr
	call 	hexakiir
	
	mov 	eax,ebx
	call 	bin
	
	mov		eax, str_hexabe
	call	mio_writestr
	call 	hexabeolvas

	
	mov 	[H2], ebx
	mov		ecx, ebx			;ebx-be van az eredmeny hexabeolvasas utan
	
	mov 	eax, str_hexakiir
	call 	mio_writestr
	call 	hexakiir
	
	mov 	eax,ebx
	call 	bin
	
	mov 	eax, [H1]
	add 	eax, [H2]
	
	mov		ecx, eax			;ebx-be van az eredmeny hexabeolvasas utan
		
	mov 	eax, str_hexaosszeg
	call 	mio_writestr
	call 	hexakiir
	
	mov 	eax,ecx
	call 	bin
	

	
	
	ret
section .data
	str_hexakiir	db 'Hexadecimalis alakban:   '  , 0
	str_hexabe 		db 'Irj be egy hexadecimalis szamot: ', 0
	str_hexaosszeg	db 'Ket hexa szam osszege:   ', 0
	str_hiba		db 'Hiba: nem szam!' , 0
	H1				dd			0
	H2				dd			0