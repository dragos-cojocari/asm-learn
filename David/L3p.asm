;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L3c_8_p
;Készítsünk két assembly programot (NASM), amelyek beolvassák a szükséges karakterláncokat, kiírják a felhasznált szabályt (mint üzenetet) és a beolvasott karakterláncokat külön sorokba, majd előállítják és végül kiírják a művelet eredményét, ami szintén egy karakterlánc.
;Az eredményt nem szabad több részletben kiiírni, az egyetlen karakterlánc kell legyen, amit elő kell állítani kiírás előtt! A karakterláncok olvasásához és írásához írjunk alprogramot (a két feladatban különbözőek lesznek)!
;Az egyik program PASCAL specifikus karakterláncokat (azaz string-eket, ahol a 0. karakter a hosszat jelöli), a másik program pedig C specifikus (azaz 0-al lezárt) karakterláncokat kell alkalmazzon.
;Az [egy szabály] jelöléssel egy karakterlánc részletet jelöltünk.

; test 2

%include 'mio.inc'

global main

section .text

beolvas_karlanc:

	push edi
	inc edi
	xor ecx, ecx

.ciklus:
	call    mio_readchar
	cmp		al,13
	je		.vege

	call	mio_writechar

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
	inc ecx			; char count
	jmp		.ciklus

.vege:
	mov eax, ecx
	pop edi			; load back the starting point EDI ( the address of the array)
	stosb			; store the char count

	ret

kiirat_karlanc:

	xor eax, eax	; must clear EAX as LODSB will only modify AL  and the rest of the register can contain other stuff
	lodsb
	mov		ecx,eax

.print_loop:
	lodsb
	call	mio_writechar
	loop	.print_loop

	ret

main:
	mov		eax,szabaly
	call	mio_writestr
	call	mio_writeln

	mov		edi,a
	call 	beolvas_karlanc

	call	mio_writeln

	mov		edi,b
	call 	beolvas_karlanc

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

	;mov		esi,a
	;call	muvelet

	;mov		edi, a
	;mov 	esi, b
	;call	muvelet2

	;mov		esi,a
	;mov		eax,esi
	;call	kiirat_karlanc

	ret

section .bss
	a resb 256
	b resb 256

section .data
	szabaly db '[A-bol az osszes betu abc sorrendben (ASCII kod szerint), amelyek tobbszor jelennek meg, tobbszor is kerulnek be az eredmenybe] + [B, melyben a "_" jelt az utana legkozelebb talalhato magangangzora csereltuk, ha nincs utana maganhangzo, akkor marad a "_"]',0
	uzenet1 db 'A = ', 0
	uzenet2 db 'B = ', 0
	vowels 	db	'aeiouAEIOU',0
