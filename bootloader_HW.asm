BITS 16  ; Set the code generation to 16-bit mode

start:
    ; Set up segment registers
    mov ax, 0x07C0
    add ax, 0x288
    mov ss, ax
    mov sp, 0x00
    mov ax, 0x07C0
    mov ds, ax

    ; Print "Hello, World!" message
    mov si, message
    call print_string

    ; Infinite loop
    jmp $

print_string:
    ; Print a null-terminated string pointed by SI register
    mov ah, 0x0E  ; BIOS teletype function
.repeat:
    lodsb  ; Load character from [DS:SI] into AL, increment SI
    cmp al, 0
    je .done
    int 0x10  ; Call BIOS interrupt
    jmp .repeat
.done:
    ret

message db 'Hello, World!', 0

times 510-($-$$) db 0  ; Fill remaining bytes with zeros
dw 0xAA55  ; Boot signature
