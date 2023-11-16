;HEX value to decimal value
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
number_system dd 8

text db 'Value of EAX is: ', 0
text_len equ $-text

buffer_out db 12 dup (?);maksymalna wartosc to 2^32 czyli 10cyfr + 1 znak nowej linii + znak minusa
buffer_out_length equ 12

entry_text db 'Type first value: ', 0
entry_text_len equ $-entry_text

entry_text1 db 'Type second value: ', 0
entry_text_len1 equ $-entry_text1

base_text db 'Octal system: ', 0
base_text_len equ $-base_text

decimal_text db 'Decimal system: ', 0
decimal_text_len equ $-decimal_text

.code
_load_number_to_EAX_U2_b13 PROC
	;prolog
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	sub esp, 12 ; rezerwacja tablicy na znaki HEX poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pamiêci
	
	push dword PTR 10 ; max iloœæ znaków wczytyw. liczby to 8 + znak nowej linii + znak minusa
	push esi ; adres obszaru pamiêci
	push dword PTR 0
	call __read
	add esp, 12 ; usuniêcie parametrów ze stosu
	mov eax, 0 ; zerowanie EAX, bo znajduje sie tu liczba wprowadzonych znakow

	mov bl, 0
	cmp byte PTR [esi], '-'
	jne load_next_digit
	mov bl, 1


	load_next_digit:

		;pobranie kolejnego znaku
		mov cl, [esi]
		inc esi

		cmp cl, 0Ah ;porownanie pobranego znaku do entera
		je was_enter ;jesli byl enter wyjdz z petli
		cmp cl, '0'
		jb load_next_digit
		cmp cl, '9'
		ja check_capital_letter
		sub cl, 30h ;change ASCII sign to digit
		jmp add_to_eax
		
		check_capital_letter:
			cmp cl, 'A'
			jb load_next_digit
			cmp cl, 'C'
			ja check_small_letters
			sub cl, ('A' + 10)
			jmp add_to_eax

		check_small_letters:
			cmp cl, 'a'
			jb load_next_digit
			cmp cl, 'c'
			ja load_next_digit
			sub cl, ('a' + 10)

		
		add_to_eax:
		movzx ecx, cl ;skopiowanie cl do ecx i uzupelnienie zerami
		;mnozenie wczesniej obliczonej wartosic przez system_number
		mul dword PTR number_system
		add eax, ecx ;dodanie ostatnio odczytanej cyfry
		jmp load_next_digit
	
	
	
	was_enter:
		cmp bl, 0
		je positive_value
		neg eax

		positive_value:
		add esp, 12
		pop ebx
		pop edi
		pop esi
		;epilog
		pop ebp
		ret
_load_number_to_EAX_U2_b13 ENDP

Display_EAX_U2_b13 PROC
	;prolog
	push ebp
	mov ebp,esp 
	pusha

	;obsluga liczb U2
	mov cl, 0 ;ustawienie zera gdy liczba jest dodatnia
	bt eax, 31
	jnc positive_value
	neg eax
	mov cl, 1 ;ustawienie jedynki gdy liczba jest dodatnia


	positive_value:
	mov ebx, 8; ustawienie dzielnika na 13
	mov buffer_out[buffer_out_length-1], 0Ah ; wstawienie znaku nowej lini na ostatni indkes buffor_out
	mov edi, buffer_out_length-2 ; ustawienie indkesu odpowiedzialnego za buffer_out na przedostatni indeks

	divide:
		mov edx, 0 ; zerowanie starszej czêœci dzielnej
		div ebx ; dzielenie przez 13, reszta w EDX, iloraz w EAX
		cmp dl, 9
		ja convert_to_letter ;jesli to znak to nie cyfra przejdz do sprawdzania cyfr
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII (30h = 0, 31h = 1, ...)
		jmp load_to_buffer

		convert_to_letter:
			sub dl, 10 ;odjecie 10 od dl, czyli 12-10=2
			add dl, 'A' ;zamiana wartosci na litere np 2+'A'='C'


		load_to_buffer:
		mov buffer_out [edi], dl; zapisanie litery/cyfry w kodzie ASCII
		dec edi ;zmniejszenie indeksu buffer_out
		cmp eax, 0 ; sprawdzenie czy iloraz = 0, czyli liczba, któr¹ aktualnie dzielisz
		jne divide ;jesli iloraz nie jest zerem, dziel dalej


	;sprawdzenie czy cl jest 0, bo to oznacza czy liczba jest dodatnia
	cmp cl, 0
	je dont_add_minus ;jesli jest dodatnia przejdz dalej bez dodawania minusa
	mov buffer_out[edi], '-' ;dodaj minus do tablicy
	dec edi


	dont_add_minus:
	cmp edi, -1
	je print ;jeslli buffor jest wypelniony do konca przejdz do wypisywania liczby
	; wype³nienie pozosta³ych bajtów '0'
	fill_next_values:
		cmp edi, -1
		mov buffer_out[edi], 0
		dec edi
		jne fill_next_values


	print:
	;wyswietlenie liczby
	push buffer_out_length
	push OFFSET buffer_out
	push 1
	call __write
	add esp, 12

	popa	
	;epilog
	pop ebp
	ret
Display_EAX_U2_b13 ENDP


_display_eax PROC
	;prolog
	push ebp
	mov ebp,esp 
	pusha

	mov ebx, 10; ustawienie dzielnika na 10
	mov buffer_out[buffer_out_length-1], 0Ah ; wstawienie znaku nowej lini na ostatni indkes buffor_out
	mov edi, buffer_out_length-2 ; ustawienie indkesu odpowiedzialnego za buffer_out na przedostatni indeks

	divide:
		mov edx, 0 ; zerowanie starszej czêœci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII (30h = 0, 31h = 1, ...)
		mov buffer_out [edi], dl; zapisanie cyfry w kodzie ASCII
		dec edi ;zmniejszenie indeksu buffer_out
		cmp eax, 0 ; sprawdzenie czy iloraz = 0, czyli liczba, któr¹ aktualnie dzielisz
		jne divide ;jesli iloraz nie jest zerem, dziel dalej

	cmp edi, -1
	je print ;jeslli buffor jest wypelniony do konca przejdz do wypisywania liczby
	; wype³nienie pozosta³ych bajtów '0'
	fill_next_values:
		cmp edi, -1
		mov buffer_out[edi], 0
		dec edi
		jne fill_next_values

	print:
	;wyswietlenie liczby
	push buffer_out_length
	push OFFSET buffer_out
	push 1
	call __write
	add esp, 12
	

	popa	
	;epilog
	pop ebp
	ret

_display_eax ENDP

_main PROC

	push entry_text_len
	push OFFSET entry_text
	push 1
	call __write
	add esp, 12
	
	call _load_number_to_EAX_U2_b13
	
	mov ebx, eax

	push entry_text_len1
	push OFFSET entry_text1
	push 1
	call __write
	add esp, 12

	call _load_number_to_EAX_U2_b13
	add eax, ebx
	
	push eax
	
	push base_text_len
	push OFFSET base_text
	push 1
	call __write
	add esp, 12

	pop eax
	call Display_EAX_U2_b13
	
	push eax 

	push decimal_text_len
	push OFFSET decimal_text
	push 1
	call __write
	add esp, 12

	pop eax
	call _display_eax

	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END