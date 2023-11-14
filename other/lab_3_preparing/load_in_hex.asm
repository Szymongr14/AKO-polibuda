;HEX value to decimal value
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
number_system dd 10

text db 'Value of EAX is: ', 0
text_len equ $-text

buffer_out db 11 dup (?);maksymalna wartosc to 2^32 czyli 10cyfr + 1 znak nowej linii
buffer_out_length equ 11

entry_text db 'Type value in HEX you want load to EAX: ', 0
entry_text_len equ $-entry_text

.code
_load_number_to_EAX_hex PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	
	sub esp, 12 ; rezerwacja tablicy na znaki HEX poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pamiêci
	
	push dword PTR 9 ; max iloœæ znaków wczytyw. liczby to 8 + znak nowej linii
	push esi ; adres obszaru pamiêci
	push dword PTR 0
	call __read
	add esp, 12 ; usuniêcie parametrów ze stosu
	mov eax, 0 ; zerowanie EAX, bo znajduje sie tu liczba wprowadzonych znakow

	take_next_sign:
		mov dl, [esi] ;pobranie kolejnego znaku
		inc esi
		cmp dl, 0Ah ;porownanie do znaku nowej linii
		je exit ;jelsi byl enter, przejdz do epilogu

		cmp dl, '0'
		jb take_next_sign ; inny znak jest ignorowany
		cmp dl, '9'
		ja check_capital_letters ;jesli to znak to nie cyfra przejdz do sprawdzania cyfr
		sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry

		shift:
			shl eax, 4 ; przesuniêcie logiczne w lewo o 4 bity
			or al, dl ; dopisanie utworzonego kodu na 4 ostatnie bity rejestru EAX
			jmp take_next_sign ; skok na pocz¹tek pêtli konwersji


		check_capital_letters:
			cmp dl, 'A'
			jb take_next_sign ; inny znak jest ignorowany
			cmp dl, 'F'
			ja check_small_letter ;jesli to nie wielka litera, sprawdz male
			sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
			jmp shift

		check_small_letter:
			cmp dl, 'a'
			jb take_next_sign ; inny znak jest ignorowany
			cmp dl, 'a'
			ja take_next_sign ; inny znak jest ignorowany
			sub dl, 'a' - 10 ; wyznaczenie kodu binarnego
			jmp shift
			

	exit:
	add esp, 12 ;usuniecie tablicy lokalnej

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret

_load_number_to_EAX_hex ENDP

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

	;entry text displaying
	push entry_text_len
	push OFFSET entry_text
	push 1
	call __write
	add esp, 12

	call _load_number_to_EAX_hex
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