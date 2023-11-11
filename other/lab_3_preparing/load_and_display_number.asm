;program which gets number from user and loads it into EAX register
;then displaying that number in console

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
buffer_in db 11 dup (?) ;maksymalna wartosc to 2^32 czyli 10cyfr + 1 znak nowej linii
max_buffer_length equ 12 ;11+1 zeby w przypadku 10 znakow przeczytalo entera
amount_of_entered_digits dd ?

buffer_out db 11 dup (?);maksymalna wartosc to 2^32 czyli 10cyfr + 1 znak nowej linii
buffer_out_length equ 11

number_system dd 10 ;system liczbowy

text db 'Value of EAX: ', 0
text_len equ $-text

entry_text db 'Type value you want load to EAX: ', 0
entry_text_len equ $-entry_text

.code

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

_load_number_to_eax PROC
	;prolog
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

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


		pop ebx
		pop edi
		pop esi
		;epilog
		pop ebp
		ret
_load_number_to_eax ENDP





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
	call _display_eax

	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END