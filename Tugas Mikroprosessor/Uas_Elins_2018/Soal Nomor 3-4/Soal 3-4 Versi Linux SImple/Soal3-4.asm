%macro readInput 3 
   mov eax, 3           ; sys_write
   mov ebx, 2           ; struct pt_regs
   mov ecx, %1          ; Memory location
   mov edx, %2          ; MaxLen input
   int 80h              ; call kernel

   xor eax,eax
   xor edi,edi
   mov ebx, %1
   hitungPanjang:
   mov al,[ebx]
   cmp al,0            ; cek apakah sudah di akhir string
   je selesai
   inc edi
   inc ebx
   jmp hitungPanjang
   selesai:
   mov eax,edi
   mov [%3],al          ; simpan panjang string dari input user ke paramter ke 3

%endmacro

%macro writeOutput 2 
    mov eax, 4          ; sys_write
    mov ebx, 1          ; struct pt_regs
    mov ecx, %1         ; Memory location
    mov edx, %2         ; Len String
    int 80h             ; cal kernel
%endmacro

%macro exit 0
    
    mov eax, 1          ; Exit code
    mov ebx, 0
    int 80h
%endmacro

%macro  Numeric2Str 2
mov edi,%1
xor eax,eax
mov ebx, %2	;; hasil konversi disimpan di strhasil
	
 loop1:				
	inc ebx			;; ebx digunakan sebagai pointer ke strhasil
	cmp byte[ebx],0		;; diposisikan pada akhir string strhasil 
	jne loop1
	dec ebx    		
				
	mov eax, edi	;; edi = parameter yang diambil dari hasil counting char/word
	mov si,10		
 loop2:				
	xor edx, edx		;; edx di-nolkan untuk menampung sisa bagi
	div si			;; dilakukan pembagian 10 berulang
	add dl, '0'        	;; sisa bagi pada edx (dl) di ubah ke character
	mov [ebx], dl		;; simpan ke strhasil dari belakang ke depan
	dec ebx			;; majukan pointer
	or  eax,eax		;; test apakah yang dibagi sudah nol
	jnz loop2 		;; selesai perulangan jika yang dibagi sdh nol

%endmacro


section .data
    userMsg         db 'Please enter a String   :'  
    lenUserMsg      equ $-userMsg               ;The length of the message
    dispMsg         db 'Result                  :'
    lenDispMsg      equ $-dispMsg
    strhasil	    db '      ',0			    

section .bss
    UserInput       resb 256
    LenUserInput    resb 1

section .text
   global _start   
_start:	           ;tell linker entry point
    
    writeOutput userMsg,lenUserMsg
    
    readInput  UserInput,256,LenUserInput

    push dword [LenUserInput]           ; Parameter kedua
    push dword UserInput                ; Parameter pertama
    call JKata                          ; Call JKata procedure

    Numeric2Str eax,strhasil
    writeOutput dispMsg,lenDispMsg

    writeOutput strhasil,6              ; 6= panjang strhasil

    exit
    
;--------------------------------------------------------------------------------------

;==========================================================================================
; WORD


JKata:
push ebp
mov ebp,esp
mov ebx,dword [ebp+8]	; offset / alamat input
mov ecx,dword [ebp+12]	; Panjang string
cmp ecx,0               ; cek apakah input kosong
je enddd

xor edi,edi
xor esi,esi

	start_count_word:
		mov al,byte[ebx]
		cmp al,32
		jle count_word
		mov esi,1
		jmp next_char
	count_word:
		cmp esi,1
		jne next_char
		add edi,1
		xor esi,esi
	
	next_char:
		inc ebx
		loop start_count_word
	enddd:
	mov eax,edi
    leave
	ret
		



