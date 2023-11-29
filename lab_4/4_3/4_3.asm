.686
.model flat

.code
_minus_one PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov eax, [ebp+8]
	mov ebx, [eax]
	mov ecx, [ebx]
	dec ecx
	mov [ebx], ecx
	mov [eax], ebx


	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_minus_one ENDP
END