; Forditasi parancs:
; nasm -f win32 L2_lnam0397.asm
; nlink L2_lnam0397.obj -lmio -o L2_lnam0397.exe
; L2_lnam0397.exe

;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621
;L2 <- feladat
;Feladat leirasa: Írjunk meg egy-egy ASM alprogramot (függvényt, eljárást) 32 bites, 
;előjeles egész (decimális), illetve 32 bites, pozitív hexa számok beolvasására és kiírására.

%include 'mio.inc'  

global main           

section .text
main:

    ; Egy egesz szam beolvasasa 
	mov eax, be_int
	call mio_writestr
	
    call readInt
    mov ebx, eax
    call mio_writeln  
    
    ;Kiiras decimális alakba
	mov eax, ki_int
	call mio_writestr
	mov eax, ebx
	
    call writeInt
    call mio_writeln

    ;Kiiras hex alakba
    mov eax, ki_hex
	call mio_writestr
	mov eax, ebx
	
	call writeHex
    call mio_writeln

    ;Hex szam beolvasasa
    mov eax, be_hex
	call mio_writestr
	
	call readHex
    mov ecx, eax
	call mio_writeln
    
    ;decimális + hexa Kiiras
    mov eax, ki_int
	call mio_writestr
	mov eax, ecx
	call writeInt
    call mio_writeln
	
	mov eax, ki_hex
	call mio_writestr
	mov eax, ecx
    call writeHex

    ; ket szam osszeadasa es kiirasa dec + hexa alakba
    add ebx, ecx
    call mio_writeln
	mov eax, ki_int
	call mio_writestr
	mov eax, ebx
    call writeInt
    call mio_writeln
	mov eax, ki_hex
	call mio_writestr
	mov eax, ebx
    call writeHex
    
    ret 
    
;  readInt: Beolvas egy egesz szamot az eax-be

readInt:
    
    push ebx
    push ecx
    push edx

    xor eax, eax   
    xor ebx, ebx   
    xor ecx, ecx   
    xor edx, edx   

    .nextChar:
	
        call mio_readchar  ; Karakter beolvasasa
        
        cmp eax, 13         ; enter ellenorzes
        je .end            
        
        call mio_writechar  ; A beolvasott karakter kiirasa a kepernyore
        
        cmp eax, 45         ; "-" jel ellenorzes
        je .isNeg           ; ha negativ, akkor ugorjon tovabb 

        sub eax, '0'        ; karakter szamma alakitas
        cmp eax, 0          ; szamjegy ellenorzes
        jl .intError        ; hibat dob vissza, ha nem
        cmp eax, 9
        jg .intError        
        
        imul ebx, 10        
        add ebx, eax        ; a beolvasott szamot hozzaadjuk az eddigi szamhoz

        jmp .nextChar       ; kov karakter beolvasasa
    
    .isNeg:
	
        mov ecx, 1          ; elojel beallitas
        jmp .nextChar      
    
    .end:
	
        cmp ecx, 1          ; negativ szam check
        jne .isPositive     
        
        neg ebx             ; atalkitjuk a szamot
    
    .isPositive:
	
        mov eax, ebx        ; eredmeny -> eax

		pop edx
		pop ecx
		pop ebx
    
		ret
    
	.intError:
	
		call mio_writeln
		mov eax, error_msg
		call mio_writestr
		
		pop edx
		pop ecx
		pop ebx
		
		call readInt         ; uj szamot olvas be
		ret
    
; writeInt: Kiir egy egesz szamot
writeInt:

    push eax
    push ebx
    push ecx
    push edx
    
    xor ebx, ebx   
    xor ecx, ecx   
    xor edx, edx 

    cmp eax, 0     ;negativ szam check
    jge .isPos     
    
    neg eax        ; atalakitjuk a szamot 
    mov ebx, eax
    mov eax, 45    ; "-" jel kiirasa
    call mio_writechar
    mov eax, ebx

	.isPos:
	
		mov ebx, 10    

		cdq            ; maradekot kitoroljuk
		idiv ebx       ; 
		add edx, 48    ; az osztas eredmenyet karakterre alakitjuk
		push edx
		inc ecx        ; kiirando szam hosszanak a novelese
		cmp eax, 0     ; ha meg van szam akkor folyt. kov.
		jne .isPos

	.writedec:
	
		dec ecx
		pop eax
		call mio_writechar
		cmp ecx, 0
		jg .writedec
		
		pop edx
		pop ecx
		pop ebx
		pop eax
		
		ret

; readHex: Beolvas egy hexadecimális szamot
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
        
        call mio_writechar  ; A beolvasott karakter kiirasa
        
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
	
        cmp eax, 'a'        ; kisbetu ellenorzes
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

; writeHex : Kiir egy hexadecimális szamot
writeHex:

	push eax
	push ebx
	push ecx
	push edx
	push eax
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov eax, 48         ; "0" kiirasa
	call mio_writechar
	mov eax, 120		; "x" kiirasa
	call mio_writechar
	
	pop eax
	mov ebx, 16
	
	.nextchar:
	
		xor edx, edx
		div ebx
	
		cmp edx, 9
		jg .isChar          ; Karakter Kiiras
	
		add edx, 48         ; szam karakterre alakitasa
		push edx
		inc ecx				; kiirando szam meretenek a novelese
		jmp .endIs
	
	.isChar:
	
		add edx, 55         ; betu karakterre alakitasa
		push edx
		inc ecx             ; kiirando szam meretenek a novelese
	
	.endIs:
		cmp eax, 0			; ellenorzi, hogy van-e meg mit kiirni
		jne .nextchar
	
	.fullNr:
	
		cmp ecx, 8			; szamot kiegeszitjuk annyi 0-val, amennyi szukseges
		je .writehex
		push 48             ; 0-t a stackbe taroljuk
		inc ecx
	
		jmp .fullNr
	
	.writehex:
	
		dec ecx             ; csokkentjuk a meretet
		pop eax				
		call mio_writechar	; kiirjuk a stakbe eltarolt ertekeket
		cmp ecx, 0
		jg .writehex

		pop edx
		pop ecx
		pop ebx
		pop eax
	
		ret
	
section .data:
	error_msg db 'Hiba: A megadott bemenet nem megfelelo!', 10 , 0 
	ki_int db 'A szam decimalis alakba:', 10, 0
	ki_hex db 'A szam hexa alakba:', 10, 0
	be_int db 'Adj meg egy szamot decimalis alakba:', 10, 0
	be_hex db 'Adj meg egy szamot hex alakba:', 10, 0