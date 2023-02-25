org 0x7c00
jmp start

%macro cmpv 1
    mov si, string
    mov bl, %1
    call count
%endmacro

string: db "hello world", 0x0d, 0x0a, 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov si, string
    call print

    xor cx, cx
    cmpv 0x61
    cmpv 0x65
    cmpv 0x69
    cmpv 0x6f
    cmpv 0x75

    call print_Num

end:
    jmp $

print:
.loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0e
    int 10h
    jmp .loop
.done:
    ret

count:
.loop:
    lodsb
    cmp al, 0
    je .done
    cmp al, bl
    jne .loop
    inc cx
    jmp .loop
.done:
    ret

print_Num:
    mov bx, 10
    mov ax, cx
    xor cx, cx
.loop1:
    mov dx, 0
    div bx
    add dx, 48
    push dx
    inc cx
    cmp ax, 0
    jne .loop1
.loop2:
    pop ax
    mov ah, 0x0e
    int 10h
    dec cx
    cmp cx, 0
    je .done
    jmp .loop2
.done:
    ret

times 510-($-$$) db 0
dw 0xaa55