%INCLUDE "console.inc"

; CpUps Macro
%MACRO CpUps 2
				
mov esi, %1
mov edi, %2
upper:								
	mov al, [esi]
	cmp al,0
	je stop
	cmp al,10
	je stop
	cmp al,97					; 97= asli a
	jl next
	cmp al,122					; 122 = asli z
	jg next	
	sub al,32					; 
	; mengubah nilai char ke i menjadi al
next:
	mov [edi],al
	inc esi
	inc edi
	jmp upper
stop:
%ENDMACRO 
; end of CpUps Macro


%MACRO read_text 4				;; membaca string dari Console(keyboard) dg ReadFile
	push dword 0 				;; parameter ke 5 dari ReadFile() adalah 0 
	push dword %1 				;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
	push dword [%2] 			;; parameter ke 3 panjang StringAer yg disediakan
	push dword %3 				;; parameter ke 2 StringAer untuk menyimpan string yg dibaca 
	push dword [%4] 			;; parameter ke 1 handle stdin
	call [ReadFile] 			
%ENDMACRO

%MACRO write_text 4

	push dword 0
	push dword %1
	push dword [%2]
	push dword %3
	push dword [%4]
	call [WriteFile] 

%ENDMACRO


;VARIABEL DECLARATION
;------------------------------------------------------------------------------------------------
section .data 		

judul		db "Soal 1", 0 
teks1       db 13,10,13,10," Write Text   : ", 0 
pteks1		dd 0 
teks2       db 13,10,13,10," Your Text    : ", 0 
pteks2		dd 0 
teks3       db 13,10,13,10," Result 	: ", 0 
pteks3		dd 0 
teks4		db 13,10,13,10,13,10," Wait 5 seconds ....................",0 
pteks4	    dd 0 

StringA		resb 255
nul			db 0
StringA_len	dd 256
StringB		resb 255
nul2		db 0
StringB_len	dd 256

section .bss 	;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1


; MAIN PROGRAM
;================================================================================================

section .text use32 
..start: 

	initconsole 		judul,  hStdOut, hStdIn								; CREATE CONSOLE
	
	display_text 		teks1,  pteks1, nBytes, hStdOut						; DISPLAY TEXT MESSAGE
	read_text 			iBytes, StringA_len, StringA, hStdIn				; READ TEXT FROM KEYBOARD
	
	display_text 		teks2,  pteks2,  nBytes,  hStdOut					; DISPLAY TEXT MESSAGE
	write_text 			nBytes, iBytes,StringA, hStdOut						; DISPLAY WRITTEN TEXT
		
	CpUps 				StringA,StringB
	
	display_text 		teks3, pteks3, nBytes, hStdOut						; DISPLAY TEXT MESSAGE
	write_text 			nBytes, iBytes,StringB, hStdOut						; DISPLAY WRITTEN TEXT
	
	display_text teks4, pteks4, nBytes, hStdOut								; DISPLAY TEXT MESSAGE
	delay 5000				 												; WAIT 60 seconds

	quitconsole																; CLEAR CONSOLE

;=================================================================================================

	
	
	
	
	
	

	




