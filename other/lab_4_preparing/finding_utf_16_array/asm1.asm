.686
.model flat
public _find_element
.code
_find_element PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov esi, [ebp+8]
	mov ebx, [ebp+12]
	mov ecx, [ebp+16]
	mov eax, 0

	take_next_index:
		mov dx, [esi]
		add esi, 2
		movzx edx, dx
		cmp edx, ebx
		jne not_equal
		inc eax
		mov edi, esi

		not_equal:
	loop take_next_index
	mov [ebp+8], edi

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_find_element ENDP


END