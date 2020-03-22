IMPORT MessageBoxA user32.dll
IMPORT ExitProcess kernel32.dll

EXTERN MessageBoxA	
EXTERN ExitProcess

mbtitle	db "DIKE FMIPA-UGM", 0
mbtext	db "ILMU KOMPUTER HEBAT",0 

section .bss 	; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1


segment .code use32
..start:	
 call mbox
 call [ExitProcess]
 leave
ret

segment .data use32

mbox:
 push dword 30h			; tombol Button
 push dword mbtitle		; judul windows
 push dword mbtext  	; Pesan yg ditampilkan, diakhiri 0 (null)
 push dword 0			; owner windows dari msgbox, atau NULL (tdk punya owner)

 call [MessageBoxA]
ret


 