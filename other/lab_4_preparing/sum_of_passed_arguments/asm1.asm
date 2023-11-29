.686
.model flat
public _sum_function
.code
_sum_function PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov esi, [ebp+8]
	mov ecx, [ebp+12]
	mov eax, 0

	add_number:
		add eax, [esi]
		add esi, 4
	loop add_number

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_sum_function ENDP
END