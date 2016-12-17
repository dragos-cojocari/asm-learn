;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L3c_8_c
;Keszítsünk assembly programot (NASM), amely beo

%include 'mio.inc'

global main

section .text

beolvas_karlanc:
	xor 	ecx,ecx

.ciklus:
	call    mio_readchar
	cmp		al,13
	je		.vege
	call	mio_writechar
	inc		ecx
	
	cmp		al,8
	jne		.ugras
	mov		al,' '
	call	mio_writechar
	mov		al,8
	call	mio_writechar
	cmp		edi,edx
	je		.ciklus
	dec		edi
	
.ugras:
	stosb
	jmp		.ciklus
	
.vege:
	xor		al,al
	stosb

	ret

kiirat_karlanc:
	
.ciklus:
	lodsb
	cmp		al,0
	je		.vege
	call	mio_writechar
	jmp		.ciklus

.vege:
	ret
	
muvelet:
	push esi		;save esi
	
.start_pass:
	xor ecx, ecx
	pop esi
	push esi		;save esi
	
	mov	al,[esi]	; check empty string scenario
	cmp al, 0		
	je .sort_done
	
.compare_chars:
	
	mov	al,[esi]	; read current char
	
	mov edi, esi	
	add edi, 1		;move to next char
	mov	bl,[edi]
		
	cmp bl, 0		; reached end of string ( second char is 0)?
	je .pass_done
	
	cmp al, bl
	jle .nochange 	;no need to change

	stosb			;store AL (the first char) in DI ( the address of the second char)
	mov edi, esi	;change DI position back to first char
	mov al, bl		;move second char in AL
	stosb			;store the second char in the position of the first one
	
	mov ecx, 1		;mark that a change was done
	
.nochange:
	add esi, 1		;increment pointer in string
	jmp .compare_chars	;compare the next char

.pass_done:	
	cmp ecx, 1		;were any changes made in this pass?
	je .start_pass
		
.sort_done:
	pop esi
	
	ret
	
merge:

	; edi <-- A
	; esi <-- B

; find the end of array A	
.loop:
	mov		al,[edi]

	add		edi,1
	cmp		al, 0
	jne		.loop
	
	sub edi, 1	; go back to the position of 0 from A
		
; copy B into A
.loop1:
	mov		al,[esi]
		
	cmp		al,'_'
	je		.underscore
	
	movsb

	cmp		al,0
	je		.end_all
	
	jmp		.loop1
	
; the search vowel routine will call this with the char to use in the BL registry
.replace_underscore:
	
	mov al, bl	
	stosb			; put the value of BL in the string
	
	pop esi			; restore ESI to the position in the B array
	add esi, 1		; increment the pointer in the B array

	jmp .loop1		; continue main loop
		
.underscore:
	push esi	;save current position of esi
	add esi, 1	;move to the first character after _
	
; loop for searching the first vowel
.loop2:

	lodsb	; read the char in ESI. This will also inc ESI's position
	
	mov bl, "_"	
	cmp al, 0	
	je .replace_underscore	; if 0 is found the string was finished, return with "_" in BL
	
	; search the vowels string - lentgh is 9
	mov ecx, 9
.search:	

	lea edx, [vowels+ecx-1]	; load the address of the current char in the vowels string
	mov bl, [edx]			; load the value of the current char from the vowels array into  bl
	cmp al, bl				; compare
	
	je .replace_underscore		; the current char in B string is a vowel, return to the main loop with the bowel in BL
	
	loop .search

	jmp .loop2		; this will never be reached as the routine will return when 0 or a vowel is found
	
.end_all:
	ret
	
main:
	mov		eax,szabaly
	call	mio_writestr
	call	mio_writeln
	
	mov		edi,a
	call 	beolvas_karlanc
	mov		[length_a],ecx
	
	call	mio_writeln
	
	mov		edi,b
	call 	beolvas_karlanc
	mov		[length_b],ecx
	
	call	mio_writeln
	
	mov		eax,uzenet1
	call	mio_writestr
	
	mov		esi,a
	call	kiirat_karlanc
	
	call	mio_writeln
	
	mov		eax,uzenet2
	call	mio_writestr
	
	mov		esi,b
	call	kiirat_karlanc
	call	mio_writeln
	
	mov		esi,a
	call	muvelet
	
	mov		edi, a
	mov 	esi, b
	call	merge
	
	mov		esi,a
	mov		eax,esi
	call	kiirat_karlanc
	
	ret

section .bss
	a resb 256
	b resb 256
	
section .data
	szabaly db '[A-bol az osszes betu abc sorrendben (ASCII kod szerint), amelyek tobbszor jelennek meg, tobbszor is kerulnek be az eredmenybe] + [B, melyben a "_" jelt az utana legkozelebb talalhato magangangzora csereltuk, ha nincs utana maganhangzo, akkor marad a "_"]',0
	uzenet1 db 'A = ', 0
	uzenet2 db 'B = ', 0
	vowels 	db	'aeiouAEIOU',0
	length_a db 0
	length_b db 0