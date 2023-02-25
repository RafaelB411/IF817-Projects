org 0x7c00
jmp start

string: db "placeholder", 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov di, 0x100 ;; endereço 0x100 => interrupção 40h
    mov word[di], print_string
    mov word [di+2], 0

    mov di, string
    call get_string

    push string
    int 40h

end:
    jmp $

print_string:
    push bp
    mov bp, sp
    mov si, [bp+8]
.loop_print:
    lodsb
    cmp al, 0
    je .end_print
    call put_char
    jmp .loop_print
.end_print:
    pop bp
ret 2

get_string:
    xor cx, cx
.loop_get:
    call get_char
    cmp al, 0x08
    je .backspace
    cmp al, 0x0d
    je .done
    cmp cl, 50
    je .done
    stosb
    inc cl
    call put_char
    jmp .loop_get
.backspace:
    cmp cl, 0
    je .loop_get
    dec di
    dec cl
    mov byte[di], 0
    call del_char
    jmp .loop_get
.done:
    mov ax, 0
    stosb
    call end_l
ret

put_char:
    mov ah, 0x0e
    int 10h
ret

get_char:
    mov ah, 0x00
    int 16h
ret

del_char:
    mov al, 0x08
    call put_char
    mov al, ' '
    call put_char
    mov al, 0x08
    call put_char
ret

end_l:
    mov al, 0x0a
    call put_char
    mov al, 0x0d
    call put_char
ret

times 510-($-$$) db 0
dw 0xaa55