.686
.model flat
public _tablica_nieparzystych
extern _calloc: proc
.code
_tablica_nieparzystych PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov esi, [ebp+8] ;adres tablicy
	mov ecx, [ebp+12] ;adres rozmiaru tablicy
	mov ecx, [ecx]
	mov ebx, 0

	take_next_number:
		mov eax, [esi]
		add esi, 4
		BT eax, 0
		jnc not_even
		inc ebx
		not_even:
	loop take_next_number

	push ebx
	call _calloc
	add esp, 4
	push eax

	mov esi, [ebp+8]
	mov ecx, [ebp+12] ;adres rozmiaru tablicy
	mov ecx, [ecx]
	take_next_number1:
		mov edx, [esi]
		add esi, 4
		BT edx, 0
		jnc not_even1
		mov [eax], edx
		add eax, 4
		not_even1:
	loop take_next_number1

	pop eax
	mov ecx, [ebp+12]
	mov [ecx], ebx

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_tablica_nieparzystych ENDP
END