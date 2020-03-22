%INCLUDE "console.inc"

;DEKLARASI VARIABEL
;------------------------------------------------------------------------------------------------
section .data 		

judul			db "Membaca Data Bilangan --> Dikalikan 2", 0 
teks1           db 13,10,13,10,"Tulis Bilangan  : ", 0 
pteks1			dd 0 
teks2           db 13,10,13,10,"Dikalikan 2 menjadi : ", 0 
pteks2			dd 0 
teks3			db 13,10,13,10,"Lagi ? (y/t) : ",0 
pteks3	        dd 0 


buff			resb 255
buff_len		dd 255

bil				resd 1 
bilx2			resd 1

strhasil		db '           ',0
str_len			db 12

section .bss 	;; Initialisasi variabel: hStdOut, hStdIn, nBytes, iBytes dg type double-word

hStdOut         resd 1 
hStdIn          resd 1 
nBytes          resd 1
iBytes          resd 1

; MULAI PROGRAM
;--------------------------------------------------------------------------------------------------
section .text use32 
..start: 
initconsole judul, hStdOut, hStdIn
ULANGI:
tampilkan_teks teks1, pteks1, nBytes, hStdOut
call BacaStr
call Str2Bil

mov eax, [bil]
add eax, eax
mov [bilx2], eax

call Bil2Str
tampilkan_teks teks2, pteks2, nBytes, hStdOut
call TampilkanStrhasil

tampilkan_teks teks3, pteks3, nBytes, hStdOut
call BacaStr
mov ebx, buff
mov al, [ebx]
cmp al, 'y'
je ULANGI

quitconsole
;=================================================================================================
; MENGKONVERSI STRING(buff) KE NUMERIK  (bil) 
;-------------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------------
; MENGKONVERSI NUMERIK (bil) KE STRING (strhasil) 
;-------------------------------------------------------------------------------------
Bil2Str:
	mov ebx, strhasil			;; hasil konversi disimpan di strhasil
 loop1:
    mov byte[ebx],' '
	inc ebx						;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0				;; diposisikan pada akhir string strhasil 
	jne loop1
	dec ebx    

	mov eax, [bilx2]			;; bilx2 berisi bilangan yg akan dikonversi
	mov esi,10
 loop2:
	xor edx, edx				;; edx di-nolkan untuk menampung sisa bagi
	div esi						;; dilakukan pembagian 10 berulang
	add dl, '0'        			;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl				;; simpan ke strhasil dari belakang ke depan
	dec ebx						;; majukan pointer
	or  eax,eax					;; test apakah yang dibagi sudah nol
	jnz loop2 					;; selesai perulangan jika yang dibagi sdh nol
ret
;--------------------------------------------------------------------------------------
BacaStr:
							;; membaca string dari Console(keyboard) dg ReadFile
push dword 0 				;; parameter ke 5 dari ReadFile() adalah 0 
push dword iBytes 			;; parameter ke 4 jumlah byte yg sesungguhnya terbaca (TERMASUK ENTER)
push dword [buff_len] 		;; parameter ke 3 panjang buffer yg disediakan
push dword buff 			;; parameter ke 2 buffer untuk menyimpan string yg dibaca 
push dword [hStdIn] 		;; parameter ke 1 handle stdin
call [ReadFile] 			
ret
;--------------------------------------------------------------------------------------------------
TampilkanStrhasil:
push dword 0 				;; parameter ke 5 dari WriteFile() adalah 0 
push dword nBytes			;; parameter ke 4 jumlah byte yg sesungguhnya tertulis
push dword [str_len] 		;; parameter ke 3 panjang string
push dword strhasil			;; parameter ke 2 string yang akan ditampilkan 
push dword [hStdOut] 		;; parameter ke 1 handle stdout
call [WriteFile] 
ret
;--------------------------------------------------------------------------------------------------