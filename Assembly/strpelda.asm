; Forditasi parancs:
; nasm -f win32 iostr.asm
; nasm -f win32 ionum.asm
; nasm -f win32 strings.asm
; nasm -f win32 strpelda.asm
; nlink iostr.obj ionum.obj strings.obj strpelda.obj -lmio -o strpelda.exe
; strpelda.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621

; Feladat: A stringek olvasását egyszerre lehet bemutatni a stringeken végzett műveletekkel.  Mindkét stringnek kiírjuk a hosszát, 
; kompaktált formáját, majd a kompaktált formát kis betűkre alakítva és nagy betűkre alakítva. Végül hozzáfűzzük az első string nagybetűs
;  verziójához a második string kisbetűs verzióját és kiírjuk a hosszával együtt.

%include 'iostr.inc'
%include 'strings.inc'
%include 'ionum.inc'

global main

section .text
main:
	
	mov esi, promp_str 
	call WriteStr
	
	mov edi, str_a ; beolvassuk az elso szoveget
	call ReadLnStr
	
	mov esi, edi
	call StrLen	   ; kiirjuk az elso szoveg hosszat
	
	mov esi, prompt_len
	call WriteStr
	call WriteInt
	call NewLine
	
	mov esi, str_a	
	
	call StrCompact ; tomoritett formara alakitas
	
	mov esi, prompt_compact
	call WriteStr

	mov esi, edi
	call WriteLnStr ; tomoritett forma kiiratasa
	
	call StrLower
	
	mov edi, esi
	
	mov esi, prompt_lower
	call WriteStr
	
	mov esi, edi  ; kisbetus alak kiiratasa
	call WriteLnStr
	
	mov esi, promp_str  
	call WriteStr
	
	mov edi, str_b	; beolvassuk a masodik szoveget
	call ReadLnStr	
	
	mov esi, edi
	call StrLen		; kiirjuk a masodik szoveg hosszat
	
	mov esi, prompt_len
	call WriteStr
	call WriteInt
	call NewLine
	
	mov esi, str_b
	
	call StrCompact
	
	mov esi, prompt_compact
	call WriteStr

	mov esi, edi
	call WriteLnStr 	; kiirjuk a masodik szoveg tomoritett alakjat
	
	call StrUpper
	
	mov edi, esi
	
	mov esi, prompt_upper
	call WriteStr
	
	mov esi, edi		; kiirjuk a masodik szoveg nagybetus alakjat
	call WriteLnStr
	
	mov esi, str_a
	call StrUpper
	
	mov edi, str_c
	call StrCat
	
	mov esi, str_b
	call StrLower
	
	call StrCat
	
	mov esi, prompt_cat
	call WriteStr
	
	mov esi, str_c
	call WriteLnStr
	
	mov esi ,str_c
	call StrLen
	
	mov esi, prompt_len
	call WriteStr
	call WriteInt
	call NewLine
	
	ret

section .data
	promp_str db 'Adj meg egy szoveget (max. 256 karakter): ', 0
	prompt_compact db 'A szoveg tomoritett formaja: ', 0
	prompt_lower db 'A tomoritett szoveg kisbetus alakja: ', 0
	prompt_upper db 'A tomoritett szoveg nagybetus alakja: ', 0
	prompt_cat db 'A ket szoveg osszefuzve: ', 0
	prompt_len db 'A szoveg hossza: ', 0
section .bss
	str_a resb 256
	str_b resb 256
	str_c resb 512