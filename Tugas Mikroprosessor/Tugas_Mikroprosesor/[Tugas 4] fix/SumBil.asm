%INCLUDE "console1.inc"
IMPORT MessageBoxA user32.dll
IMPORT ExitProcess kernel32.dll

EXTERN MessageBoxA	
EXTERN ExitProcess	


;VARIABEL DECLARATION
;------------------------------------------------------------------------------------------------
section .data 		

judul		db "Add Program", 0 
teks1       db 13,10,13,10," Write Number     : ", 0 
pteks1		dd 0 
teks3       db 13,10,13,10,"Ulangi Y/N : ", 0 
pteks3		dd 0 
teks4       db 13,10,13,10," Masukkan bilangan untuk dijumlahkan ", 0 
pteks4		dd 0 
teks5       db 13,10,13,10," Penjumlahan akan berakhir jika tidak ada input atau input bernilai 0 ", 0 
pteks5		dd 0 
teks6       db 13,10,13,10," Jika input yang dimasukkan mengandung karakter selain bilangan, maka input akan bernilai 0 ", 0 
pteks6		dd 0 
	
buff		resb 255
nul			db 0
buff_len	dd 256

teks2       db 13,10,13,10," Hasil                      : "
strhasil	db '            ',0			; Total char
ptekssthasil dd 0
str_len		db 12

bil			resd 1
hasilSum	dd 0

section .bss 	;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1

; MAIN PROGRAM
;================================================================================================
section .text use32 
..start: 



	initconsole judul, hStdOut, hStdIn				; CREATE CONSOLE
	display_text teks4, pteks4, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	display_text teks5, pteks5, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	display_text teks6, pteks6, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
ULANGI:
	display_text teks1, pteks1, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	
	call read_text									; READ TEXT FROM KEYBOARD
	
	cekzeroinput:									; Jika tidak ada input maka penjumlahan akan berhenti
		mov ecx,[iBytes]
		cmp ecx, 2
		je stopr
		
	cekbuff:
		mov ebx,buff
		mov ecx,[iBytes]
		sub ecx,2
	
		cek:
			mov al,byte[ebx]
			cmp al,47
			jle ULANGI
			cmp al,58
			jge ULANGI
			inc ebx
			loop cek
		
	call Str2Bil								; convert str to num
	mov eax,[bil]
	cmp eax,0
	je stopr
	
	call adder										; add
	jmp ULANGI
	
	stopr:
	
	call Bil2Str
	;display_text teks2, pteks2, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	;display_text strhasil, ptekssthasil, nBytes,hStdOut
	call messagebox	
		
	mov dword[hasilSum],0
	call reset_strhasil
	
	display_text teks3, pteks3, nBytes, hStdOut		; DISPLAY TEXT MESSAGE
	call read_text
	mov ebx,buff
	mov al,byte[ebx]
	cmp al,'y'
	je ULANGI
	cmp al,'Y'
	je ULANGI
	
	quitconsole										; CLEAR CONSOLE
;=================================================================================================

messagebox:
	push dword 00h		; tombol Button
 	push dword judul	; judul windows
 	push dword teks2     ; Pesan yg ditampilkan, diakhiri 0 (null)
 	push dword 0		; owner windows dari msgbox, atau NULL (tdk punya owner)

	call [MessageBoxA]
	ret

read_text:
			;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 		;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 	;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 	;; parameter ke 3 panjang buffer yg disediakan
push dword buff 	;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 	;; parameter ke 1 handle stdin
call [ReadFile] 			
ret
;--------------------------------------------------------------------------------------------------
display_total:
push dword 0 			;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes		;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [str_len] 		;; parameter ke 3 panjang string
push dword strhasil		;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------

reset_strhasil:
	mov ebx,strhasil
	xor ecx,ecx
	mov cl,byte[str_len]
	sub cl,1	
	strt:
		mov byte[ebx],32
		inc ebx
		loop strt
	ret


;-------------------------------------------------------------------------------------

Bil2Str:
	mov ebx, strhasil			;; hasil konversi disimpan di strhasil
 loop11:
    mov byte[ebx],' '
	inc ebx						;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0				;; diposisikan pada akhir string strhasil 
	jne loop11
	dec ebx    

	mov eax, [hasilSum]			;; bilx2 berisi bilangan yg akan dikonversi
	mov esi,10
 loop22:
	xor edx, edx				;; edx di-nolkan untuk menampung sisa bagi
	div esi						;; dilakukan pembagian 10 berulang
	add dl, '0'        			;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl				;; simpan ke strhasil dari belakang ke depan
	dec ebx						;; majukan pointer
	or  eax,eax					;; test apakah yang dibagi sudah nol
	jnz loop22 					;; selesai perulangan jika yang dibagi sdh nol
ret

Str2Bil:
        xor eax,eax				;set hasil = 0
        mov esi, 10				;pengali 10
        mov ebx, buff
		mov ecx, [iBytes]
		sub ecx, 2
		xor edx,edx
    Loopbil:
        mul esi 				;hasil sebelumnya * 10
        mov dl, byte [ebx]
        sub dl,30h 				;ubah ke 0-9
        add eax,edx 			;tambahkan dg digit terakhir 
        inc ebx
        loop Loopbil
    
	mov [bil], eax
ret


adder:
	mov eax,dword[hasilSum]
	mov edi,[bil]
	add eax,edi
	mov dword[hasilSum],eax
	
	ret
	