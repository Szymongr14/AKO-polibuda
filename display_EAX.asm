.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main

.data
    buffer db 12 dup (?), 0  ; Buffer to hold the ASCII representation of the number and null-terminated string

.code

_main:
    ; Initialize EAX with the value you want to print
    mov eax, 12345  ; Replace with the value you want to print

    ; Convert EAX to a string and store it in the buffer
    lea esi, buffer
    call itoa ; Call the itoa procedure to convert EAX to a string

    ; Reverse the string in the buffer
    lea edi, [esi + 11]  ; Point EDI to the last character in the buffer
    mov ecx, esi         ; Point ECX to the first character in the buffer
    ;call reverseString   ; Call a procedure to reverse the string

    ; Display the value in the buffer
    push dword PTR 12 ; Number of characters to display
    push dword PTR OFFSET buffer ; Address of the buffer
    push dword PTR 1 ; Device number (1 for console)
    call __write ; Call the __write function to display the string
    add esp, 12

    ; Exit the program
    push 0
    call _ExitProcess@4

itoa proc
    pusha
    xor ebx, ebx      ; Clear EBX (used as an index for the buffer)
    mov ecx, 10

reverseLoop:
    xor edx, edx      ; Clear EDX (used for digit extraction)
    div ecx
    add dl, '0'
    mov [esi + ebx], dl ; Store the character in the buffer
    inc ebx            ; Move to the next position in the buffer
    test eax, eax
    jnz reverseLoop

    ; Null-terminate the string
    mov byte ptr [esi + ebx], 0

    popa
    ret
itoa endp

reverseString proc
    pusha

    mov esi, ecx       ; Copy the source address (beginning of the string) to ESI
    mov edi, eax       ; Copy the destination address (end of the string) to EDI

    ; Calculate the length of the string (excluding the null terminator)
    xor ecx, ecx
    movzx edx, byte ptr [esi]  ; Load the first character
    cmp dl, 0
    je reverseDone  ; If the string is empty, we're done
calculateLengthLoop:
    inc ecx
    movzx edx, byte ptr [esi + ecx]  ; Load the next character
    cmp dl, 0
    jne calculateLengthLoop

    ; Set ECX to the last character index
    dec ecx

    cld                ; Clear the direction flag to move forward

reverseLoop:
    cmp esi, edi
    jae reverseDone   ; If we've reached or crossed the middle, we're done

    ; Swap characters at ESI and EDI
    lodsb              ; Load the character from ESI to AL
    stosb              ; Store the character from AL to EDI
    dec edi            ; Move EDI backward
    inc esi            ; Move ESI forward
    jmp reverseLoop

reverseDone:
    popa
    ret
reverseString endp

END
