;default encoding in VS2019 console is CP 852
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
    mov ecx, tekst_len ; liczba znaków wyświetlanego tekstu
        ; zapisanie adresu zmiennej "tekst" w rejestrze eax
    push ecx ; liczba znaków wyświetlanego tekstu
    push dword PTR OFFSET tekst ; położenie obszaru ze znakami
    push dword PTR 1 ; uchwyt urządzenia wyjściowego
    call __write ; wyświetlenie znaków
    add esp, 12 ; usunięcie parametrów ze stosu
    
    ; zakończenie wykonywania programu
    push dword PTR 0 ; kod powrotu programu
    call _ExitProcess@4
END