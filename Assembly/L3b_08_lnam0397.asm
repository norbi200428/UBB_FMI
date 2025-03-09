; Forditasi parancs:
; nasm -f win32 L3b_08_lnam0397.asm
; nlink L3b_08_lnam0397.obj -lmio -o L3b_08_lnam0397.exe
; L3b_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L3b_8 <- feladat
;Feladat leirasa: epitsuk fel, majd irjuk ki binaris alakba egy szamot, felhasznalva a megadott szabalyt
%include 'mio.inc'
global main 

section .text
main:
	mov eax, in_msg
	call mio_writestr
	call readHex
	mov [A], eax
	call mio_writeln
	
	mov eax, in_msg
	call mio_writestr
	call readHex
	mov [B], eax
	call mio_writeln
	
	mov eax, in_msg
	call mio_writestr
	call readHex
	mov [C], eax
	call mio_writeln
	
	mov eax, D_msg
	call mio_writestr
	mov eax, szabaly_msg
	call mio_writestr
	
	mov eax, A_msg
	call mio_writestr
	mov eax, [A]
	call writeBin
	call mio_writeln
	
	mov eax, B_msg
	call mio_writestr
	mov eax, [B]
	call writeBin
	call mio_writeln
	
	mov eax, C_msg
	call mio_writestr
	mov eax, [C]
	call writeBin
	call mio_writeln
	
	xor ecx, ecx
	
	;B[18:5] AND C[25:12]
	mov eax, [B]
	mov ebx, [C]
	
	shr eax, 5
	shr ebx, 12
	and eax, ebx
	and eax, 0x3FFF ; utolso 14 karakter
	
	or ecx, eax
	
	;A[3:1] XOR 001
	mov eax, [A]
	mov ebx, 0x1
	
	shr eax, 1
	xor eax, ebx
	and eax, 0x7  ;0111 => utolso 3 karakter
	
	shl ecx, 3
	or ecx, eax
	
	;A[25:22] + A[24:21]
	mov eax, [A]
	mov ebx, [A]
	
	shr eax, 22
	shr ebx, 21
	
	add eax, ebx
	and eax, 0xF  ;0111 => utolso 3 karakter
	
	shl ecx, 4
	add ecx, eax
	
	; 11101
	mov eax, 0x1D  ;11101 hexa alakja
	shl ecx, 5
	or ecx, eax
	
	;B[24:19] OR A[25:20]
	mov eax, [B]
	mov ebx, [A]
	
	shr eax, 19
	shr ebx, 20
	
	or eax, ebx
	and eax, 0x3F ;utolso 6 karakter
	
	shl ecx, 6
	add ecx, eax
	
	mov eax, D_msg
	call mio_writestr
	mov eax, ecx
	call writeBin
	call mio_writeln
	
	ret

;beolvas egy szamot hex alakba az eax-be	
readHex:
    
    push ebx
    push ecx
    push edx
    
    xor eax, eax   
    xor ebx, ebx   
    xor ecx, ecx   
    xor edx, edx  

    .nextHexChar:
	
        call mio_readchar  
        
        cmp eax, 13        
        je .hexEnd          
        
        call mio_writechar  
        
        cmp eax, '0'        
        jl .hexError       
        cmp eax, '9'
        jg .checkUpper    

        sub eax, '0'       
        shl ebx, 4          
        add ebx, eax       
        jmp .nextHexChar    
    
    .checkUpper:
	
        cmp eax, 'A'       
        jl .hexError        
        cmp eax, 'F'
        jg .checkLower      

        sub eax, '0'       
        sub eax, 7          
        shl ebx, 4          
        add ebx, eax        
        jmp .nextHexChar    

    .checkLower:
	
        cmp eax, 'a'       
        jl .hexError        
        cmp eax, 'f'
        jg .hexError
        
        sub eax, 87         
        shl ebx, 4          
        add ebx, eax        
        jmp .nextHexChar    
    
    .hexEnd:
	
		mov eax, ebx
		pop edx
		pop ecx
		pop ebx
		ret
    
	.hexError:
	
		call mio_writeln
		mov eax, error_msg  
		call mio_writestr
		pop edx
		pop ecx
		pop ebx
    
		call readHex         
		ret
		
; az eax-ben levo szamot kirja binaris alakban
writeBin:
	push eax
	push ebx
	push ecx
	push edx
	push esi
	
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	
	mov ecx, 32
	mov edx, 4
	
	.loop:
		xor ebx, ebx
		rol eax, 1
		
		mov esi, eax
		
		adc ebx, '0'
		
		mov eax, ebx
		call mio_writechar
		
		dec edx
		jnz .notSpace
		
		mov eax, ' '
		call mio_writechar
		
		mov edx, 4
		
	.notSpace:
		mov eax, esi
		loop .loop
		
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		
		ret
		
section .data
	error_msg db 'Hiba: A megadott bemenet nem megfelelo!', 10 , 0
	in_msg db 'Adj meg egy hexa szamot: ', 0
	szabaly_msg db 'B[18:5] AND C[25:12], A[3:1] XOR 001, A[25:22] + A[24:21], 11101, B[24:19] OR A[25:20]', 10, 0
	A_msg db 'A = ', 0
	B_msg db 'B = ', 0
	C_msg db 'C = ', 0
	D_msg db 'D = ', 0
	
section .bss
	A resd 1
	B resd 1
	C resd 1
	
	