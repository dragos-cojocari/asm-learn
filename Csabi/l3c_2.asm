%include 'mio.inc'

;ab0cd1efgh

global main

section .text

A_kar:
	
	xor cx, cx
	mov esi, A
	mov edi, digits
	
; pass through the A array, identify all digits and write their positions in the digits array
; the positions are 1 based not 0 based
.loop:
	lodsb				; read the current char from the array
	cmp 	al,0		; check string end`
	je 		.stringend
	
	cmp 	al,'0'		; check if digit
	jle 	.notdigit
	
	cmp 	al,'9'		; check if digit
	jge 	.notdigit
	
	mov eax, esi		; calculate the pozition of the char in the array ( current ESI value minus start of array)
	sub eax, A		
	
	stosb				; store result in digits array
	inc cx

.notdigit:
	jmp .loop
	
; store the string end as well in the digit array
.stringend:
	mov eax, esi
	sub eax, A
	stosb
	inc cx
	
; find max substring
.find_max:	
	mov esi, digits		; start at the beginning of digits
	
	xor edx, edx		; contains the position of the previous digit
	
	
.substr:
	
	xor ebx, ebx
	
	lodsb				; load the position from the digit array
	
	mov ebx, eax		; save the value as AX will be modified
	
	sub al, dl			; calculate the size of the current string: current pos (AX) - previous pos (DX)
	sub al, 1			; remember indexes are 1 based 
	
	cmp [max_hossz], al	; check if this is better than max

	jge .notbigger
	
	; bigger
	mov [max_hossz], al	; store current size as max size	
	mov [max_start], dl ; store current pos (saved in DX) as max substring start position
	
	
.notbigger:

	mov edx, ebx		; save current start for next iteration

	loop .substr 
	
	; print largest substring

	mov esi, A
	add esi, [max_start]
	mov ecx, [max_hossz]

	mov edi, szamok
	
	cmp ecx, 0
	je .empty
	
.print:	
	lodsb
	stosb
	loop .print
	
.empty:	
	xor al, al	
	stosb
	
	
	
	ret

beolvas:
	mov 	edx,edi
.loop:
	call 	mio_readchar
	cmp 	al,13
	je 		.end

	;backspace
	cmp 	al,8
	jne 	.ugras
	
	cmp 	edi,edx
	je 		.loop 
	call 	mio_writechar
	mov 	al,' '
	call 	mio_writechar
	mov 	al,8
	call 	mio_writechar
		
	dec 	edi
	jmp 	.loop
	;idaig
.ugras:
	call 	mio_writechar
	stosb
	jmp 	.loop
.end:
	xor 	al,al			;0-as ASCII kodban mutassa a string veget
	stosb
	call 	mio_writeln
	ret
	

	ret
	
B_szam:

	push esi

	mov esi, edi
.search_zero:
	lodsb
	cmp al, 0 
	jne .search_zero
	sub esi, 1	; lodsb increments the ESI past 0
	
	mov edi, esi
	pop esi
	
	xor ebx, ebx
.loop:
	lodsb 
	cmp 	 al,0
	je 		.decikiir
	
	cmp 	al,'0'
	jl		.nem_szam
	
	cmp 	al,'9'
	jg 		.nem_szam
	
	sub 	al,'0'
	add 	bl,al
	
	jmp 	.loop
	
.nem_szam:
	jmp 	.loop
	
	
.decikiir:
	mov [osszeg],bl
	mov ecx,[osszeg]

	push	ecx
	cmp		ecx, 0				;nezzuk ha negativ volt			;jump if greater
	
	xor		eax, eax
	mov		eax, ecx
	mov		ebx, 10
	push	dword -1

.ciklus1:
		cdq						;convert to double word
		idiv	ebx
		push	edx				
		test	eax, eax
		cmp		eax, 0
		jne		.ciklus1
		
.ciklus2:
		pop		eax				;verembol kiszedjuk az elemeket
		cmp		eax, -1			;ha verem vegen van,akkor vegere ugrik
		je		.vege
		add		eax, '0'
		call	mio_writechar	
		stosb
		jmp		.ciklus2
		
.vege:
	pop		ecx				;ecx-ben az eredmeny
	call 	mio_writeln
	ret
	

main:
	mov 	edi, A		;beolvassuk az A-ba
	call 	beolvas
	
	mov 	esi, A		;kiirom A leghosszab reszstringjet
	call 	A_kar
	
	mov 	eax, szamok
	call 	mio_writestr

	mov 	esi, A
	mov 	edi, szamok
	call 	B_szam
	
	mov 	eax, szamok
	call 	mio_writestr
	
	ret
    
	
section .bss
	A   resb 256
	B 	resb 256
	digits   resb 256
	szamok 	resb 256
	
section .data
	max_hossz dd	0
	max_start dd 	0
	osszeg 	  dd 	0
	current_length	dd 0
	current_start 	dd 0