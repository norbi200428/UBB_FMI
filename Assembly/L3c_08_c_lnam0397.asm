; Forditasi parancs:
; nasm -f win32 L3c_08_c_lnam0397.asm
; nlink L3c_08_c_lnam0397.obj -lmio -o L3c_08_c_lnam0397.exe
; L3c_08_c_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L3c_8_c <- feladat
;Feladat kijelentese: c specifikus string muveletek  

%include 'mio.inc'
global main

section .text
main:
	
	mov eax, read_msg
	call mio_writestr
	
	mov edi, str_a
	call read_c
	
	call mio_writeln
	
	call mio_writestr
	
	mov edi, str_b
	call read_c
	
	call mio_writeln
	
	mov eax, rule
	call mio_writestr
	call mio_writeln
	
	mov esi, prompt_A
	call write_c
	
	mov esi, str_a
	call write_c
	
	call mio_writeln
	
	mov esi, prompt_B
	call write_c
	
	mov esi, str_b
	call write_c
	
	call mio_writeln
	
	call sort
	call replace
	call string_concat
	
	mov esi, prompt_C
	call write_c
	
	mov esi, str_c
	call write_c
	
	ret

string_concat:
	mov esi, str_a
	
	mov edi, str_c
	
	.copy_a:
		lodsb
		cmp al, 0x00
		je .b
		
		cmp al, 'A'
		jb .not_letter
		cmp al, 'Z'
		jbe .letter
		
		cmp al, 'a'
		jb .not_letter
		cmp al, 'z'
		jbe .letter
		
		.not_letter:
			jmp .copy_a
		.letter:
			stosb
			jmp .copy_a
		
		
	.b:
		mov esi, str_b
	
		.copy_b:
			lodsb
			cmp al, 0x00
			je .end
			stosb
			jmp .copy_b
	.end:
		ret

sort:
	mov esi, str_a
	.outer_loop:
		cmp byte [esi], 0x00
		je .end
		
		mov edi, str_a
	.inner_loop:
		cmp byte [edi + 1], 0x00
		je .inner_done
		
		mov al, [edi]
		mov bl, [edi + 1]
		
		cmp al, bl
		ja .swap
		
		inc edi
		jmp .inner_loop
		.swap:
			mov [edi], bl
			mov [edi + 1], al
			inc edi
			jmp .inner_loop
		
		.inner_done:
			inc esi
			jmp .outer_loop
	.end:
		ret

replace:
	mov esi, str_b
	
	.loop:
		cmp byte [esi], 0x00
		je .end
		
		cmp byte [esi], '_'
		je .vowel_check
		
		inc esi
		jmp .loop
		
	.vowel_check:
		push esi
		
		.vowel_loop:
			cmp byte [esi], 0x00
			je .vowel_loop_done
			
			cmp byte [esi], 'a'
			je .swap
			cmp byte [esi], 'e'
			je .swap
			cmp byte [esi], 'i'
			je .swap
			cmp byte [esi], 'o'
			je .swap
			cmp byte [esi], 'u'
			je .swap
			cmp byte [esi], 'A'
			je .swap
			cmp byte [esi], 'E'
			je .swap
			cmp byte [esi], 'I'
			je .swap
			cmp byte [esi], 'O'
			je .swap
			cmp byte [esi], 'U'
			je .swap
			
			inc esi
			jmp .vowel_loop
			
		.swap:
			pop edi
			mov al, [esi]
			mov [edi], al
			mov esi, edi
			inc esi
			jmp .loop
			
			
		.vowel_loop_done:
			pop esi
			inc esi
			jmp .loop
	.end:
		ret
read_c:
	.nextchar:
		call mio_readchar
		call mio_writechar
		
		cmp al, 13
		je .null
		
		stosb
		jmp .nextchar
		
	.null:
		mov al, 0x00
		stosb
		ret

write_c:
	.nextchar:
		lodsb
		
		cmp al, 0x00
		je .null
		
		call mio_writechar
		jmp .nextchar
	.null:
		ret

section .data
	read_msg db 'Adj meg egy karakterlancot (max 255 karakter): ' , 0
	rule db '[A-ból az összes betű abc sorrendben (ASCII kód szerint), amelyek többször jelennek meg, többször is kerülnek be az eredménybe (pl. "aeca" => "aace", "aAgH" => "AHag")] + [B, melyben a "_" jelt az utána legközelebb található magángangzóra cseréltük, ha nincs utána magánhangzó, akkor marad a "_"]', 0
	prompt_A db 'A = ', 0
	prompt_B db 'B = ', 0
	prompt_C db 'C = ', 0
section .bss
	str_a resb 256
	str_b resb 256
	str_c resb 512
	