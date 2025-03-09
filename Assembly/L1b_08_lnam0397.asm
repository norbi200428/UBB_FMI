; Compile:
; nasm -f win32 L1b_08_lnam0397.asm
; nlink L1b_08_lnam0397.obj -lio -o L1b_08_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L1b_08 <- feladat
;B. feladat – bitenkénti logikai műveletek
;Írassuk ki a kiértékelendő kifejezést, olvassuk be az a, b, c, d értékeket az io_readint függvény segítségével,
; majd írassuk ki a beolvasott értékeket és az eredményt egymás alá bináris formában az io_writebin függvény segítségével.
; 8. (a XOR (b OR d)) AND (NOT (a AND (b XOR c)))


%include 'io.inc'

global main

section .text
main:

	;Beolvasas
	
	mov eax, str_a
	call io_writestr
	call io_readint
	mov [a], eax

	mov eax, str_b
	call io_writestr
	call io_readint
	mov [b], eax
	
	mov eax, str_c
	call io_writestr
	call io_readint
	mov [c], eax
	
	mov eax, str_d
	call io_writestr
	call io_readint
	mov [d], eax
	
	;Kifejezes kiertekelese (a XOR (b OR d)) AND (NOT (a AND (b XOR c)))
	
	mov ebx, [b]
	mov edx, [d]
	or ebx, edx ; ebx = b or d
	
	mov eax, [a]
	xor eax, ebx ; eax = a XOR (b OR d)
	
	mov ebx, [b]
	mov ecx, [c]
	xor ebx, ecx ; ebx = b XOR c
	
	mov ecx, [a]
	and ecx, ebx ; ecx = a AND (b XOR c)
	not ecx ; ecx = NOT(a AND (b XOR c))
	
	and eax, ecx ; eax = (a XOR (b OR d)) AND (NOT (a AND (b XOR c)))
	mov ebx, eax
	
	;Kiiras
	mov eax, str_feladat
	call io_writestr
	call io_writeln
	
	mov eax, str_a
	call io_writestr
	mov eax, [a]
	call io_writebin
	call io_writeln
	
	mov eax, str_b;
	call io_writestr
	mov eax, [b]
	call io_writebin 
	call io_writeln

	mov eax, str_c
	call io_writestr
	mov eax, [c]
	call io_writebin 
	call io_writeln
	
	mov eax, str_d
	call io_writestr
	mov eax, [d]
	call io_writebin 
	call io_writeln
	
	mov eax, str_eredmeny
	call io_writestr
	
	mov eax, ebx
	call io_writebin
	
	ret
	
section .data
	str_a db 'a = ', 0
	str_b db 'b = ', 0
	str_c db 'c = ', 0
	str_d db 'd = ', 0
	a dd 0
	b dd 0
	c dd 0
	d dd 0
	str_feladat db 'E(a,b,c,d) = (a XOR (b OR d)) AND (NOT (a AND (b XOR c)))', 0
	str_eredmeny db 'E(a,b,c,d) = (a XOR (b OR d)) AND (NOT (a AND (b XOR c))) = ', 0