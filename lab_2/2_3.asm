; Przykład wywoływania funkcji MessageBoxA i MessageBoxW
;dla znaków specjalnych trzeba zastapic kodami UTF-16 i Win1250
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
	tytul_Unicode dw 'T','e','k','s','t',' ','w',' '
	dw 'f','o','r','m','a','c','i','e',' '
	dw 'U','T','F','-','1','6', 0
	
	tekst_Unicode dw 'K','a',17Ch,'d','y',' ','z','n','a','k',' '
	dw 'z','a','j','m','u','j','e',' '
	dw '1','6',' ','b','i','t',0F3h,'w', 0
	
	tytul_Win1250 db 'Tekst w standardzie Windows 1250', 0
	
	tekst_Win1250 db 'Ka',0BFh,'dy znak zajmuje 8 bit',0F3h,'w', 0

	tytul_Unicode_zadanie dw 'Z','n','a','k','i',' ', 'w',' ','u','n','i','c','o','d','e',0

	tekst_Unicode_zadanie dw 'T','o',' ','j','e','s','t',' '
	dw 0D83Dh,0DEEAh,' ','s','a','m','o','l','o','t',' ','i',' ','u','f','o',' '
	dw 0D83Dh, 0DEF8h

.code
	_main:
	push 0 ; stała MB_OK
	push OFFSET tytul_Win1250 ; adres obszaru zawierajšcego tytuł
	push OFFSET tekst_Win1250; adres obszaru zawierajšcego tekst
	push 0 ; NULL
	call _MessageBoxA@16
	

	push 0 ; stala MB_OK
	push OFFSET tytul_Unicode
	push OFFSET tekst_Unicode; adres obszaru zawierajšcego tekst
	push 0 ; NULL
	call _MessageBoxW@16

	push 0 ; stala MB_OK
	push OFFSET tytul_Unicode_zadanie
	push OFFSET tekst_Unicode_zadanie; adres obszaru zawierajšcego tekst
	push 0 ; NULL
	call _MessageBoxW@16
	
	
	push 0 ; kod powrotu programu
	call _ExitProcess@4
END