;program which gets number from user and loads it into EAX register
;then displaying that number in console

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
buffer_in db 9 dup (?)
max_buffer_length equ 10
amount_of_entered_digits dd ?

number_system dd 10

text db 'Value of EAX in HEX:', 0
text_len equ $-text

entry_text db 'Type value you want load to EAX: ', 0
entry_text_len equ $-entry_text

decoder db '0123456789ABCDEF'

.code

_load_number_to_eax PROC
	;prolog
	push ebp
	mov ebp, esp

	;zerowanie indkesow
	mov eax, 0 
	mov esi, 0

	load_next_digit:

		;pobranie kolejnego znaku
		mov cl, buffer_in[esi]
		inc esi

		cmp cl, 0Ah ;porownanie pobranego znaku do entera
		je was_enter ;jesli byl enter wyjdz z petli

		sub cl, 30h ;change ASCII sign to digit
		movzx ecx, cl ;skopiowanie cl do ecx i uzupelnienie zerami

		;mnozenie wczesniej obliczonej wartosic przez system_number
		mul dword PTR number_system
		add eax, ecx ;dodanie ostatnio odczytanej cyfry
		jmp load_next_digit
	was_enter:

		;epilog
		pop ebp
		ret
_load_number_to_eax ENDP


_display_EAX_hex PROC
	pusha

	sub esp, 12 ;zarezerwowanie obszaru na zmienne lokalne
	mov edi, esp ;przepisanie adresu wierzcholka do obszaru do ktorego bedziemy zapisywac wartosci HEX

	mov ecx, 8 ;ustawienie licznika na 8, bo 32/4=8
	mov esi, 0 ;wyzerowanie esi

	take_next_4_bits:
		rol eax, 4 ;przesuniecie 4 najsatrszych bitow na poczatek

		mov ebx, eax ;stworzenie kopii eax w ebx
		and ebx, 0000000Fh ;wyodrebnienia 4 najmlodszych bitow
		mov dl, decoder[ebx] ;zapisanie do dl wartosc HEX 4 najmlodzsych bitow EAX

		mov [edi][esi], dl ;zapisanie wartosci HEX do tymczasowego buffora na stosie 
		inc esi
	loop take_next_4_bits

	mov byte PTR [edi][esi], 0Ah ; zapisanie znaku nowej linii na koncu


	;uzupelnianie spacjami nieznaczacych zer
	mov ecx, 0
	replace_leading_zero:
		cmp byte PTR [edi][ecx], '0' ;porownaj znak do '0'
		jne print
		mov byte PTR [edi][ecx], ' ' ;lub 0 jesli nie checmy spacji
		inc ecx
	jmp replace_leading_zero

	print:
	push 9 ;8 znakow HEX + znak nowej linii
	push edi
	push 1
	call __write
	add esp, 12

	add esp, 12 ;usuniecie tymczasowego buffora na znaki HEX
	popa
	ret
_display_EAX_hex ENDP


_main PROC

	;entry text displaying
	push entry_text_len
	push OFFSET entry_text
	push 1
	call __write
	add esp, 12

	;reading provided text
	push max_buffer_length
	push OFFSET buffer_in
	push 0
	call __read
	add esp, 12
	mov amount_of_entered_digits, eax


	call _load_number_to_eax
	push eax ;load eax on stack, because __write changes it

	push text_len
	push OFFSET text
	push 1
	call __write
	add esp, 12

	pop eax ;popping eax after __write function
	call _display_EAX_hex

	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END