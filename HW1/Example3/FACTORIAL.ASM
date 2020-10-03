format PE console

entry start
include 'win32a.inc'

section '.data' data readable writable
    strA db 'Enter A: ',0
    resStr db '%d! = %d',0
    emptyStr db '%d',0
    
    A dd ?
    
    NULL = 0
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'
    import kernel,\
        ExitProcess, 'ExitProcess'
    import msvcrt,\
        printf, 'printf',\
        scanf, 'scanf',\
        getch, '_getch'
section '.code' code readable executable
    start:
        
        push strA
        call [printf]
        
        push A
        push emptyStr
        call[scanf]
        
        mov eax, 1
        mov ebx, [A]
        mov ecx,[A]
        mov edx, 0
        lp:
            imul eax, ebx
            sub ebx, 1
            add edx,1
            
            cmp edx,ecx
            jne lp
       push eax
       push [A]
       push resStr
       call [printf]
       jmp finish
            
        finish:
            call [getch]

            push NULL
            call [ExitProcess]