;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621

; Feladat: Készítsünk el egy olyan stringbeolvasó eljárást, amely megfelelőképpen kezeli le a backspace billentyűt 
; (azaz visszalépteti a kurzort és letörli az előző karaktert). Teszteljük ezt az eljárást különböző kritikus esetekre 
; (pl. a string elején a backspace-nek ne legyen hatása, valamint ha már több karaktert vitt be a felhasználó, mint a megengedett hossz és 
; lenyomja a backspace-t akkor nem az elmentett utolsó karaktert kell törölni, hanem az elmentetlenekből az utolsót). <Enter>-ig olvas.
; Ebben a feladatban C stringekkel dolgozunk, itt a string végét a bináris 0 karakter jelenti.

%include 'mio.inc'

global ReadStr
global WriteStr
global NewLine
global ReadLnStr
global WriteLnStr

section .text

; ReadStr(EDI, ECX max. hossz):()   – C-s (bináris 0-ban végződő) stringbeolvasó eljárás, <Enter>-ig olvas
ReadStr:
	push edi
	push eax
	push ecx
	
	mov ecx, 256
	
	.nextChar:
		call mio_readchar
		call mio_writechar
		
		cmp ecx, 1
		je .end
		
		dec ecx
		
		cmp al, 13 ;ha enter-t utunk akkor vege a beolvasasnak 
		je .end
		
		cmp al, 8 ;backspace lekezelese
		je .backspace
		
		stosb ;kimenti az al erteket az edi cimre es noveli az edi-t
		jmp .nextChar
		
	.backspace:
		mov al, 32 ; SPACE
		call mio_writechar
		
		mov al, 8 ; BACKSPACE
		call mio_writechar
		
		dec edi ; visszaleptetjuk a mutatot is 
		jmp .nextChar
	
	.end:
		mov al, 0x00 ; NULL karakter a string vegere
		stosb
		
		pop ecx
		pop eax
		pop edi
		ret

; WriteStr(ESI):()  – stringkiíró eljárás
WriteStr:
	push eax
	push esi
	
	.nextchar:
		lodsb     ; az al-be atmasolja az esi cimen levo erteket es az esi-t noveli
		
		cmp al, 0x00  ; befejezodott a string
		je .null
		
		call mio_writechar
		
		jmp .nextchar
	.null:
		pop esi
		pop eax
		ret

; NewLine():() – újsor elejére lépteti a kurzort
NewLine: ; newline = carriage return + line feed
	push eax
	
	mov eax, 13   ;carriage return kiiratas
	call mio_writechar
	
	mov eax, 10   ; line feed kiiratas
	call mio_writechar
	
	pop eax
	ret

; ReadLnStr(EDI, ECX):()   – mint a ReadStr() csak újsorba is lép	
ReadLnStr:
	call ReadStr  ;string beolvasas
	call NewLine  ;ujsor
	
	ret

; WriteLnStr(ESI):() – mint a WriteStr() csak újsorba is lép
WriteLnStr:
	call WriteStr  ;string kiiratas
	call NewLine   ;ujsor 
	
	ret
