; program przyk³adowy (wersja 32-bitowa)
.686
.model flat
extern _ExitProcess@4 : PROC ;oddanie kontroli systemowi
extern __write : PROC ; wo?anie funkcji z C __write(uchwyt, adres tkestu, liczba znaków (rozmiar bufforu))

.data
	tekst db 10, 'Nazywam sie . . . ' , 10
	db 'Moj pierwszy 32-bitowy program '
	db 'asemblerowy dziala juz poprawnie!', 10

	tekst1 db "Witam", 10 ;tekst i new line sign

.code
	_main proc
		mov ecx, 85 ; liczba znaków wyœwietlanego tekstu
		mov ebx, 6; liczba znaków tekst1
		xor al,al ;zerowanie rejestru AL
		

		loop_start:
			push eax ;zapidanie wartosci eax na stosie, bo __write zmienia wartosci rejestrow
			push ebx ;rozmiar tekstu
			push dword ptr OFFSET tekst1 ;adres tekstu w pamieci
			push 1 ;uchwyt okna
			call __write
			add esp, 12 ;czyszczenie stosu
			pop eax ; przywracanie rejestru AL z przed funkcji __write

			inc al
			cmp al, 10
			jnz loop_start

		

	;	; wywo³anie funkcji ”write” z biblioteki jêzyka C
	; DisplayString:
	; 	push ecx ; liczba znaków wyœwietlanego tekstu
	; 	push dword PTR OFFSET tekst ; przes?anie na stos adresu zmiennej tekst
	; 	push dword PTR 1 ; przes?anie uchwytu, czyli 1
	; 	call __write ; funkcja __write "s?i?ga ze stosu parametry w odwrotnej kolejno?ci, 
	; 	;dlatego parametry przekazujemy w odwrotnej kolejno?ci"
	; 	add esp, 12 ; usuniêcie parametrów ze stosu, przesuniecie rejestru stosu o 12 bajtów bo 3*4 bajty
		
	; 	; zakoñczenie wykonywania programu
		push dword PTR 0 ; kod powrotu programu
		call _ExitProcess@4
	_main endp
END