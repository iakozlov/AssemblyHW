format PE console


entry start
include 'win32a.inc'

section '.data' data readable writable
    strA db 'Enter your name: ', 0
    emptyStr db '%s',0
    welcomeStr db 'Hello, %s', 0
    
    A rd 2
    
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
        call [scanf]

        push A
        push welcomeStr
        call [printf]

        call [getch]

        push NULL
        call [ExitProcess]
