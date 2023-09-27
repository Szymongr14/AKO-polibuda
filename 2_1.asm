;default encoding in VS2019 console is LATIN2
;Hexadecimal numbers must always start with a decimal digit (0–9)

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main


.data
    tekst db 10, 'Nazywam sie Szymon Groszkowski ' , 10
    db 'M',0A2h,'j pierwszy 32-bitowy program '
    db 'asemblerowy dzia',88h,'a, ju',0BEh,' poprawnie!', 10

    tekst_len equ $ - tekst ; calculates the length of the tekst variable by 
    ;subtracting the address of the tekst variable from the current address ($).

.code
_main:
    mov ecx, tekst_len ; liczba znaków wyœwietlanego tekstu
        ; zapisanie adresu zmiennej "tekst" w rejestrze eax
    push ecx ; liczba znaków wyœwietlanego tekstu
    push dword PTR OFFSET tekst ; po³o¿enie obszaru ze znakami
    push dword PTR 1 ; uchwyt urz¹dzenia wyjœciowego
    call __write ; wyœwietlenie znaków
    add esp, 12 ; usuniêcie parametrów ze stosu
    
    ; zakoñczenie wykonywania programu
    push dword PTR 0 ; kod powrotu programu
    call _ExitProcess@4
END
