.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxW@16 : PROC
public _main
.data
buffor_in db 80 dup (0)
buffor_out db 80 dup(0)

buffor_out_utf_16 dw 100 dup (0)

entry_text db 'Wpisz imie i nazwisko: ',0
text_len equ $-entry_text

special_small_polish_characters_latin2 db 0A5h,86h,0A9h,88h,0E4h,0A2h,98h,0ABh,0BEh
special_capital_polish_characters_latin2 db 0A4h,8Fh,0A8h,9Dh,0E3h,0E0h,97h,8Dh,0BDh
special_capital_polish_characters_unicode dw 104h,106h,118h,141h,143h,0D3h,15Ah,179h,17Bh
number_of_special_characters equ 9 ;stala
length_of_provided_text dd ?
unicode_title dw 'u', 't', 'f', '-', '1','6',0
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
	mov length_of_provided_text, eax

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
		cmp esi, length_of_provided_text;sprawdzenie czy doszlismy do konca nazwiska
		je rewrite_name ;jesli tak to przejdz do zapisywania imienia
	jmp rewrite_surname ;jesli nie to zapisuj dalej nazwisko

	rewrite_name:
		mov esi,0 ;przesuniecie indeksu buffor_in na poczatek, w celu wczytania imienia
		mov buffor_out[edi-1], 20h ;zapisanie spacji po nazwisku
		loop_character_in_name:
			mov al, buffor_in[esi] ;wczytanie znaku
			inc esi
			cmp al, 20h ;porownanie znaku ze spacja
			je convert ;jesli znak jest spacja to przejdz do wypisania
			mov buffor_out[edi], al ;jesli nie to zapisz go do buffor_out
			inc edi
		jmp loop_character_in_name 

	convert:
;wyzerowanie indeksow tablicowych
	mov esi, 0
	mov edi, 0
	take_next_character1:
		mov ecx, 0 ;zerowanie indeksu odpowiedzialnego za iterowanie po tablicy ze znakami specjalnymi
		mov al, buffor_out[esi] ;wczytanie kolejnego znaku
		inc esi
		cmp al, 'a'
		jb convert_to_utf_16 ;jesli wartosc znaku jest ponizej to przejdz od razu do zamiany na utf-16
		cmp al, 'z'
		ja check_next_special_character ;jesli jest powyzej sprawdz jeszcze czy nie jest to polski znak spejclany
		sub al, 20h ;zamiana malej literki na duza
		mov ah, 0 ;rozszerzenie do ax
		jmp convert_to_utf_16

		;sprawdzenie czy znak jest w tablicy ze znakami specjalnymi
		check_next_special_character:
			cmp al, special_small_polish_characters_latin2[ecx]
			je swap_special_character
			inc ecx
			cmp ecx, number_of_special_characters
			je convert_to_utf_16
			jmp check_next_special_character

		swap_special_character:
			;mov al, special_capital_polish_characters_latin2[2*ecx]
			mov ax, special_capital_polish_characters_unicode[2*ecx]
			jmp convert_to_utf_16

		
		
		convert_to_utf_16:
			mov buffor_out_utf_16[2*edi], ax ;zapisanie wielkiej litery do buffor_out
			inc edi

			cmp esi, length_of_provided_text
			je print ;jesli koniec tesktu to przejdz do wypisywania
			jmp take_next_character1 ;wczytanie kolejnego znaku

	print:
		mov buffor_out_utf_16[2*edi-2], 0
		push 0
		push OFFSET unicode_title
		push OFFSET buffor_out_utf_16
		push 0
		call _MessageBoxW@16
		add esp, 12

	push 0
	call _ExitProcess@4 ; zakoñczenie programu
END