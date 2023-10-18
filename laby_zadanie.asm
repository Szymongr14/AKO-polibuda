; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
public _main
.data
	tekst_pocz db 10, 'Prosz',0A9h,' napisa',86h,' jaki',98h,' tekst '
	db 'i nacisn',0A5h,86h,' Enter: ', 0
	koniec_t db ?

	magazyn db 80 dup (?)
	liczba_znakow dd ?
	new_magazyn db 80 dup (?)

.code
	_main:
		; wyświetlenie tekstu informacyjnego
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz);to samo co text_len: equ $-text
		push ecx ;dlugosc tekstu
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urządzenia (tu: ekran - nr 1)
		call __write ; wyświetlenie tekstu początkowego
		add esp, 12 ; usuniecie parametrów ze stosu
		
		
		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znaków
		push OFFSET magazyn
		push 0 ; nr urządzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znaków z klawiatury
		add esp, 12 ; usuniecie parametrów ze stosu
		; kody ASCII napisanego tekstu zostały wprowadzone do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczbę wprowadzonych znaków
		mov liczba_znakow, eax
		; rejestr ECX pełni rolę licznika obiegów pętli
		mov ecx, eax
		mov ebx, 0 ; indeks początkowy
		mov esi, 0 ; indeks do new_magazyn
		
		ptl:

			mov dl, magazyn[ebx] ; pobranie kolejnego znaku

			check_slash:
				cmp dl, 2Fh
				je check_previous_sign
				jne check_a
			
			check_previous_sign:
				mov dl, byte PTR [magazyn+ebx-1]
				cmp dl, 2Fh
				jne add_4_spaces
				je skip
				skip: 
					dec ecx
					inc ebx
					jnz ptl


					

			add_4_spaces:
				mov dl, 9h
				mov [new_magazyn+esi], dl
				jmp dalej
				

			
			check_a:
				cmp dl, 0A5h
				jne check_c
				sub dl, 1
				mov new_magazyn[esi], dl
				jmp dalej

			check_c:
				cmp dl, 86h
				jne check_e
				add dl, 9
				mov new_magazyn[esi], dl
				jmp dalej

			check_e:
				cmp dl, 0A9h
				jne check_not_special_character
				sub dl, 1
				mov new_magazyn[esi], dl
				jmp dalej

			;other polish special characters, they don't have pattern like in ASCII encoding

			check_not_special_character:
				cmp dl, 'a'
				jb dalej ; skok, gdy znak nie wymaga zamiany
				cmp dl, 'z'
				ja dalej ; skok, gdy znak nie wymaga zamiany
				sub dl, 20H ; zamiana na wielkie litery
				mov new_magazyn[esi], dl ; odesłanie znaku do pamięci

			dalej: 
			inc ebx ; inkrementacja indeksu
			inc esi
			dec ecx
		jnz ptl
		
		
		; wyświetlenie przekształconego tekstu
		push liczba_znakow
		push OFFSET new_magazyn
		push 1
		call __write ; wyświetlenie przekształconego tekstu
		add esp, 12 ; usuniecie parametrów ze stosu


		push 0
		call _ExitProcess@4 ; zakończenie programu
END