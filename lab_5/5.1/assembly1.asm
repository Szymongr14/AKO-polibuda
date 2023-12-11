;funkcja obliczajaca srednia harmoniczna
.686
.model flat
public _srednia_harm
.code
_srednia_harm PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	sub esp, 4 ;inicjalizacja zmiennej lokalnej
	mov [ebp-4], dword PTR 1 ;zmienna lokalna = 1

	sub esp, 4 ;inicjacja zmiennej lokalnej
	mov [ebp-8], dword PTR 0 ;ustawienie zmiennej lokalnej na 0
	mov edx, 0 ;edx przechowuje mianownik


	mov esi, [ebp+8] ;pobranie adresu tablicy
	mov ecx, [ebp+12] ;pobranie rozmiaru tablicy

	finit
	add_next_value_denominator:
		fild dword PTR [ebp-4] ;zaladowanie 1
		fld dword PTR[esi] ;zaladowanie kolejnej wartosci z tablicy
		add esi, 4 ;zwiekszenie indkesu
		fdivp st(1), st(0) ;podzielenie 1/wartosc
		fld dword PTR [ebp-8]
		faddp
		fstp dword PTR [ebp-8]
	loop add_next_value_denominator

	fild dword PTR [ebp+12] ;zaladowanie n
	fld dword PTR [ebp-8] ;zaladowanie mianownika
	fdiv

	add esp, 8 ;usuniecie zmiennych lokalnych ze stosu
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_srednia_harm ENDP


END