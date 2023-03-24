    section .data
    CONST3  dq 3.0

    section .text
    global cone_volume

    clone_volume:
    push ebp
    mov ebp, esp

    finit

    fldpi               ;; Pi em st0
    fld dword[ebp+8]    ;; R em st0 e Pi em st1
    fmul st0, st0       ;; R² em st0 e Pi em st1
    fmulp st1, st0      ;; Pi*R² em st0
    fld dword[ebp+12]   ;; H em st0 e Pi*R² em st1
    fmulp st1, st0      ;; Pi*H*R² em st0
    fdiv qword[CONST3]  ;; Pi*H*R²/3 em st0

    mov esp, ebp
    pop ebp

    ret
