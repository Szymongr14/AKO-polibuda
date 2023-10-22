; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
extern _MessageBoxA@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Prosz',0A9h,' napisa',86h,' jaki',98h,' tekst '
	db 'i nacisn',0A5h,86h,' Enter: ', 0
	koniec_t db ?

	tytul_message_box db "MessageBox",0


	magazyn db 80 dup (?)
	liczba_znakow dd ?

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
		
		ptl:
			mov dl, magazyn[ebx] ; pobranie kolejnego znaku
			

			;wersja na CP 1250
			check_a:
				cmp dl, 0A5h
				jne check_c
				sub dl, 0 ; wartosc malego a odpowiada wartosci duzego w cp1250
				mov magazyn[ebx], dl
				jmp dalej

			check_c:
				cmp dl, 86h
				jne check_e
				add dl, 40h
				mov magazyn[ebx], dl
				jmp dalej

			check_e:
				cmp dl, 0A9h
				jne check_l
				add dl, 21h
				mov magazyn[ebx], dl
				jmp dalej


			check_l:
				cmp dl, 88h
				jne check_n
				add dl, 1Bh
				mov magazyn[ebx],dl
				jmp dalej

			check_n:
				cmp dl, 0E4h
				jne check_o
				sub dl, 1
				mov magazyn[ebx], dl
				jmp dalej

			check_o:
				cmp dl, 0A2h
				jne check_s
				add dl, 3Eh
				mov magazyn[ebx], dl
				jmp dalej

			check_s:
				cmp dl, 98h
				jne check_z
				sub dl, 1
				mov magazyn[ebx], dl
				jmp dalej

			check_z: ;ź
				cmp dl, 0ABh
				jne check_zz
				sub dl, 1Eh
				mov magazyn[ebx], dl
				jmp dalej
			
			check_zz: ;ż
				cmp dl, 0BEh
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
				mov magazyn[ebx], dl ; odesłanie znaku do pamięci

			dalej: 
			inc ebx ; inkrementacja indeksu
			dec ecx
		jnz ptl
		
		;wyswietlenie tekstu w messageBox
		push 0
		push OFFSET tytul_message_box
		push OFFSET magazyn
		push 0
		call _MessageBoxA@16
		add esp, 12

		

		push 0
		call _ExitProcess@4 ; zakończenie programu
END