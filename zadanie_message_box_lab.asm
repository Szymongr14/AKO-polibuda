.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
public _main


.data
    tekst db 'Lubisz AKO?',0
    tytul db 'messageBox',0



.code
_main:

    loop_message_box:
        push 4
        push OFFSET tytul
        push OFFSET tekst
        push 0
        call _MessageBoxA@16
    cmp eax,6
    jnz loop_message_box

    
    ; zakoñczenie wykonywania programu
    push dword PTR 0 ; kod powrotu programu
    call _ExitProcess@4
END