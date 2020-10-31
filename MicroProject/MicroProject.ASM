;Variant 12
;BSE192
;Kozlov Ivan
format PE console
entry start
include 'win32a.inc'


section '.code' code readable executable

start:
   FINIT
   ;calculating the first item of this row
    FLD  [denominator]
    FADD[a]
    FSQRT
    FSTP [denominator]
    FLD[answer]
    FMUL qword[a]
    FDIV qword [denominator]
    FMUL qword[a]
    FST [answer]
    invoke printf,fmt_string,dword[answer], dword[answer+4];info to console
    FST qword [previous_ans]
    FSTP qword [answer]
    FLD[answer]
    FDIV[a]
    FSTP[answer]


    lp: ;loop with calculating PI
    ;calculating another item pf the row
    FLD  [denominator]
    FADD[a]
    FSQRT
    FSTP [denominator]
    FLD[answer]
    FMUL qword[a]
    FDIV qword [denominator]
    FMUL qword[a]
    FSTP qword [answer]
    FLD [answer]
    FSUB [previous_ans]
    ;calculating the precision
    FABS
    FST[prec]
    invoke printf, fmt_string,dword[answer], dword[answer+4];info to console
    invoke printf, prec_string,dword[prec], dword[prec+4]
    fcomp qword [const];comparing with the precision const
    fstsw ax;
    sahf
    jb endw

    FLD[answer]
    FST [previous_ans]
    FDIV[a]
    FSTP[answer]
    jmp lp


endw:
    ;calculating final precision and writing info to console
    FLDPI
    FSUB[answer]
    FABS
    FLDPI
    FDIVR ST0,ST1
    FSTP[prec]
    invoke printf,ans_string,dword[answer], dword[answer+4]
    invoke printf,prec_string,dword[prec], dword[prec+4]
    invoke getch
    invoke ExitProcess, 0

section '.data' data readable writable

    fmt_string db "my number = %lf", 10, 0;calculations string
    prec_string db "precision = %lf",10,0;precision string
    ans_string db 10,"FINAL ANSWER: %lf",10,0;answer string
    answer dq 1.000;answer
    prec dq 0.0;precision
    const dq 0.0005;precision const
    a dq 2.000;just const
    previous_ans dq ?;previous item
    denominator dq 0; row's denominator

section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
    include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           sprintf, 'sprintf',\
           scanf, 'scanf',\
           getch, '_getch'