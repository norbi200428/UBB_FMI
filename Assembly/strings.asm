;Nev: Lako Norbert
;Azonosito: lnam0397
;Csoport: 621

; Feladat: Készítsük el a következő stringkezelő eljárásokat és helyezzük el őket egy STRINGS.ASM / INC nevű modulba.

%include 'mio.inc'
%include 'iostr.inc'

global StrLen
global StrCat
global StrUpper
global StrLower
global StrCompact

section .text

; StrLen(ESI):(EAX) – EAX-ben visszatéríiti az ESI által jelölt string hosszát, kivéve a bináris 0-t
StrLen:
	push ecx
	push esi
	xor ecx, ecx
	
	;bejarjuk a stringet, minden karakter utan noveljuk az ecx erteket, majd atmasoljuk az ecx erteket az eax-be-
	.nextCharLen:
		lodsb
		
		cmp al, 0x00
		je .endLen
		
		inc ecx
		jmp .nextCharLen
		
	.endLen:
		mov eax, ecx
		
		pop esi
		pop ecx
		
		ret

;StrCat(EDI, ESI):() – összefűzi az ESI és EDI által jelölt stringeket (azaz az ESI által jelöltet az EDI után másolja)
StrCat:
	push eax
	push ecx
	push edi
	push esi
	
	mov esi, edi
	call StrLen   ; eax = len(edi)
	
	pop esi  ; visszaallitja az esi-t a kezdeti esi-ReadLnStr
	push esi
	
	add edi, eax ; edi vegere megyunk 
	
	call StrLen  ; eax = len(esi)
	
	mov ecx ,eax ; ecx-be masoljuk az esi hozzat + 1 ami a null karakter
	inc ecx
	
	.copyChar:
		lodsb    ; atmasoljuk az edi vegere az esi-t
		stosb
	
		loop .copyChar
	
	pop esi
	pop edi
	pop ecx
	pop eax
	
	ret
	
; StrUpper(ESI):() – nagybetűssé konvertálja az ESI stringet	
StrUpper:
	push eax
	push esi
	push edi
	
	.nextCharUpper:
		lodsb   ; al-be masolunk egy karaktert
		
		cmp al, 0x00 
		je .endUpper
		
		cmp al, 'a'     ; ha nem kisbetu, akkor tovabblepunk
		jb .nextCharUpper
		
		cmp al, 'z'
		ja .nextCharUpper
		
		sub al, 32   ; 'a' - 'A' = 32  => nagybetuve alakitjuk
		
		;stosb-t hasznalva atmasoljuk a kapott nagybetut a kisbetu helyere
		push esi 
		push edi
		
		dec esi
		mov edi, esi
		
		stosb     
		
		pop edi
		pop esi
		
		jmp .nextCharUpper
		
	.endUpper:
	
		pop edi
		pop esi
		pop eax
		
		ret

; StrLower(ESI):() – kisbetűssé konvertálja az ESI stringet
StrLower:
	push eax
	push esi
	push edi
	
	.nextCharLower:
		lodsb
		
		cmp al, 0x00
		je .endLower
		
		cmp al, 'A' 	; ha nem nagybetu, akkor tovabblepunk
		jb .nextCharLower
		
		cmp al, 'Z'
		ja .nextCharLower
		
		add al, 32 		; 'a' - 'A' = 32  => kisbetuve alakitjuk
		
		;stosb-t hasznalva atmasoljuk a kapott kisbetut a nagybetu helyere
		push esi 
		push edi
		
		dec esi
		mov edi, esi
		
		stosb     
		
		pop edi
		pop esi
		
		jmp .nextCharLower
		
	.endLower:
		pop edi
		pop esi
		pop eax
		
		ret
	
; StrCompact(ESI, EDI):() – EDI-be másolja át az ESI stringet, kivéve a szóköz, tabulátor (9), kocsivissza (13) és soremelés (10) karaktereket	
StrCompact:
	push eax
	push edi
	push esi
	
	; akkor masolunk at egy karaktert ha az nem space, tab, carriage return vagy line feed
	.loopCompact:
		lodsb
		
		cmp al, 32  ; SPACE
		je .loopCompact
		
		cmp al, 9  ; TAB
		je .loopCompact
		
		cmp al, 13 ; CARRIAGE RETURN
		je .loopCompact
		
		cmp al, 10 ; LINE FEED
		je .loopCompact
		
		stosb
		
		cmp al, 0x00
		jne .loopCompact
		
		pop esi
		pop edi
		pop eax
		
		ret