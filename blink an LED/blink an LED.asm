section .text
    global _start

_start:
    ; Initialize GPIO pin as output
    mov eax, 0xB202  ; GPIO control register address
    mov ebx, 1       ; GPIO pin number (e.g., pin 0)
    mov ecx, 1       ; Set GPIO pin as output
    shl ecx, bl      ; Shift the output bit to the desired pin
    or [eax], ecx    ; Set the pin as output

loop:
    ; Turn on the LED
    mov eax, 0xB201  ; GPIO output register address
    mov ebx, 1       ; GPIO pin number (e.g., pin 0)
    shl ebx, 2       ; Calculate the offset for the desired pin
    or [eax], ebx    ; Set the pin high (LED on)

    ; Delay for a certain period (e.g., 1 second)
    mov ecx, 0       ; Counter for delay loop
delay_loop:
    cmp ecx, 1000000 ; Adjust this value to control the delay duration
    jge toggle_led   ; If delay is complete, go to toggle_led
    inc ecx          ; Increment the delay counter
    jmp delay_loop   ; Loop back for next iteration

toggle_led:
    ; Turn off the LED
    mov eax, 0xB201  ; GPIO output register address
    mov ebx, 1       ; GPIO pin number (e.g., pin 0)
    shl ebx, 2       ; Calculate the offset for the desired pin
    xor ebx, 0xFFFF  ; Flip the pin value (LED off)
    and [eax], ebx   ; Set the pin low (LED off)

    ; Delay for a certain period (e.g., 1 second)
    mov ecx, 0       ; Counter for delay loop
delay_loop_off:
    cmp ecx, 1000000 ; Adjust this value to control the delay duration
    jge loop         ; If delay is complete, go back to loop
    inc ecx          ; Increment the delay counter
    jmp delay_loop_off ; Loop back for next iteration

    ; Exit the program
    mov eax, 1       ; sys_exit system call
    xor ebx, ebx     ; Exit status code
    int 0x80         ; Call kernel
