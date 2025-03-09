; Compile:
; nasm -f win32 L1c_08_lnam0397.asm
; nlink L1c_08_lnam0397.obj -lio -o L1c_08_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L1c_08 <- feladat
; C. feladat – feltételes kifejezés
;Írassuk ki a kiértékelendő kifejezést, olvassuk be az a, b, c, d értékeket az io_readint függvény segítségével, majd írassuk ki a beolvasott értékeket és az eredményt egymás alá (előjeles egész számként).
;Megjegyzés: az  a, b, c értékek előjeles egészek, míg a d érték szigorúan pozitív (tekinthetünk rá előjeles számként is, de a tesztprogram csak pozitív értékeket fog generálni).
;8. ha d mod 4 = 0 : (b - a) * 2
;ha d mod 4 = 1 : 17 - c
;ha d mod 4 = 2 : (9 - b) div a
;ha d mod 4 = 3 : c * (c - a)

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
	
	;Kifejezes kiertekelese
	
	mov eax, [d]
	mov ebx, 4
	xor edx,edx
	idiv ebx 
	
	call io_writeln
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
	
	cmp edx, 0
	je .case_0
	cmp edx, 1
	je .case_1
	cmp edx, 2
	je .case_2
	cmp edx, 3
	je .case_3
	
.case_0: ;(b - a) * 2
	mov eax, [b]
	mov ebx, [a]
	sub eax, ebx
	imul eax, 2
	
	mov ebx, eax
	mov eax, out_0
	call io_writestr
	mov eax, ebx
	call io_writeint
	call io_writeln
	
	jmp .end
	
.case_1: ; 17 - c
	mov eax, 17
	mov ebx, [c]
	sub eax, ebx
	
	mov ebx, eax
	mov eax, out_1
	call io_writestr
	mov eax, ebx
	call io_writeint
	call io_writeln
	
	jmp .end

.case_2: ; (9 - b) div a

	mov eax, 9
	mov ebx, [b]
	sub eax, ebx
	mov ecx, [a]
	cdq
	idiv ecx
	
	mov ebx, eax
	mov eax, out_2
	call io_writestr
	mov eax, ebx
	call io_writeint
	call io_writeln
	
	jmp .end

.case_3: ; c * (c - a) 

	mov eax, [c]
	mov ebx, [c]
	mov ecx, [a]
	sub eax, ecx
	imul eax, ebx
	
	mov ebx, eax
	mov eax, out_3
	call io_writestr
	mov eax, ebx
	call io_writeint
	call io_writeln
	
	jmp .end
	
.end:
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
	out_0 db '(b - a) * 2 = ', 0
	out_1 db '17 - c = ', 0
	out_2 db '(9 - b) div a = ', 0
	out_3 db 'c * (c - a) = ', 0