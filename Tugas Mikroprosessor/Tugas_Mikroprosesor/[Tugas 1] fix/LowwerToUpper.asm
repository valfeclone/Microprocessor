%INCLUDE "console.inc"

;VARIABEL DECLARATION
;------------------------------------------------------------------------------------------------
section .data 		

judul		db "Read Text and Reverse Display", 0 
teks1           db 13,10,13,10," Write Text   : ", 0 
pteks1		dd 0 
teks2           db 13,10,13,10," Your Text    : ", 0 
pteks2		dd 0 
teks3           db 13,10,13,10," RESULT 	: ", 0 
pteks3		dd 0 
teks4		db 13,10,13,10,13,10," Wait 60 seconds ....................",0 
pteks4	        dd 0 

buff		resb 255
nul		db 0
buff_len	dd 256
buf2		resb 255
nul2		db 0
buf2_len	dd 256

section .bss 	;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1


; MAIN PROGRAM
;================================================================================================

section .text use32 
..start: 

	initconsole judul, hStdOut, hStdIn						  ; CREATE CONSOLE
	display_text teks1, pteks1, nBytes, hStdOut			; DISPLAY TEXT MESSAGE
	
	call read_text																	; READ TEXT FROM KEYBOARD
	

	display_text teks2, pteks2, nBytes, hStdOut			; DISPLAY TEXT MESSAGE
	call display_buffer															; DISPLAY WRITTEN TEXT 

	call Lowwer_to_Upper
	 
	display_text teks3, pteks3, nBytes, hStdOut			; DISPLAY TEXT MESSAGE
	call display_buffer															; DISPLAY RESULT

	display_text teks4, pteks4, nBytes, hStdOut			; DISPLAY TEXT MESSAGE
	delay 30000				 														 	; WAIT 60 seconds

	quitconsole																			; CLEAR CONSOLE

;=================================================================================================

read_text:
				;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 			;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 		;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 		;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 		;; parameter ke 1 handle stdin
call [ReadFile] 			
ret
;--------------------------------------------------------------------------------------------------

display_buffer:
push dword 0 				;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes			;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 		;; parameter ke 3 panjang string
push dword buff				;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------

display_buffer2:
push dword 0 				;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes			;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [iBytes] 		;; parameter ke 3 panjang string
push dword buf2				;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------

;Lowwer to UpperCase
Lowwer_to_Upper:
				
mov ebx, buff
mov ecx, [iBytes]			; masih mengandung enter 
						
sub ecx,2					; counter kurangi 2 (krn tdk termasuk enter)
mov [iBytes],ecx			; panjang asli
upper:								
	mov al, [ebx]
	cmp al,97					; 97= asli a
	jl next
	cmp al,122					; 122 = asli z
	jg next	
	sub al,32					; 
	mov [ebx],al		; mengubah nilai char ke i menjadi al
next:

	add ebx,0x1
	loop upper
ret
	
	
	
	
	
	

	




