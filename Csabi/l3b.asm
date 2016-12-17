;Kurkó Tamás, ktam0119, 621
;L2
;Iras/Olvasas


%include 'mio.inc'
;bitstring= 32 bites egesz=bitsorozat szamban eltarolva

;32-bit:
;								  .....
;A = 		0101010001101101000101010100
;A[5:1] = 	0000000000000000000000001010

;16-bit
;C = A[11:8], B[3:0] OR B[7:4], A[15:8]
;A = 1010101010101010
;B = 1111101110101001

;                    ....
;A[11:8]=0000000000001010
;C =     1010000000000000  balra tolas utan 12 bittel
;        ^^^^

;B[3:0]=0000000000001001
;                   ^^^^

;B[7:4]=0000000000001010
;                   ^^^^

;B[3:0] OR B[7:4]=0000000000001011
;                             ^^^^

;                 0000101100000000
;                     ^^^^

;OR
;C=               1010101100000000
;                 ^^^^^^^^
;OR
;                 0000000010101010
;OR
;C=               1010101110101010
;                 ^^^^^^^^^^^^^^^^



;   0000000000001011
;   +
;   0000000000001001
;=  0000000000010100
;               ^^^^
;         AND
;   0000000000001111
;         =
;   0000000000000100


;1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0






;Stringek:

;ket tarolasi mod:
;fdsfdsgfdgdsgfdsgs0 a vegen 0as van
; 3abc az elejen irja a byte-ok szamat

;lodsb -load string byte, betolti a karaktereket

;az esiben kell legyen egy pointer

;ezt csinalja a loadsb:
; mov al, [esi]
; inc esi   

;stosb - store string byte

;ezt csinalja az stosb
;mov [edi], al
;inc edi

;movsb :
;memoriabol memoriaba masol

;mov ?l, [esi]
;mov [edi], ?l
;inc esi
;inc edi




global main

section .text

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
	call 	mio_writeln
.vege:
	ret
	
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
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax

	ret

bin:
	call 	mio_writeln
	
	push	eax
	push 	ebx
	push 	ecx
	push 	edx
	
	
	mov 	ebx, 2
	push 	dword -1
	xor 	ecx,ecx
	
.loop:
	xor 	edx, edx
	div 	ebx
	push	edx
	inc 	ecx
	test 	eax, eax
	jnz 	.loop
	
	
.zerok:
	xor 	ebx,ebx
	mov 	eax, 32
	sub 	eax,ecx						;kivonjuk a 32-bol hanyszor volt osztas,megkapjuk a kello 0-ak szamat
	mov 	ecx,eax
	xor 	ebx,ebx
	.zerok1:								;amig ecx!=0 addig megy a ciklus	
		mov 	eax, '0'
		call 	mio_writechar
		dec 	ecx						;ecx=ecx-1
		cmp 	ecx, 0
		jg 		.zerok1
		je 		.loop2
	

.loop2:	
	pop 	eax
	cmp 	eax, -1
	je		.vege
	add 	eax,'0'
	call 	mio_writechar
	jmp 	.loop2
	

	
.vege:
	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax
	ret

	

bin1:
	call 	mio_writeln
	push	eax
	push 	ebx
	push 	ecx
	push 	edx
	
	
	mov 	ebx, 2
	push 	dword -1
	xor 	ecx,ecx
	
.loop:
	xor 	edx, edx
	div 	ebx
	push	edx
	inc 	ecx
	test 	eax, eax
	jnz 	.loop
	

.loop2:	
	pop 	eax
	cmp 	eax, -1
	je		.vege
	add 	eax,'0'
	call 	mio_writechar
	jmp 	.loop2
	

	
.vege:
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
	sub	edx,4

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
	;A beolvas
	mov		eax, str_h1
	call	mio_writestr
	call 	hexabeolvas
	call 	mio_writeln
	
	mov 	[A], ebx
	mov		ecx, ebx			;ebx-be van az eredmeny hexabeolvasas utan
		
	mov 	eax, str_hexakiir
	call 	mio_writestr
	call 	hexakiir
	
	call 	mio_writeln
	mov 	eax, str_binkiir
	call 	mio_writestr
	
	mov 	eax,[A] 		;ebx-be az eredmeny beolvasas utan
	call 	bin

	;B beolvas
	call 	mio_writeln
	mov		eax, str_h2
	call	mio_writestr
	call 	hexabeolvas
	call 	mio_writeln
	
	mov 	[B], ebx
	mov		ecx, ebx			;ebx-be van az eredmeny hexabeolvasas utan
		
	mov 	eax, str_hexakiir
	call 	mio_writestr
	call 	hexakiir
	
	call 	mio_writeln
	mov 	eax, str_binkiir
	call 	mio_writestr
	
	mov 	eax,[B] 		;ebx-be az eredmeny beolvasas utan
	call 	bin
	
	;C beolvas
	call 	mio_writeln
	mov		eax, str_h3
	call	mio_writestr
	call 	hexabeolvas
	call 	mio_writeln
	
	mov 	[C], ebx
	mov		ecx, ebx			;ebx-be van az eredmeny hexabeolvasas utan
		
	mov 	eax, str_hexakiir
	call 	mio_writestr
	call 	hexakiir
	
	call 	mio_writeln
	mov 	eax, str_binkiir
	call 	mio_writestr
	
	mov 	eax,[C] 		;ebx-be az eredmeny beolvasas utan
	call 	bin
	call 	mio_writeln
	
	call 	mio_writeln
	mov 	eax, str_eredmeny
	call 	mio_writestr
	call 	mio_writeln
	
;Muveletek:
	
	
	;B[23:16]
	mov 	eax, [B]
	rol 	eax,8
	shr 	eax,24
	call 	bin
	mov 	edi, eax		;edi-ben az eredmeny
	
	
	;B[24:24]
	mov 	eax,[B]
	rol 	eax, 7
	shr 	eax, 31
	;call 	bin
	mov 	[b24_24], eax
	
	;B[11:11]
	mov 	eax,[B]
	rol 	eax,20
	shr 	eax,31
	;call 	bin1
	
	;B[24:24] + B[11:11]
	mov 	ecx, [b24_24]
	add 	eax, ecx
	mov 	[osszeg],eax
	call 	bin
	shl 	edi,1
	add 	edi,eax		
	
	
	
	;C[12:11]
	mov 	eax, [C]
	rol 	eax, 19
	shr 	eax, 30
	mov 	[c12_11],eax
	;call 	bin1
	
	;B[8:7]
	mov 	eax,[B]
	rol 	eax,23
	shr 	eax,30
	;call 	bin1
	
	;C[12:11] XOR B[8:7]
	mov  	ecx, [c12_11]
	xor 	ecx, eax
	mov 	eax, ecx
	call 	bin
	shl 	edi, 2
	add 	edi, eax
	
	;C[13:4]
	mov 	eax, [C]
	rol 	eax, 18
	;call 	bin
	shr 	eax, 22
	call 	bin
	shl 	edi, 10
	add 	edi, eax
	
	;B[29:26]
	mov 	eax,[B]
	rol 	eax,2
	shr 	eax, 28
	;call 	bin
	mov 	[b29_26], eax
	
	
	
	;A[22:19]
	mov 	eax,[A]
	rol 	eax,9
	shr 	eax,28
	;call 	bin
	
	;B[29:26] AND A[22:19]
	mov 	ecx,[b29_26]
	and 	ecx,eax
	mov 	eax,ecx
	call 	bin
	shl  	edi, 4
	add 	edi, eax
	
	;B[28:22] 
	mov 	eax,[B]
	rol 	eax, 3
	shr 	eax, 25
	call 	bin
	shl 	edi,7
	add 	edi, eax
	
	mov 	eax,edi
	call 	mio_writeln
	;call 	ki_bin
	
	call 	bin
	

	
	ret
section .data
	str_h1			db 'A = ', 0
	str_h2 			db 'B = ', 0
	str_h3 			db 'C = ', 0
	str_hexakiir	db 'Hexadecimalis alakban:   '  , 0
	str_binkiir 	db 'Binaris alakban: ', 0
	str_eredmeny 	db 'Eredmeny: ', 0
	str_hiba		db 'Hiba: nem szam!' , 0
	A 				dd 			0
	B				dd 			0
	C 				dd 			0
	b24_24			dd 			0
	osszeg 			dd 			0
	c12_11			dd 			0
	b29_26 			dd 			0
	