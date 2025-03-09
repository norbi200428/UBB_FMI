; Compile:
; nasm -f win32 L1a_08_lnam0397.asm
; nlink L1a_08_lnam0397.obj -lio -o L1a_08_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L1a_08 <- feladat
;A. feladat – aritmetikai kifejezés kiértékelése, „div” az egész osztás hányadosát, „mod” pedig a maradékát jelenti. 
; a, b, c, d, e, f, g előjeles egész számok, az io_readint függvénnyel olvassuk be őket ebben a sorrendben. 
;Az eredményt az io_writeint eljárás segítségével írjuk ki.
;8. ((a - 3) * (b - f) - (c + 1) * d) + (e mod ((b - 1) * (c + 1))) - ((d + g - 11) div f)

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
	
	mov eax, str_e
	call io_writestr
	call io_readint
	mov [e], eax
	
	mov eax, str_f
	call io_writestr
	call io_readint
	mov [f], eax
	
	mov eax, str_g
	call io_writestr
	call io_readint
	mov [g], eax

	mov eax,str_feladat
	call io_writestr
	call io_writeln
	
	;Kifejezes kiertekelese
	
	mov eax, [a] ; eax = a
	sub eax, 3 ; eax = a - 3
	
	mov ebx, [b] ; ebx = b
	mov ecx, [f] ; ecx = f
	sub ebx, ecx ; ebx = b - f
	
	imul eax, ebx ; eax = (a - 3) * (b - f)
	
	mov ebx, [c] ;ebx = c
	add ebx, 1 ; ebx = c + 1
	
	mov edx, [d] ; edx = d
	imul ebx, edx ; ebx = (c + 1) * d
	
	sub eax, ebx ; eax = (a - 3) * (b - f) - (c + 1) * d
	mov [temp], eax
	
	mov ebx, [b] ; ebx = b
	sub ebx, 1 ; ebx = b - 1
	
	mov ecx, [c] ; ecx = c 
	add ecx, 1 ; ecx = c + 1
	
	imul ebx, ecx ; ebx = (b - 1) * (c + 1)
	
	mov eax, [e] ; ecx = e 
	cdq
	idiv ebx ; eax = e / ((b - 1) * (c + 1))   edx = e mod ((b - 1) * (c + 1))
	
	mov eax,edx
	call io_writeint
	
	mov eax, [temp]
	add eax, edx ; eax = (((a - 3) * (b - f) - (c + 1) * d) + (e mod ((b - 1) * (c + 1))))
	mov [temp], eax
	
	mov eax, [d] ; eax = d
	mov ebx, [g] ; ebx = g
	
	add eax, ebx ; eax = d + g 
	sub eax, 11 ; eax = d + g - 11
	
	mov ebx, [f] ; ebx = f
	cdq 
	idiv ebx ; eax = (d + g - 11) / f   edx = (d + g - 11) mod f
	
	mov ebx, eax
	mov eax, [temp]
	sub eax, ebx ; eax = eredmeny
	
	;Kiiras
	
	mov ebx, eax
	
	mov eax, str_a
	call io_writestr
	mov eax, [a]
	call io_writeint
	call io_writeln
	
	mov eax, str_b
	call io_writestr
	mov eax, [b]
	call io_writeint
	call io_writeln
	
	mov eax, str_c
	call io_writestr
	mov eax, [c]
	call io_writeint
	call io_writeln
	
	mov eax, str_d
	call io_writestr
	mov eax, [d]
	call io_writeint
	call io_writeln
	
	mov eax, str_e
	call io_writestr
	mov eax, [e]
	call io_writeint
	call io_writeln
	
	mov eax, str_f
	call io_writestr
	mov eax, [f]
	call io_writeint
	call io_writeln
	
	mov eax, str_g
	call io_writestr
	mov eax, [g]
	call io_writeint
	call io_writeln
	
	mov eax, str_eredmeny
	call io_writestr
	mov eax, ebx
	call io_writeint
	
	ret
section .data
	str_a db 'a = ', 0
	str_b db 'b = ', 0
	str_c db 'c = ', 0
	str_d db 'd = ', 0
	str_e db 'e = ', 0
	str_f db 'f = ', 0
	str_g db 'g = ', 0
	str_feladat db 'E(a,b,c,d,e,f,g) = ((a - 3) * (b - f) - (c + 1) * d) + (e mod ((b - 1) * (c + 1))) - ((d + g - 11) div f)', 0
	a dd 0
	b dd 0
	c dd 0
	d dd 0
	e dd 0
	f dd 0
	g dd 0
	temp dd 0
	str_eredmeny db 'E(a,b,c,d,e,f,g) = ((a - 3) * (b - f) - (c + 1) * d) + (e mod ((b - 1) * (c + 1))) - ((d + g - 11) div f)=', 0

