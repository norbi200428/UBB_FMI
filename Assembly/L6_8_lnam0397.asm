; Compile:
; nasm -f win32 L6_8_lnam0397.asm
; nlink L6_8_lnam0397.obj -lio -o L6_8_lnam0397.exe
; L6_8_lnam0397

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L6_8 <- feladat
;Feladat leirasa: Olvassunk be két (A és B) azonos hosszúságú lebegőpontos értékekből álló tömböt (max. 256 elem). 
;Olvassuk be a tömbök hosszát (n integer, 4<=n<=256), majd a tömbök elemeit, minden elemet új sorból (azaz 2n lebegőpontos értéket olvasunk be).
;A tömbök minden elemére páronként végezzük el az alább megadott műveleteket, tároljuk el az eredményeket egy másik tömbben, 
;végül pedig írjuk ki azt. A feladat lényege, hogy ne skaláris utasításokat használjuk, hanem vektorosokat (azaz pl. ADDSS helyett ADDPS-t használjunk 4 db. számpár párhuzamos összeadására).
%include 'io.inc'

global main

section .text

main:
	
	call read_n
	
	call read_a
	
	call read_b
	
	call build_c
	
	call write_c
	
	ret
	
read_n: ; az ecx-ben taroljuk el az n erteket
	push eax
	push ebx
	
	xor ecx, ecx
	xor edx, edx
	
	mov eax, str_n
	call io_writestr
	
	call io_readint
	
	cmp eax, 4
	jb .error
	
	cmp eax, 256
	ja .error
	
	mov ebx, 4
	cdq
	div ebx
	
	cmp edx, 0
	jne .error
	
	mul ebx
	
	mov ecx, eax
	
	pop ebx
	pop eax
	
	ret
	
	.error:
		mov eax, str_error
		call io_writestr
		call io_writeln
		
		pop ebx
		pop eax
		jmp read_n
		
read_a:
	push eax
	push ebx
	push ecx
	
	mov eax, str_a
	call io_writestr
	call io_writeln
	
	xorps xmm0, xmm0
	xor ebx, ebx
	
	.loop:
		
		call io_readflt
		
		movss [tomb_a + ebx * 4], xmm0
		inc ebx
		
		loop .loop
	
	pop ecx
	pop ebx
	pop eax
	
	ret
	
read_b:
	push eax
	push ebx
	push ecx
	
	mov eax, str_b
	call io_writestr
	call io_writeln
	
	xorps xmm0, xmm0
	xor ebx, ebx
	
	.loop:
		
		call io_readflt
		
		movss [tomb_b + ebx * 4], xmm0
		inc ebx
		
		loop .loop
	
	pop ecx
	pop ebx
	pop eax
	
	ret
	
build_c:	;8. E(a,b) = 1.3 * sqrt(a^2 + b^4) + b / (a - 2.5)
	push eax
	push ebx
	push ecx
	
	xorps xmm0, xmm0
	xorps xmm1, xmm1
	xorps xmm2, xmm2
	
	mov ebx, 4
		
	mov eax, ecx
	cdq
	idiv ebx
	
	xor ebx, ebx
	
	mov ecx, eax
	
	.loop:
		
		movaps xmm0, [tomb_a + ebx]		; xmm0-ba masolunk 4 szamot az a tombbol
		mulps xmm0, xmm0				; xmm0 = a ^ 2
			
		movaps xmm1, [tomb_b + ebx]		; xmm1-ba masolunk 4 szamot a b tombbol
		mulps xmm1, xmm1				; xmm1 = b ^ 2
		mulps xmm1, xmm1				; xmm1 = b ^ 4
			
		addps xmm0, xmm1				; xmm0 = a^2 + b^4
			
		sqrtps xmm0, xmm0				; gyokotvonas 
			
		movups xmm1, [egy_harom]		; megszorozzuk 1.3-al mind a 4 szamot 
			
		mulps xmm0, xmm1
			
		movaps xmm1, [tomb_a + ebx]
		movups xmm2, [ketto_ot]			
			
		subps xmm1, xmm2
			
		movaps xmm2, [tomb_b + ebx]
			
		divps xmm2, xmm1
	
		addps xmm0, xmm2
			
		movaps [tomb_c + ebx], xmm0
			
		add ebx, 16
			
		loop .loop	
		
	pop ecx
	pop ebx
	pop eax
		
	ret
	
write_c:
	push eax
	push ecx
	
	mov eax, str_c
	call io_writestr
	call io_writeln
	
	xor ebx, ebx
	
	.loop:
		
		xorps xmm0, xmm0
		
		movss xmm0, [tomb_c + ebx * 4]
		
		call io_writeflt
		call io_writeln
		
		inc ebx
		
		loop .loop
		
		pop ecx
		pop eax
		
		ret
		
section .data
	str_n db 'Add meg a tombok hosszat: ', 0
	str_a db 'Add meg az elso tomb elemeit: ', 0
	str_b db 'Add meg az masodik tomb elemeit: ', 0
	str_c db 'Az eredmeny tomb: ', 0
	str_error db 'A megadott parameter nem felel meg!', 0
	egy_harom dd 1.3, 1.3, 1.3, 1.3
	ketto_ot dd 2.5, 2.5, 2.5, 2.5
section .bss
	align 16
	tomb_a resd 256
	align 16
	tomb_b resd 256
	align 16
	tomb_c resd 256