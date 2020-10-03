format PE console

entry start
include 'win32a.inc'

section '.data' data readable writable
    strA db 'Enter A: ',0
    strB db 'Enter B: ',0
    emptyStr db '%d',0
    resStr db 'GCD of %d and %d = %d',0
    
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
        
        mov eax, [A]
        mov ebx, [B]
        lp:
            cmp eax,ebx
            jg aBigger
            jl bBigger
            jmp finish


            aBigger:
                sub eax, ebx
                jmp lp

            
            bBigger:
                sub ebx, eax
                jmp lp

       finish:

         push eax
         push [B]
         push [A]
         push resStr
         call [printf]

         call [getch]

         push NULL
         call [ExitProcess]