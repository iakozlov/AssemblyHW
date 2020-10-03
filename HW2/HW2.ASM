;---------------------------------------------------------------Variant 12--------------------------------------------------------------------------------------
;Array B is the array:
;made from elemts of array A, except last negative element

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        VecSize         db 'Array size:', 0
        ArrayB          db 'Array B:', 10, 0
        ArrayA          db 'Array A:', 10, 0
        IncorectSize    db ' = %d' , 10, 0
        VecElemIn       db '[%d]: ', 0
        VecElemOut      db '[%d] = %d', 10, 0
        ScanElem        db  '%d', 0


        counter         dd 0
        tmp_counter     dd 0
        vec_size        dd 0
        tmpStack        dd ?
        a               dd ?
        b               dd ?
        b_size          dd 0
        step            dd ?
        i               dd ?
        tmp             dd ?
        tmpB            dd ?
        vec             rd 100
        vecB            rd 100
        NULL = 0

section '.code' code readable executable

start:
        call init

getVectorFunc:
        call getVector
        call putVecA
printArrayB:
        call putVec


finish:
        call [getch]
        push NULL
        call [ExitProcess]
;--------------------------------------------------------------------------------------------
;FUNCTIONS
init:
        mov [tmpStack], esp
        mov eax,[b_size]
        mov eax, 0
        mov [b_size], eax
        PUSH VecSize
        call [printf]
        push vec_size
        push ScanElem
        call [scanf]
        mov eax, [vec_size]
        cmp eax, 0
        jg getVectorFunc
        push [vec_size]
        push IncorectSize
        call [printf]
        jmp finish
        mov esp, [tmpStack]
        ret

getVector:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vec

getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector
        mov [i], ecx
        push ecx
        push VecElemIn
        call [printf]

        push ebx        ;reading new element
        push ScanElem
        call [scanf]
        mov eax ,dword [ebx]
        mov [a], eax
        Compare:
               mov eax, [a]
               cmp eax, 0
               jl negElem
               jge next




        negElem:
        mov eax, [counter]
        inc eax
        mov [counter], eax
        mov eax,0
        mov eax, [a]
        cmp eax, 0 ;compare with 0, find negative element
        jl next

next:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop

endInputVector:
        mov esp, [tmpStack]

; reading vector A and looking for last negative element
; then we write elements to array B except last negative element
readVec:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vec

readVecLoop:
        mov [tmp], ebx

        cmp ecx, [vec_size]
        jge endReadVector
        mov [i], ecx

        mov eax ,dword [ebx]
        mov [a], eax
        cmp eax, 0
        jl  negElem2
        jg Write

        negElem2:    ;I use another counter to find last negative element
                mov eax, [tmp_counter]
                inc eax
                mov [tmp_counter], eax
                mov eax, [counter]
                cmp eax, [tmp_counter]
                je next2

        Write:    ;
            mov eax,[b_size]
            imul eax, 4
            mov [step], eax
            mov eax, dword [ebx]
            mov ebx, vecB
            add ebx, [step]
            mov [tmpB], ebx
            mov [ebx], eax
            mov ebx, [tmpB]
            add ebx, 4
            mov eax,[b_size]
            add eax, 1
            mov [b_size], eax


next2:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp readVecLoop

endReadVector:
        mov esp, [tmpStack]
        ret

putVec:
        mov [tmpStack], esp
        push ArrayB
        call [printf]
        xor ecx, ecx
        xor edx, edx
        mov edx, vecB
        putVecLoop:

        mov [tmpB], edx
        cmp ecx, [b_size]
        je finish
        mov [i], ecx

        push dword [edx]
        push ecx
        push VecElemOut
        call [printf]
        mov ecx, [i]
        inc ecx
        mov edx, [tmpB]
        add edx, 4
        jmp putVecLoop
        mov esp, [tmpStack]
        ret
putVecA:
        mov [tmpStack], esp
        push ArrayA
        call [printf]
        xor ecx, ecx
        xor edx, edx
        mov edx, vec
        putVecLoop2:

        mov [tmpB], edx
        cmp ecx, [vec_size]
        je printArrayB

        mov [i], ecx

        push dword [edx]
        push ecx
        push VecElemOut
        call [printf]
        mov ecx, [i]
        inc ecx
        mov edx, [tmpB]
        add edx, 4
        jmp putVecLoop2
        mov esp, [tmpStack]
        ret

;--------------------------------------------------------------------------------------------
section '.idata' import data readable
        library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'
