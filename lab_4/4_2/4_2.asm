.686
.model flat

.code
_additive_inverse PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov eax, [ebp+8]
	mov ebx, [eax]
	neg ebx
	mov [eax], ebx

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_additive_inverse ENDP
END