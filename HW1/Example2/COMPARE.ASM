format PE console

entry start
include 'win32a.inc'

section '.data' data readable writable
    strA db 'Enter A: ',0
    strB db 'Enter B: ',0
    strOP db 'Enter operation: ',0
    emptyStr db '%d',0 
    biggerStr db 'Result: %d > %d',0
    equalStr db 'Result: %d = %d',0
    
    A dd ?
    B dd ?
    
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
        
        push strB
        call [printf]
        
        push B
        push emptyStr
        call[scanf]



        mov eax,[A]
        mov ebx,[B]
        cmp eax,ebx
        jg aBigger
        jl aSmaller
            push eax
            push ebx
            push equalStr
            call [printf]
            
            jmp finish
        aBigger:
            push ebx
            push eax
            push biggerStr
            call [printf]
            
            jmp finish
        aSmaller:
            push eax
            push ebx
            push biggerStr
            call [printf]

            jmp finish

            
        finish:
            call [getch]
        
            push NULL
            call [ExitProcess]