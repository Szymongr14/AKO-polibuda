.686
.model flat
extern _ExitProcess@4 : PROC ;oddanie kontroli systemowi
extern __write : PROC ; wo?anie funkcji z C __write(uchwyt, adres tkestu, liczba znak�w (rozmiar bufforu))
public _main

.data
	tablica dd 50 dup (1) ;zarezerwuj 50*4 bajtow pamieci i uzupelnij je "1"
	buffer db 80 dup (?)

.code
		display_eax proc
			pusha
			mov esi, 10 ; indeks w tablicy 'buffer', zaczynamy od 10 bo EAX zmiesci max 10 cyfrow� warto�c dziesi�tn� = 2^32
			mov ebx, 10 ; dzielnik r�wny 10
			konwersja:
				mov edx, 0 ; zerowanie starszej cz�ci dzielnej
				div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
				add dl, 30H ; zamiana reszty z dzielenia na kod ASCII (30h = 0, 31h = 1, ...)
				mov buffer [esi], dl; zapisanie cyfry w kodzie ASCII
				dec esi ; zmniejszenie indeksu
				cmp eax, 0 ; sprawdzenie czy iloraz = 0, czyli liczba, kt�r� aktualnie dzielisz
			jne konwersja ; skok, gdy iloraz niezerowy
		
			; wype�nienie pozosta�ych bajt�w '0'
			wypeln: ;wypelnia zerami do buffer[1]
				cmp esi, 0
				jz wyswietl ; skok, gdy ESI = 0
				mov byte PTR buffer [esi],0; 
				dec esi ; zmniejszenie indeksu
			jmp wypeln
		
		
			wyswietl:
			mov byte PTR buffer [0], 0AH ; kod nowego wiersza
			
			; wy�wietlenie cyfr na ekranie
			push dword PTR 12 ; liczba wy�wietlanych znak�w
			push dword PTR OFFSET buffer ; adres wy�w. obszaru
			push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
			call __write ; wy�wietlenie liczby na ekranie
			add esp, 12 ; usuni�cie parametr�w ze stosu

			popa
			ret
		display_eax endp	
	
	
	
	_main:
		lea ebx, tablica
		mov ecx,1

		fill_array:;filling array of 50 values of sequence (i+1)
			mov eax, [tablica+4*ecx-4];
			add eax, ecx
			mov [tablica+4*ecx], eax

			inc ecx
			cmp ecx, 51
			jnz fill_array



		xor ecx,ecx;clearing ecx
		display_array:
			mov eax, [tablica+4*ecx]
			call display_eax

			inc ecx
			cmp ecx,50
		jnz display_array


		push 0 ; kod powrotu programu
		call _ExitProcess@4
END