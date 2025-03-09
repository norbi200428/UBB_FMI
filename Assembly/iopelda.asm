; nasm -f win32 iostr.asm
; nasm -f win32 ionum.asm
; nasm -f win32 iopelda.asm
; nlink iostr.obj ionum.obj iopelda.obj -lmio -o iopelda.exe
; iopelda.exe

; Nev: Lako Norbert
; Azonosito: lnam0397
; Csoport: 621

; Feladat: Az előző három eljárásgyűteményhez készítsünk (a megfelelő, megértést segítő szövegeket is tartalmazó!) példaprogramot, 
; a következők szerint: beolvasunk egy - egy szamot 10es 16os, majd 2es szamrendszerben, kiirjuk mindharom szamot mindegyik szamrendszerben, majd a harom szam osszeget is.

%include 'mio.inc'
%include 'iostr.inc'
%include 'ionum.inc'

global main 

section .text

main:
	mov esi, prompt_in_int
	call WriteStr
	
	call ReadInt		; beolvas egy szamot 10es szamrendszerben
	jc .read_error
	
	call NewLine
	
	mov esi, prompt_out_int
	call WriteStr
	
	call WriteInt		; kiirja a szamot 10es szamrendszerben
	
	call NewLine
	
	mov esi, prompt_out_hex
	call WriteStr
	
	call WriteHex		; kiirja a szamot 16os szamrendszerben
	
	call NewLine 
	
	mov esi, prompt_out_bin
	call WriteStr
	
	call WriteBin		; kiirja a szam 2es szamrendszerben
	
	call NewLine
	
	mov ebx, eax		; atmasolja a szamot az ebx-be
	
	mov esi, prompt_in_hex
	call WriteStr
	
	call ReadHex		; beolvas egy szamot 16os szamrendszerben
	jc .read_error
	
	call NewLine
	
	mov esi, prompt_out_int
	call WriteStr
	
	call WriteInt
	
	call NewLine 
	
	mov esi, prompt_out_hex
	call WriteStr
	
	call WriteHex
	
	call NewLine 
	
	mov esi, prompt_out_bin
	call WriteStr
	
	call WriteBin
	
	call NewLine 
	
	add ebx, eax		; az ebx-ben taroljuk az elso ket szam osszeget	
	
	mov esi, prompt_in_bin
	call WriteStr
	
	call ReadBin		; beolvas egy szamot 2es szamrendszerben
	jc .read_error
	
	call NewLine
	
	mov esi, prompt_out_int
	call WriteStr
	
	call WriteInt
	call NewLine
	
	mov esi, prompt_out_hex
	call WriteStr
	
	call WriteHex
	call NewLine
	
	mov esi, prompt_out_bin
	call WriteStr
	
	call WriteBin
	
	call NewLine 
	
	add eax, ebx		; a 3. szamhoz hozzaadja az elso ketto osszeget
	
	mov esi, prompt_out_int
	call WriteStr
	
	call WriteInt
	call NewLine
	
	mov esi, prompt_out_hex
	call WriteStr
	
	call WriteHex
	call NewLine
	
	mov esi, prompt_out_bin
	call WriteStr
	
	call WriteBin
	
	call NewLine 
	
	ret
	
	; ha be van allitva a cf error-t dob
	.read_error:
		call NewLine
		mov esi, prompt_hiba
		call WriteStr
		ret
section .data
	prompt_error dd 'A megadott szam nem megfelelo!', 0
	prompt_in_int dd 'Adj meg egy 32 bites egesz szamot 10-es szamrendszerben: ', 0
	prompt_in_hex dd 'Adj meg egy 32 bites egesz szamot 16-os szamrendszerben: ', 0
	prompt_in_bin dd 'Adj meg egy 32 bites egesz szamot 2-es szamrendszerben: ', 0
	prompt_out_int dd 'A szam 10-es szamrendszerbeli alakja: ', 0
	prompt_out_hex dd 'A szam 16-os szamrendszerbeli alakja: ', 0
	prompt_out_bin dd 'A szam 2-es szamrendszerbeli alakja: ', 0
	prompt_hiba dd 'Hiba'