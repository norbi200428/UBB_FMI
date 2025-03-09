; Forditasi parancs:
; nasm -f win32 L3a_lnam0397.asm
; nlink L3a_lnam0397.obj -lmio -o L3a_lnam0397.exe
; L3a_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L3a <- feladat
;Feladat leirasa: binaris szam irasa

%include 'mio.inc'
global main 

section .text
main:
	
	call readHex
	call mio_writeln
	mov ebx, eax
	call readHex
	call mio_writeln
	mov ecx, eax
	mov eax, ebx
	call writeBin
	call mio_writeln
	mov eax,ecx
	call writeBin
	call mio_writeln
	add ebx, ecx
	mov eax, ebx
	call writeBin
	
	ret

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
        
        cmp eax, 13         ; ENTER check
        je .hexEnd          ; ha ENTER -> veget ert a beolvasas
        
        call mio_writechar  
        
        cmp eax, '0'        ; Ellenorizzuk, hogy a karakter 0-9 kozott van
        jl .hexError        ; ha nem, akkor hibat dob vissza
        cmp eax, '9'
        jg .checkUpper      ; Nagybetuk kezelese

        sub eax, '0'        ; karaktert szamma alakitjuk
        shl ebx, 4          
        add ebx, eax        ; A beolvasott szam hozzaadasa
        jmp .nextHexChar    
    
    .checkUpper:
	
        cmp eax, 'A'        ; Ellenorizzuk, hogy a karakter A-F kozott van
        jl .hexError        
        cmp eax, 'F'
        jg .checkLower      ; kis betu kezelese

        sub eax, '0'       
        sub eax, 7          
        shl ebx, 4          
        add ebx, eax        
        jmp .nextHexChar    

    .checkLower:
	
        cmp eax, 'a'        ; kisbetu ellenorzes a-f
        jl .hexError        
        cmp eax, 'f'
        jg .hexError
        
        sub eax, 87         
        shl ebx, 4          
        add ebx, eax        
        jmp .nextHexChar    
    
    .hexEnd:
	
		mov eax, ebx		;eax-be kapjuk az eredmenyt
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
    
		call readHex         ; ha rossz karaktert adunk meg, akkor ujrakeri a szamot 
		ret
		
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
		
		dec edx				;4-es csoportokba irjuk az eredmenyt
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
section .data:
	error_msg db 'Hiba: A megadott bemenet nem megfelelo!', 10 , 0