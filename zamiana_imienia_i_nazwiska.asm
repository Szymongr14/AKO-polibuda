.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main
.data
buffor_in db 80 dup (0)
buffor_out db 80 dup(0)

entry_text db 'Wpisz imie i nazwisko: ',0
text_len equ $-entry_text

length_of_entered_text dd 0 ;miejsce w pamieci przygotowane do przechowania dlugosci wprowadzonego tesktu
.code
	_main:

	;wyswietlenie tesktu poczatkowego
	push text_len
	push OFFSET entry_text
	push 1
	call __write
	add esp, 12

	;wczytanie imienia i nazwiska
	push 80
	push OFFSET buffor_in
	push 0
	call __read
	add esp, 12
	mov length_of_entered_text, eax

	;zerowanie indkesow
	mov esi, 0 
	mov edi, 0

	take_next_character:
		mov al, buffor_in[esi] ;wczytanie znaku do rejestru al
		inc esi
		cmp al, 20h ;porownanie pobranego znaku ze spacja
		je rewrite_surname ;jesli wczytany znak to spacja to przejdz do zapisywania nazwiska
	jmp take_next_character ;jesli nie to wczytaj dalej


	rewrite_surname:
		mov al, buffor_in[esi] ;pobranie znaku nazwiska
		inc esi
		mov buffor_out[edi], al ;zapisanie go do buffor_out
		inc edi
		cmp esi, length_of_entered_text;sprawdzenie czy doszlismy do konca nazwiska
		je rewrite_name ;jesli tak to przejdz do zapisywania imienia
	jmp rewrite_surname ;jesli nie to zapisuj dalej nazwisko

	rewrite_name:
		mov esi,0 ;przesuniecie indeksu buffor_in na poczatek, w celu wczytania imienia
		mov buffor_out[edi-1], 20h ;zapisanie spacji po nazwisku
		loop_character_in_name:
			mov al, buffor_in[esi] ;wczytanie znaku
			inc esi
			cmp al, 20h ;porownanie znaku ze spacja
			je print ;jesli znak jest spacja to przejdz do wypisania
			mov buffor_out[edi], al ;jesli nie to zapisz go do buffor_out
			inc edi
		jmp loop_character_in_name 

	print:
		push eax
		push OFFSET buffor_out
		push 1
		call __write
		add esp, 12

	push 0
	call _ExitProcess@4 ; zakończenie programu
END