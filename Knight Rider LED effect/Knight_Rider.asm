section .text
    global _start

_start:
    ; Initialize GPIO pins as outputs
    mov eax, 0xB202  ; GPIO control register address
    mov ebx, 0xFF    ; GPIO pins to be used (e.g., pins 0-7)
    mov ecx, 1       ; Set GPIO pins as outputs
    shl ecx, bl      ; Shift the output bits to the desired pins
    or [eax], ecx    ; Set the pins as outputs

    ; Loop forever
loop:
    ; Light up LEDs in sequence
    mov eax, 0xB201  ; GPIO output register address
    mov ebx, 0x1     ; Initial LED mask (start with the first LED)
    mov ecx, 0x1     ; Direction flag (1 for forward, 0 for reverse)

led_loop:
    ; Set the LED state
    or [eax], ebx    ; Turn on the corresponding LED

    ; Delay for a certain period (e.g., 100ms)
    mov edx, 0       ; Counter for delay loop
delay_loop:
    cmp edx, 500000  ; Adjust this value to control the delay duration
    jge toggle_direction  ; If delay is complete, toggle direction
    inc edx          ; Increment the delay counter
    jmp delay_loop   ; Loop back for next iteration

toggle_direction:
    ; Reverse the LED sequence
    mov eax, 0xB201  ; GPIO output register address
    xor ebx, 0xFF    ; Toggle all LED bits
    shr ebx, 1       ; Shift the LED mask to the next position
    or [eax], ebx    ; Set the new LED mask

    ; Check if the sequence reached the end
    cmp ebx, 0x1     ; Check if the LED mask is back to the initial state
    je loop          ; If the sequence reached the end, go back to the beginning
    jne led_loop     ; If the sequence hasn't reached the end, continue

    ; Exit the program
    mov eax, 1       ; sys_exit system call
    xor ebx, ebx     ; Exit status code
    int 0x80         ; Call kernel
