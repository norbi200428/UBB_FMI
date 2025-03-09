; Compile:
; nasm -f win32 L5_08_lnam0397.asm
; nlink L5_08_lnam0397.obj -lmio -o L5_08_lnam0397.exe
; L5_08_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L5_8 <- feladat
;Feladat leirasa: Készítsünk el egy-egy olyan eljárást, amely 32 bites, egyszeres pontosságú lebegőpontos értéket olvas be és ír ki, 
;hagyományos (pl. +1234.5678, -0.0035) és exponenciális formában (pl 1.2345678e+3, -3.5e-3) egyaránt. Az exponenciális formában a pozitív 
;előjelek opcionálisok (tehát ez is helyes: 1.37e2), az e betű pedig lehet kicsi és nagy is.
;Kiertekelendo kifejezes: E(a,b,c,d) = (a + 1) * (b - 2) * (c - 3) - max(c, d)

%include 'mio.inc'

global main 

section .text
main:
	
	mov eax, prompt_read
	call mio_writestr
	call mio_writeln
	
	mov eax, prompt_a
	call mio_writestr
	call ReadFlt
	movss [a], xmm0
	
	mov eax, prompt_b
	call mio_writestr
	call ReadExp
	movss [b], xmm0
	
	mov eax, prompt_c
	call mio_writestr
	call ReadFlt
	movss [c], xmm0
	
	mov eax, prompt_d
	call mio_writestr
	call ReadExp
	movss [d], xmm0
	
	mov eax, prompt_expression
	call mio_writestr
	call mio_writeln
	
	; xmm0-ban fogom az eredmenyt felepiteni
	movss xmm0, [a]
	addss xmm0, [one]
	
	movss xmm1, [b]
	subss xmm1, [two]
	
	mulss xmm0, xmm1
	
	movss xmm1, [c]
	subss xmm1, [three]
	
	mulss xmm0, xmm1
	
	addss xmm1, [three]
	movss xmm2, [d]
	
	maxss xmm1, xmm2
	
	subss xmm0, xmm1
	
	mov eax, prompt_flt
	call mio_writestr
	call WriteFlt
	
	call mio_writeln
	
	mov eax, prompt_exp
	call mio_writestr
	call WriteExp
	ret

; xmm0-ban kapjuk vissza a beolvasott szamot 
ReadFlt:
	
	push eax
	push ecx
	movd eax, xmm1
	push eax
	movd eax, xmm2
	push eax
	
	xorps xmm0, xmm0
	xorps xmm1, xmm1
	xorps xmm2, xmm2
	
	xor ecx, ecx
	
	.nextChar:
	
		xor eax, eax
		
		call mio_readchar
		call mio_writechar
		
		cmp al, 13		; ENTER-ig olvasunk
		je .end
		
		cmp al, '+'		;	 pozitiv elojel eseten folytatjuk a beolvasast
		je .nextChar
		
		cmp al, '-'		;	negativ elojel eseten az ecx erteket -1-re allitjuk
		je .negative
		
		cmp al, '.'		;	a tizedespont utan atterunk a tizedesresz beolvasasahoz
		je .fractional 
	
		sub al, '0'		;	a karaktert atalakitjuk szamma
		
		cvtsi2ss xmm1, eax		;	az egesz erteket atalakitjuk lebegopontos ertekke
		
		mulss xmm0, [ten]		;	szorozzuk 10-el az eddigi szamot
		
		addss xmm0, xmm1		;	hozzaadjuk a kov. "szamjegyet" a szamhoz	
		
		jmp .nextChar
		
	.fractional:
		
		movss xmm2, [ten]		; xmm2-ben hatvanyozzuk a 10-et
		
	.nextFractional:
		
		xor eax, eax
		
		call mio_readchar
		call mio_writechar
		
		cmp al, 13
		je .end
		
		sub al, '0'		;	szamma alakitjuk a karaktert
		
		cvtsi2ss xmm1, eax
		
		divss xmm1, xmm2
		
		addss xmm0, xmm1
		
		mulss xmm2, [ten]
		
		jmp .nextFractional
		
	.negative:
		
		dec ecx		;	az ecx erteket -1 -re allitjuk, negativ elojel eseten 
		
		jmp .nextChar
	
	.end:
		
		cmp ecx, -1
		jne .isPositive
		
		cvtsi2ss xmm1, ecx		;	a -1 -et atalkitjuk lebegopontos alakra
		
		mulss xmm0, xmm1		;	negativva alakitjuk az eddig felepitett szamunkat
		
	.isPositive:
		
		pop eax		;	visszaallitjuk a regiszterek tartalmat
		movd xmm2, eax
		pop eax
		movd xmm1, eax
		pop ecx		
		pop eax
		
		call mio_writeln
		ret

; xmm0-ban kapjuk meg a beolvasott szamot 
ReadExp:
	
	push eax
	push ecx
	push edx
	movd eax, xmm1 
	push eax
	movd eax, xmm2
	push eax
	
	xor ecx, ecx
	xor edx, edx
	xorps xmm0, xmm0
	xorps xmm1, xmm1
	xorps xmm2, xmm2
	
	; a ReadFlt-hez hasonloan dolgozzuk fel a szamot, csak itt meg leellenorizzuk azt e-t es annak a kitevojet
	.nextChar:
		
		xor eax, eax
		
		call mio_readchar
		call mio_writechar
		
		cmp al, 13
		je .end
		
		cmp al, '+'
		je .nextChar
		
		cmp al, '-'
		je .negative
		
		cmp al, '.'
		je .fractional
		
		sub al, '0'
		
		cvtsi2ss xmm1, eax
		
		mulss xmm0, [ten]
		
		addss xmm0, xmm1
		
		jmp .nextChar
	
	.negative:
		
		dec edx
		
		jmp .nextChar
	
	.fractional:
	
		movss xmm2, [ten]
		
	.nextFractional:
	
		xor eax, eax
		
		call mio_readchar
		call mio_writechar
		
		cmp al, 13
		je .end
		
		cmp al, 'e'
		je .exp
		
		cmp al, 'E'
		je .exp
		
		sub al, '0'

		cvtsi2ss xmm1, eax
		
		divss xmm1, xmm2
		
		addss xmm0, xmm1
		
		mulss xmm2, [ten]
		
		jmp .nextFractional
		
	.exp:
		
		xor eax, eax
		
		call mio_readchar
		call mio_writechar
		
		cmp al, 13
		je .endEx
		
		cmp al, '+'
		je .exp
		
		cmp al, '-'
		je .negExp
		
		sub al, '0'
		
		imul ecx, 10	; ecx-ben epitem fel a kitevot
		add ecx, eax
		
		jmp .exp
		
	.negExp:
		
		call mio_readchar
		call mio_writechar
		
		sub al, '0'
		
		add ecx, eax
		neg ecx
		
		jmp .exp
	
	.endEx:
	
		cmp ecx, 0
		je .end
		
		cmp ecx, 0
		jg .pozExponential
		
		neg ecx
		
	.negExponential:
		
		divss xmm0, [ten]	; ha az ecx-ben negativ szamot taroltunk akkor osztani kell az eddigi szamot
		
		loop .negExponential
		
		jmp .end
		
	.pozExponential:
	
		mulss xmm0, [ten]	;	pozitiv kitevo eseten szorozzuk a szamot 10-el, ameddig a kitevo 0 lesz
		
		loop .pozExponential
		
		jmp .end
		
	.end:
		
		cmp edx, -1			; ha a szam negativ volt, akkor negativnak is kell eltarolni, ezert megszorozzuk -1-el  
		jne .isPositive

		cvtsi2ss xmm1, edx
		
		mulss xmm0, xmm1
		
	.isPositive:
		
		pop eax
		movd xmm2, eax
		pop eax
		movd xmm1, eax
		pop edx
		pop ecx
		pop eax
	
		call mio_writeln
		
		ret
		
; xmm0-ban levo lebegopontos szamot hagyomanyos formaban kiirja 4 tizedes pontossaggal 
WriteFlt:
	
	push eax
	push ecx
	movd eax, xmm0
	push eax
	movd eax, xmm1
	push eax
	
	xor eax, eax
	xor ecx, ecx
	xorps xmm1, xmm1
	
	comiss xmm0, [zero]
	jae .isPositive
	
	mov eax, '-'
	call mio_writechar
	
	mov eax, -1			; kiirjuk a negativ elojelet es pozitivva alakitjuk a szamot es ugy dolgozzuk fel a tovabbiakban
	cvtsi2ss xmm1, eax
	mulss xmm0, xmm1
	
	.isPositive:
		
		cvttss2si eax, xmm0		; kiirjuk a szamot ami a tizedesvesszo elott van
		call WriteInt
		cvtsi2ss xmm1, eax
		
		mov eax, '.'
		call mio_writechar
		
		subss xmm0, xmm1
		
		mov ecx, 6			; kiirunk 6 tizedest a vesszo utan
		
	.loop:
		
		mulss xmm0, [ten]
		
		cvttss2si eax, xmm0
		
		call WriteInt
		
		cvtsi2ss xmm1, eax
		
		subss xmm0, xmm1
		
		loop .loop
	
	pop eax		; visszaallijuk a hasznalt regiszterek
	movd xmm1, eax
	pop eax
	movd xmm0, eax
	pop ecx
	pop eax
	
	ret

; kiirja az xmm0-ban levo szamot exponencialis alakban
; felhasznalva a mar megirt WriteFlt-ot, kiirjunk egy szamot 1 es 10 kozott, majd meghatarozzuk az exponenst es azt is kiirjuk 
; 2 esetet kulonboztetunk meg: amikor a szamot csokkenteni kellett (osztottunk 10el), vagy amikor novelni kellett a szamot(szoroztunk 10el)
WriteExp:

	pusha 
	movd eax, xmm0 
	push eax
	movd eax, xmm1
	push eax
	
	xor ecx, ecx
	
	comiss xmm0, [zero]
	jae .isPositive
	
	mov eax, '-'
	call mio_writechar
	
	mov eax, -1
	cvtsi2ss xmm1, eax
	mulss xmm0, xmm1
	
	.isPositive:
		
		cvttss2si eax, xmm0
		
		cmp eax, 10
		jae .notScientific
		
		cmp eax, 1
		jl .notScientific2
		call WriteFlt
		jmp .end
		
	.notScientific:
		
		divss xmm0, [ten]
		
		inc ecx
		
		cvttss2si eax, xmm0
		
		cmp eax, 10
		jae .notScientific
		
		jmp .end
		
	.notScientific2:
		
		mulss xmm0, [ten]
		
		dec ecx
		
		cvttss2si eax, xmm0
		
		cmp eax, 1
		jl .notScientific2
	
	.end:
		call WriteFlt
		
		mov al, 'e'
		call mio_writechar
		
		mov eax, ecx
		call WriteInt
	
		pop eax
		cvtsi2ss xmm1, eax
		pop eax
		cvtsi2ss xmm0, eax
		popa
	
		ret
	
; elozoleg megirt fuggveny, amely kiirja az eax-ben talalhato egesz szamot
WriteInt:
	pusha 
	
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov ebx, 10
	
	cmp eax, 0
	jge .isPositive
	
	neg eax
	
	push eax
	
	mov eax, 45
	call mio_writechar
	
	pop eax
	
	.isPositive:
		cdq
		
		idiv ebx
		add edx, 48
		
		push edx
		
		inc ecx
		
		cmp eax, 0
		jne .isPositive
		
	.print_int:
		dec ecx
		
		pop eax
		call mio_writechar
		
		cmp ecx, 0
		jne .print_int
		
		popa
		
		ret
		
section .data
	
	ten dd 10.0
	one dd 1.0
	two dd 2.0
	three dd 3.0
	zero dd 0.0
	prompt_expression dd 'A kiertekelendo kifejezes: E(a,b,c,d) = (a + 1) * (b - 2) * (c - 3) - max(c, d)', 0
	prompt_read dd 'Adj meg ket szamot hagyomanyos lebegopontos alakban(a,c) es ket szamot exponencialis lebegopontos alakban(b,d) ', 0
	prompt_flt dd 'Az eredmeny hagyomanyos lebegopontos alakban: ', 0
	prompt_exp dd 'Az eredmeny exponencialis lebegopontos alakban: ', 0
	prompt_a dd 'a = ', 0
	prompt_b dd 'b = ', 0
	prompt_c dd 'c = ', 0
	prompt_d dd 'd = ', 0
	
section .bss
	a resd 1 
	b resd 1
	c resd 1
	d resd 1