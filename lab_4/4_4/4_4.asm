.686
.model flat

.code
_set_max_to_the_end PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov eax, [ebp+8] ;loading address of an array into eax
	mov ecx, [ebp+12] ;loading size of an array
	dec ecx

	compare_next_pair:
		mov ebx, [eax]
		cmp ebx, [eax+4]
		jle dont_swap
		mov edx, [eax+4]
		mov [eax+4], ebx
		mov [eax], edx
		cmp ecx, 0
		je quit
		add eax, 4
		loop compare_next_pair

	dont_swap:
		add eax, 4
		cmp ecx, 0
		je quit
		loop compare_next_pair

quit:
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_set_max_to_the_end ENDP
END