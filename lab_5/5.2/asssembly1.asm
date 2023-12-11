;funkcja obliczajaca sume szeregu z lab5 
.686
.model flat
public _nowy_exp
.code
_nowy_exp PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov ecx, 1 ;ustawienie licznika na 1 i iterowanie do n-1
	sub esp, 4 ;rezerwacja obszaru na zmienna lokalna
	mov [ebp-4], dword PTR 0 ;przypisanie wartosci do pierwszego elementu szeregu

	count_next_value:
		finit ;czyszczenie rejestrow koprocesora
		
		;instrukcje odpowiadajace za obliczenie licznika
		fld dword ptr [ebp+8] ;zaladowanie x
		fld dword ptr [ebp+8] ;zaladowanie x
		push ecx
		count_x_to_power_ecx:
			cmp ecx, 1
			je exit_counting
			fmul st(0), st(1)
			dec ecx
		jmp count_x_to_power_ecx
		exit_counting:
		pop ecx

		;obliczenie mianownika, czyli silnia z ecx
		push ecx
		call _count_factorial
		add esp, 4

		;przeslanie wyniku obliczonej silni do koprocesora
		push eax ;wyslanie wyniku silni na stos
		fild dword PTR [esp] ;przeslanie wierzcholka na stos koporocesora
		add esp, 4 ;usuniecie eax z wierzcholka


		fdivp st(1), st(0)
		fld dword PTR [ebp-4] ;zaladowanie poprzednich elementow
		faddp
		fstp dword PTR [ebp-4] ;zapisanie sumy do zmiennej lokalnej

		cmp ecx, 19 ;19 bo pierwszy element szeregu to 1
		je exit
		inc ecx
	jmp count_next_value

	exit:
	;dodanie pierwszego elementu, czyli 1
	fld1
	fld dword PTR [ebp-4] ;zaladowanie obliczonej sumy
	faddp

	add esp, 4 ;usuniecie ze stosu zmiennych lokalnych
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_nowy_exp ENDP


_count_factorial PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx
	
	mov eax, 1
	mov ecx, 1

	multiply_next_number:
	mov ebx, ecx
	mul ebx
	cmp ecx, [ebp+8]
	je exit
	inc ecx
	jmp multiply_next_number

	exit:
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_count_factorial ENDP


END