.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
buffer_out db 10 dup (?)
buffer_out_length equ 11

array dw 50 dup (?)
array_length equ 51


.code
_display_eax PROC
	pusha; push na stos wszystkich wartosci rejestrrow

	mov ebx, 10; ustawienie dzielnika na 10
	mov buffer_out[buffer_out_length-1], 0Ah ; wstawienie znaku nowej lini na ostatni indkes buffor_out
	mov edi, buffer_out_length-2 ; ustawienie indkesu odpowiedzialnego za buffer_out na przedostatni indeks

	divide:
		mov edx, 0 ; zerowanie starszej czêœci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII (30h = 0, 31h = 1, ...)
		mov znaki [edi], dl; zapisanie cyfry w kodzie ASCII
		dec edi ;zmniejszenie indeksu buffer_out
		cmp eax, 0 ; sprawdzenie czy iloraz = 0, czyli liczba, któr¹ aktualnie dzielisz
		jne divide ;jesli iloraz nie jest zerem, dziel dalej
	

	; wype³nienie pozosta³ych bajtów '0'
	fill_next_values:
		mov buffer_out[edi], 0
		dec edi
		cmp edi, -1
		jne fill_next_values

	;wyswietlenie liczby
	push buffer_out_length
	push OFFSET buffer_out
	push 1
	call __write
	add esp, 12
	
	popa
	ret

_display_eax ENDP



_main PROC
	mov edi, 0;set index of array to 0
	mov array[edi], 1
	add edi, 2
	mov ecx, 1;set counter to 0

	fill_next:
		mov ax, array[edi-2]
		add ax, cx
		mov array[edi], ax
		add edi, 2
		
		inc ecx
		cmp ecx, array_length
		jne fill_next


	mov ecx ,0
	take_next_number:
		mov eax, 0
		mov ax, array[2*ecx]
		call _display_eax

		inc ecx
		cmp ecx, array_length
		jne take_next_number
		

	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END