;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621

; Feladat: Készítsünk el egy olyan saját IONUM.ASM / INC modult, amely a következő eljárásokat tartalmazza, 
; a megadott pontos paraméterezéssel (az első zárójelben a bemeneti, a másodikban a kimeneti paramétereket adtuk meg, az eljárások globálisak!).
; Hexa olvasásnál kis- és nagybetűket is el kell fogadjon. Hexa és bináris olvasásnál nem kötelező az összes számjegyet beírni
; (azaz nem lehet a számjegyek száma az egyetlen leállási feltétel). Az olvasás kell kezelje a túlcsordulást és a backspace-t 
;(hasonlóan a második feladathoz, érdemes egyszer annak az első részét megoldani). Minden függvény kötelezően <Enter>-ig olvas.
; Csak az <Enter> lenyomása után tekintünk egy beírt adatot hibásnak. A függvény a hibát a CF beállításával jelzi a főprogramnak.
; Hiba esetén a főprogram írja ki, hogy Hiba és utána kérje újra az adatot.
; A hexa és bináris eljárásoknál a szám felépítését/számjegyekre bontását bitműveletekkel kell megoldani (tehát szorzás/osztás használata nélkül kell megoldani)

%include 'mio.inc'
%include 'iostr.inc'

global ReadInt
global WriteInt
global ReadHex
global WriteHex
global ReadBin
global WriteBin

section .text

; ReadInt():(EAX) – 32 bites előjeles egész beolvasása
ReadInt:
	push ebx
	push ecx
	push edx
	push ebp
	push edi
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov ebp, esp
	sub esp, 256
	
	mov edi, esp
	mov ecx, 256
	
	call ReadStr
	
	mov esi, edi
	
	.nextInt:
		lodsb
		
		cmp al, 0x00
		je .endStr
		
		cmp al, 45		; negativ elojel
		je .isNegative
		
		sub al, 48
		
		cmp al, 0
		jb .error_int
		
		cmp al, 9
		ja .error_int
		
		imul ebx, 10
		add ebx, eax
		jo .error_int
		
		jmp .nextInt
		
	.isNegative:
		mov edx, 1
		jmp .nextInt
	
	.endStr:
		cmp edx, 1
		jne .endInt
		
		neg ebx
	
	.endInt:
		mov eax, ebx
		
		mov esp, ebp
		
		clc
		
		pop edi
		pop ebp
		pop edx
		pop ecx
		pop ebx
		
		ret
	
	.error_int:
		mov esp, ebp
		
		stc
		
		pop edi
		pop ebp
		pop edx
		pop ecx
		pop ebx
		
		ret
	
; WriteInt(EAX):() – 32 bites előjeles egész kiírása
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

; ReadHex():(EAX) – 32 bites előjel nélküli hexa beolvasása
ReadHex:
	push ebx
	push ecx
	push edx
	push ebp
	push edi
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov ebp, esp
	sub esp, 256
	
	mov edi, esp
	mov ecx, 256
	
	call ReadStr
	
	mov esi, edi
	
	.nextHex:
		lodsb
		
		cmp al, 0x00
		je .endStr
				
		cmp al, '0'
		jb .error_hex
		
		cmp al, '9'
		ja .check_Upper
		
		sub eax, '0'
		shl ebx, 4
		add ebx, eax
		
		jmp .nextHex
		
	.check_Upper:
		cmp eax, 'A'
		jb .error_hex
		
		cmp eax, 'F'
		ja .check_lower
		
		sub eax, '0'
		sub eax, 7
		
		shl ebx, 4
		add ebx, eax
		
		jmp .nextHex
	
	.check_lower:
		cmp eax, 'a'
		jb .error_hex
		
		cmp eax, 'f'
		ja .error_hex
		
		sub eax, 87
		shl ebx, 4
		add ebx, eax
		
		jmp .nextHex
	
	.endStr:
		mov eax, ebx
		
		mov esp, ebp
		
		clc
		
		pop edi
		pop ebp
		pop edx
		pop ecx
		pop ebx
		
		ret
	
	.error_hex:
		mov esp, ebp
		
		stc
		
		pop edi
		pop ebp
		pop edx
		pop ecx
		pop ebx
		
		ret

; WriteHex(EAX):() - 32 bites előjel nélküli hexa kiirasa	
WriteHex:
	pusha 
	push eax

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov eax, '0'
	call mio_writechar
	mov eax, 'x'
	call mio_writechar

	pop eax

.nextHex:
	xor edx, edx

	mov edx, eax          
	and edx, 0xF          
	shr eax, 4            
	
	cmp edx, 9
	jg .isChar

	add edx, 48
	push edx
	inc ecx
	jmp .endIs

.isChar:
	add edx, 55
	push edx
	inc ecx

.endIs:
	cmp eax, 0
	jne .nextHex

.fullNr:
	cmp ecx, 8
	je .writeOut
	push '0'
	inc ecx

	jmp .fullNr

.writeOut:
	dec ecx
	pop eax
	call mio_writechar

	cmp ecx, 0
	ja .writeOut

	popa
	
	ret

; ReadBin():(EAX) – 32 bites előjel nélküli bináris egész beolvasása
ReadBin:
	push ebx
	push ecx
	push edx
	push ebp
	push edi
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov ebp, esp
	sub esp, 256
	
	mov edi, esp
	mov ecx, 256
	
	call ReadStr
	
	mov esi, edi
	
	.nextBin:
		lodsb
		
		cmp al, 0x00
		je .endStr
				
		cmp al, '0'
		jb .error_bin
		
		cmp al, '1'
		ja .error_bin
		
		sub eax, '0'
		shl ebx, 1
		add ebx, eax
		
		jmp .nextBin
		
	.endStr:
		mov eax, ebx
		
		mov esp, ebp
		
		clc
		
		pop edi
		pop ebp
		pop edx
		pop ecx
		pop ebx
		
		ret
	
	.error_bin:
		mov esp, ebp
		
		stc
		
		pop edi
		pop ebp
		pop edx
		pop ecx
		pop ebx
		
		ret

; WriteBin(EAX):() - 32 bites előjel nélküli bináris kiirasa	    
WriteBin:
	pusha
	
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
		
		popa
		
		ret