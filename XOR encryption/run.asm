section .data
    file_path db "file.txt", 0
    key db 0xAA   ; The encryption/decryption key

section .text
    global _start

_start:
    ; Open the file for reading/writing
    mov eax, 5       ; sys_open system call
    mov ebx, file_path
    mov ecx, 2       ; O_RDWR flag
    mov edx, 0644    ; File permissions
    int 0x80         ; Call kernel

    ; Check for file open error
    cmp eax, -1
    je error_exit

    ; Read file content
    mov ebx, eax     ; File descriptor
    mov eax, 3       ; sys_read system call
    mov ecx, buffer
    mov edx, buffer_size
    int 0x80         ; Call kernel

    ; Encrypt/decrypt the file content
    mov esi, buffer  ; Source buffer
    mov edi, esi     ; Destination buffer

    xor ecx, ecx     ; Loop counter

    xor_loop:
        xor byte [esi], key  ; XOR operation
        inc esi             ; Increment source pointer
        inc ecx             ; Increment loop counter
        cmp ecx, buffer_size
        jl xor_loop

    ; Write the modified content back to the file
    mov eax, 4       ; sys_write system call
    mov ecx, edi     ; Use the modified buffer as the source
    int 0x80         ; Call kernel

    ; Close the file
    mov eax, 6       ; sys_close system call
    int 0x80         ; Call kernel

    ; Exit the program
    mov eax, 1       ; sys_exit system call
    xor ebx, ebx     ; Exit status code
    int 0x80         ; Call kernel

error_exit:
    ; File open error occurred
    ; Handle the error and exit the program
    ; ...

