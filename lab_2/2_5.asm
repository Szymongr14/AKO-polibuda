; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main
.data
	tekst_pocz db 10, 'Prosz',0A9h,' napisa',86h,' jaki',98h,' tekst '
	db 'i nacisn',0A5h,86h,' Enter: ', 0
	koniec_t db ?

	magazyn db 80 dup (?)
	liczba_znakow dd ?

.code
	_main:
		; wy�wietlenie tekstu informacyjnego
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz);to samo co text_len: equ $-text
		push ecx ;dlugosc tekstu
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz�dzenia (tu: ekran - nr 1)
		call __write ; wy�wietlenie tekstu pocz�tkowego
		add esp, 12 ; usuniecie parametr�w ze stosu
		
		
		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znak�w
		push OFFSET magazyn
		push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znak�w z klawiatury
		add esp, 12 ; usuniecie parametr�w ze stosu
		; kody ASCII napisanego tekstu zosta�y wprowadzone do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczb� wprowadzonych znak�w
		mov liczba_znakow, eax
		; rejestr ECX pe�ni rol� licznika obieg�w p�tli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz�tkowy
		
		ptl:
			mov dl, magazyn[ebx] ; pobranie kolejnego znaku
			
			check_a:
				cmp dl, 0A5h
				jne check_c
				sub dl, 1
				mov magazyn[ebx], dl
				jmp dalej

			check_c:
				cmp dl, 86h
				jne check_e
				add dl, 9
				mov magazyn[ebx], dl
				jmp dalej

			check_e:
				cmp dl, 0A9h
				jne check_not_special_character
				sub dl, 1
				mov magazyn[ebx], dl
				jmp dalej

			;other polish special characters, they don't have pattern like in ASCII encoding

			check_not_special_character:
				cmp dl, 'a'
				jb dalej ; skok, gdy znak nie wymaga zamiany
				cmp dl, 'z'
				ja dalej ; skok, gdy znak nie wymaga zamiany
				sub dl, 20H ; zamiana na wielkie litery
				mov magazyn[ebx], dl ; odes�anie znaku do pami�ci

			dalej: 
			inc ebx ; inkrementacja indeksu
			dec ecx
		jnz ptl
		
		
		; wy�wietlenie przekszta�conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wy�wietlenie przekszta�conego tekstu
		add esp, 12 ; usuniecie parametr�w ze stosu


		push 0
		call _ExitProcess@4 ; zako�czenie programu
END