%include 'mio.inc'

;ab0cd1efgh

global main

section .text

kiir1:
	
	xor cx, cx
	mov esi, szoveg
	mov edi, digits
	
; pass through the szoveg array, identify all digits and write their positions in the digits array
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
	sub eax, szoveg		
	
	stosb				; store result in digits array
	inc cx

.notdigit:
	jmp .loop
	
; store the string end as well in the digit array
.stringend:
	mov eax, esi
	sub eax, szoveg
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

	mov esi, szoveg
	add esi, [max_start]
	mov ecx, [max_hossz]

.print	
	lodsb
	call mio_writechar
	
	loop .print
	
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

main:
;beolvasas
	mov 	eax,troll
	call 	mio_writestr
	
	mov 	edi,szoveg
	call 	beolvas
	
	mov 	esi,szoveg
	call 	kiir1
	
	ret
    
	
section .bss
	szoveg   resb 256
	digits   resb 256
	
section .data
	troll 	db  "troll:",0
	str_szam0 	db 	' 0 ',0
	str_szam 	db ' 1-9  ',0
	str_max 	db 	' max ',0
	
	max_hossz dd	0
	max_start dd 	0
	current_length	dd 0
	current_start 	dd 0