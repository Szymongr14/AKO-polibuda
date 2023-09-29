;program which print in console value stored in EAX register
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main
.data
	znaki db 80 dup (?)
	tekst db 'witam',10
	tekst_len equ ($ - tekst)

.code
		display_EAX PROC
			mov esi, 10 ; indeks w tablicy 'znaki', zaczynamy od 10 bo EAX zmiesci max 10 cyfrow� warto�c dziesi�tn� = 2^32
			mov ebx, 10 ; dzielnik r�wny 10
			konwersja:
				mov edx, 0 ; zerowanie starszej cz�ci dzielnej
				div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
				add dl, 30H ; zamiana reszty z dzielenia na kod ASCII (30h = 0, 31h = 1, ...)
				mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
				dec esi ; zmniejszenie indeksu
				cmp eax, 0 ; sprawdzenie czy iloraz = 0, czyli liczba, kt�r� aktualnie dzielisz
			jne konwersja ; skok, gdy iloraz niezerowy
		
			; wype�nienie pozosta�ych bajt�w '0'
			wypeln:
				cmp esi, 0
				jz wyswietl ; skok, gdy ESI = 0
				mov byte PTR znaki [esi], 0h ; 
				dec esi ; zmniejszenie indeksu
			jmp wypeln
		
		
			wyswietl:
			;mov byte PTR znaki [0], 0AH ; kod nowego wiersza
			; wy�wietlenie cyfr na ekranie
			push dword PTR 12 ; liczba wy�wietlanych znak�w
			push dword PTR OFFSET znaki ; adres wy�w. obszaru
			push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
			call __write ; wy�wietlenie liczby na ekranie
			add esp, 12 ; usuni�cie parametr�w ze stosu
			
			ret

		display_EAX ENDP
	
	_main:
		mov eax, 5804
		call display_EAX


		push 0
		call _ExitProcess@4 ; zako?czenie programu
END