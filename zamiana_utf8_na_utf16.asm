.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data
bufor       db    0F0h,9Fh,98h,84h, 50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H

            db    0F0H, 9FH, 9AH, 82H   ; parowóz

            db    20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H

            db    0E2H, 80H, 93H ; półpauza

            db    20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H

            db    0F0H,  9FH,  9AH,  8CH ; autobus
buffor_len equ 48 ;stala ilosc bajtow w tekscie

tekst dw 'e', 'l', 'o',0


wynik dw  70 dup (0) ;deklaracja miejsca w pamieci na przekonwertowany tekst


.code
	_main:

    mov esi, 0 ;indeks bufor esi=source index  
    mov edi, 0 ;indkes wynik edi = destination index

    take_next_character:
        mov al, bufor[esi] ;wpisanie do AL bajtu z bufora o indeksie ESI
        inc esi ;inkrementacja indeksu
        cmp al, 07Fh ;porownanie wartosci bajtu do wartosci granicznej znakow zapisanych na 1 bajcie
        ja two_bytes_character;jesli jest wieksza, przejdz do znakow zapisanych na wiekszej ilosci bajtow
        mov ah, 0 ;rozszerzenie do ax
        mov wynik[2*edi], ax ;zapisanie kodu znaku do wynik
        inc edi ; inkrementacja indeksu wynik

        cmp esi, buffor_len ;sprawdzenie czy pobrano juz wszystkie bajty w buforze
        jne take_next_character;przeskoczenie do poczatku iterowania po bajtach w buforze 
        je print


        two_bytes_character:
            mov ah,0 ;rozszerzenie do ax obecnie sprawdzanego bajtu
            cmp ax, 0DFh ; wartosc graniczna dwu bajtowych wartosci
            ja three_byte_character ;jesli jest wieksza sprawdz znaki zapisane na 3 bajtach
            sub ax, 0C0h ;wyodrebnienie potrzebnych bitow
            shl ax,6 ;przesun bity 6 razy aby wyrownac w celu maskowania bitow

            mov bl, bufor[esi] ;pobranie kolejnego bajtu
            inc esi; inkrementacja indeksu bufor
            mov bh, 0 ; rozszerzeni do bx
            sub bx, 80h; pobranie potrzebnych bitow z drugiego bajtu, czyli odjecie wartosci stalej w drugim bajcie utf-8

            or ax, bx ;maskowanie bitow, w celu uzyskania wartosci kodowej UNICODE
            mov wynik[2*edi], ax ; zapisanie wartosci kodowej do wynik
            inc edi ;inkrementacj indeksu wynik
            
            cmp esi, buffor_len ;sprawdzenie czy pobrano juz wszystkie bajty w buforze
            jne take_next_character;przeskoczenie do poczatku iterowania po bajtach w buforze 
            je print
                    


        
        three_byte_character:
            mov ah,0 ;rozszerzenie do ax
            cmp ax, 0EFh ;porownanie z wartoscia graniczna
            ja four_byte_character;jesli wartosc jest wieksza sprawdz 4-bajtowe znaki
            sub ax, 0E0h ;wyodrebnij znaczace bity
            shl ax, 12 ;przesun bity 12 razy w lewo

            mov bl, bufor[esi] ;pobranie kolejnego bajtu
            inc esi; inkrementacja indeksu bufor
            mov bh, 0 ; rozszerzeni do bx
            sub bx, 80h; pobranie potrzebnych bitow z drugiego bajtu
            shl bx, 6;przesun bity 6 razy w lewo

            mov dl, bufor[esi] ;pobranie 3 bajtu
            inc esi;inkrementacja indkesu bufor
            mov dh, 0 ;rozszerzenie do dx
            sub dx, 80h ;wyodrebnienie potrzebnych bitow

            or ax, bx ;przepisanie bitow do rejestru ax z bx
            or ax, dx ;przepisanie bitow do rejestru ax z dx

            mov wynik[2*edi], ax ;zapisanie znaku do wynik
            inc edi ;inkrementacja indkesu wynik
            
            cmp esi, buffor_len ;sprawdzenie czy pobrano juz wszystkie bajty w buforze
            jne take_next_character;przeskoczenie do poczatku iterowania po bajtach w buforze 
            je print

        four_byte_character:
            mov ah, 0 ;rozszerzenie do ax
            sub ax, 0F0h ;wyodrebnij znaczace bity
            BSWAP eax ;odwrocenie bitow w celu wyzerowania starszej czesci eax
            mov ax, 0 ;wyzerowanie odwroconej starszej czesci eax
            BSWAP eax ;odwrocenie do poprawnej kolejnosci
            shl eax, 18;przesun bity 18 razy w lewo

            mov bl, bufor[esi] ;pobranie 2 bajtu
            inc esi; inkrementacja indeksu bufor
            mov bh, 0 ; rozszerzeni do bx
            sub bx, 80h; pobranie potrzebnych bitow z drugiego bajtu
            BSWAP ebx ;odwrocenie bitow w celu wyzerowania starszej czesci ebx
            mov bx, 0 ;wyzerowanie odwroconej starszej czesci ebx
            BSWAP ebx ;odwrocenie do poprawnej kolejnosci
            shl ebx, 12;przesun bity 12 razy w lewo

            mov dl, bufor[esi] ;pobranie 3 bajtu
            inc esi; inkrementacja indeksu bufor
            mov dh, 0 ; rozszerzeni do bx
            sub dx, 80h; pobranie potrzebnych bitow z drugiego bajtu
            BSWAP edx ;odwrocenie bitow w celu wyzerowania starszej czesci ebx
            mov dx, 0 ;wyzerowanie odwroconej starszej czesci ebx
            BSWAP edx ;odwrocenie do poprawnej kolejnosci
            shl edx, 6;przesun bity 6 razy w lewo

            or eax, ebx ;przepisanie bitow do eax z ebx
            or eax, edx;przepisanie bitow do eax z edx

            mov bl, bufor[esi] ;pobranie 4 bajtu
            inc esi; inkrementacja indeksu bufor
            mov bh, 0 ; rozszerzeni do bx
            sub bx, 80h; pobranie potrzebnych bitow z drugiego bajtu
            BSWAP ebx ;odwrocenie bitow w celu wyzerowania starszej czesci ebx
            mov bx, 0 ;wyzerowanie odwroconej starszej czesci ebx
            BSWAP ebx ;odwrocenie do poprawnej kolejnosci
            or eax, ebx ;przepisanie bitow do eax z ebx

            ;zamiana UNICODE na utf-16
            sub eax, 10000h ;pomniejszenie kodu unicode 
            mov ebx, eax ;zrobienie kopii eax
            shr ebx, 10 ;wyodrebnienie 10 najstarszych bitow
            add ebx, 0D800h ;dodanie przedrostka starszego bajtu w utf-16 (110110XXXXXXXXXX)
            
            and eax, 03FFh ;wyizolowanie 10 najmlodszych bitow w eax (3FFh to 10 jedynek z przodu i reszta zer)
            add eax, 0DC00h ;dodanie przedrostka mlodszego bajtu w utf-16 (110111XXXXXXXXXX)

            mov wynik[2*edi], bx ;zapisanie do wynik starszej czesci utf-16
            inc edi ;inkrementacj indeksu wynik
            mov wynik[2*edi], ax ;zapisanie do wynik mlodszej  czesci utf-16
            inc edi ;inkrementacja indkesu wynik

            cmp esi, buffor_len ;sprawdzenie czy pobrano juz wszystkie bajty w buforze
            jne take_next_character;przeskoczenie do poczatku iterowania po bajtach w buforze 
            je print
            
        

        print:
            mov wynik[2*edi], 0 ;zakonczenie wypisanego tesktu '0'
            push 0 ; stala MB_OK
	        push OFFSET tekst
	        push OFFSET wynik; adres obszaru zawierajšcego tekst
	        push 0 ; NULL
	        call _MessageBoxW@16


	push 0
	call _ExitProcess@4 ; zakończenie programu
END