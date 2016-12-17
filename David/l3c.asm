;nev: Ballan David-Lajos
;azonosito: bdim1597
;csoportszam: 511
;feladat: L3c_8_c
;Készítsünk két assembly programot (NASM), amelyek beolvassák a szükséges karakterláncokat, kiírják a felhasznált szabályt (mint üzenetet) és a beolvasott karakterláncokat külön sorokba, majd előállítják és végül kiírják a művelet eredményét, ami szintén egy karakterlánc. 
;Az eredményt nem szabad több részletben kiiírni, az egyetlen karakterlánc kell legyen, amit elő kell állítani kiírás előtt! A karakterláncok olvasásához és írásához írjunk alprogramot (a két feladatban különbözőek lesznek)!
;Az egyik program PASCAL specifikus karakterláncokat (azaz string-eket, ahol a 0. karakter a hosszat jelöli), a másik program pedig C specifikus (azaz 0-al lezárt) karakterláncokat kell alkalmazzon. 
;Az [egy szabály] jelöléssel egy karakterlánc részletet jelöltünk.

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

muvelet0: ;A karlancban csak kicsi es nagybetuket hagy

.loop:
	lodsb
	
	;call	mio_writechar
	
	cmp		al,0
	je		.vege_muvelet0
	
	cmp 	al,'A'
	jl		.hiba
	
	cmp		al,'Z'			; if smaller than Z go directly to char needed
	jle		.char_needed

	cmp 	al,'a'
	jl		.hiba
	
	cmp		al,'z'
	jg		.hiba

.char_needed:
	stosb
	
.hiba:
	jmp		.loop
	
.vege_muvelet0:
	stosb			;store the ending 0. at this point it is guaranteed we have 0 in AL
	
	ret
	
muvelet:
	push 	esi		;elmentem az esi-t
	
.rendezes:
	xor 	ecx, ecx
	pop 	esi
	push 	esi
	
	mov		al,[esi]	; ellenorzom ha nem-e ures
	cmp 	al, 0
	je 		.rendez_vege
	
.hasonlit:
	
	mov		al,[esi]	; beolvasom a karaktert
	
	mov 	edi, esi	
	add 	edi, 1		;ugrok a kovetkezo karakterre
	mov		bl,[edi]
		
	cmp 	bl, 0		; karlanc vegen vagyok
	je 		.rendez_vege2
	
	cmp 	al, bl
	jle 	.ugras 	;kell csrelnem?

	stosb			;elmentem AL-t (elso karakter) DI-be (masodik karakter cime)
	mov 	edi, esi	;DI cimet visszaallitom az elso karakterre
	mov 	al, bl		;masodik karakter az Al-be
	stosb			;masodik karaktert mentem az elso cimere
	
	mov 	ecx, 1		;elmentem hogy volt csere
	
.ugras:
	add 	esi, 1		;tovabb lepek
	jmp 	.hasonlit

.rendez_vege2:	
	cmp 	ecx, 1		;megnezem ha volt-e csere
	je 		.rendezes
		
.rendez_vege:
	pop 	esi
	
	ret
	
muvelet2:

	; edi <-- A
	; esi <-- B

; megkeresem az A stringem veget	
.loop:
	mov		al,[edi]

	add		edi,1
	cmp		al, 0
	jne		.loop
	
	sub 	edi, 1	; vissza a lepek arra a poziciora ahol az A-nak van a 0ja
		
; masolom B-t az A-ba
.loop1:
	mov		al,[esi]
		
	cmp		al,'_'
	je		.megvan
	
	movsb

	cmp		al,0
	je		.end_all
	
	jmp		.loop1
	

.atiras:
	
	mov 	al, bl	
	stosb	; Bl-t beteszi a string-be
	
	pop 	esi
	add 	esi, 1		; tovabb lepek a B-ben

	jmp 	.loop1		; folytatom a fo ciklust
		
.megvan:
	push 	esi	;elmentem hol talalhato a '_'
	add 	esi, 1	; '_' utani elso karakterre ugrok
	
; ciklus amely megkeresi az elso maganhangzot
.loop2:

	lodsb	; beolvasom ESI-bol Al-be
	
	mov 	bl, "_"	
	cmp 	al, 0	
	je 		.atiras	; ha 0 a string-nek vege, s visszaterek '_'-val Bl-ben
	
	mov 	ecx, 9 ; 9 a maganhangzok string hossza
.keres:	

	lea 	edx, [vowels+ecx-1]	; betolti ezt a karaktert az edx-be
	mov 	bl, [edx]			; az erteket megorzom a Bl-ben
	cmp 	al, bl				; hasonlitom
	
	je 		.atiras		
	
	loop 	.keres

	jmp 	.loop2	
	
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
	mov 	edi, result
	call 	muvelet0
	
	mov 	eax, result
	call	mio_writestr
	
	;mov		esi,edi
	
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
	result resb 256
	
section .data
	szabaly db '[A-bol az osszes betu abc sorrendben (ASCII kod szerint), amelyek tobbszor jelennek meg, tobbszor is kerulnek be az eredmenybe] + [B, melyben a "_" jelt az utana legkozelebb talalhato magangangzora csereltuk, ha nincs utana maganhangzo, akkor marad a "_"]',0
	uzenet1 db 'A = ', 0
	uzenet2 db 'B = ', 0
	vowels 	db	'aeiouAEIOU',0
	length_a db 0
	length_b db 0