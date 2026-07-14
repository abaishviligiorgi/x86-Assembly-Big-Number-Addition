.686
.model flat, stdcall
includelib msvcrt.lib
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

extern _getch: proc
extern putchar: proc
extern printf: proc
extern scanf: proc

.data
x db "2343345353753783489343843589358",0 ; First large number as string
y db "894789798789798789798798798798798787987988",0 ; Second large number as string
sum_out db "Your number is: %s", 10 ,0 ; Output format string for printf
sum db 43 dup (0) ; Buffer to store the result string

.code
main proc
    push ebp ; Prologue: Save base pointer
    mov ebp, esp
    sub esp, 20

    ; Initialize pointer for string X
    lea esi, [x] ; Get start address of X
    mov ebx, esi ; Save base address to check bounds later
    add esi, lengthof x ; Move to the end of string X
    dec esi ; Adjust pointer to the null terminator
    dec esi ; Point to the last numeric digit of X

    ; Initialize pointer for string Y
    lea edi, [y] ; Get start address of Y
    mov edx, edi ; Save base address to check bounds later
    add edi, lengthof y ; Move to the end of string Y
    dec edi ; Adjust pointer to the null terminator
    dec edi ; Point to the last numeric digit of Y

    ; Initialize pointer for the destination SUM buffer
    lea ecx, [sum] ; Get start address of SUM buffer
    add ecx, lengthof sum ; Move to the end of the buffer
    dec ecx ; Adjust pointer to the last byte
    dec ecx ; Point to the position for the last digit

conversion_loop:
    ; Safety check for ESI to prevent infinite loop
    cmp esi, 0 
    je skip_x
    jmp process_x

skip_x:
    mov al, 0 ; If X is fully processed (ESI is null), set digit value to 0
    jmp proceed_y

process_x:
    mov al, byte ptr[esi] ; Fetch ASCII character from X
    sub al, 030h ; Convert ASCII char to actual numeric digit ('0' -> 0)
    dec esi ; Move pointer left to the next digit
    cmp esi, ebx ; Check if we passed the beginning of string X
    jnl proceed_y
    mov esi, 0 ; Clear pointer if all digits of X are processed

proceed_y:
    ; Safety check for EDI to prevent infinite loop
    cmp edi, 0 
    je skip_y
    jmp process_y

skip_y:
    mov bl, 0 ; If Y is fully processed (EDI is null), set digit value to 0
    jmp add_digits

process_y:
    push ebx ; Save EBX on stack to preserve base address register
    mov bl, byte ptr[edi] ; Fetch ASCII character from Y
    sub bl, 030h ; Convert ASCII char to actual numeric digit
    dec edi ; Move pointer left to the next digit
    
    add al, bl ; Add the two digits together
    cmp al, 9 ; Check if a carry is generated
    jle add_digits
    
    ; Carry handling logic
    sub al, 10 
    dec ecx ; Move to the next higher digit position (left)
    add byte ptr[ecx], 1 ; Add the carry to the next position
    inc ecx ; Move pointer back to current digit position

add_digits:
    pop ebx ; Restore EBX from stack
    add byte ptr[ecx], al ; Add current sum to the buffer (handles accumulated carry)
    
    ; Re-check carry after accumulation
    cmp al, 9 
    jle convert_ascii
    sub al, 10
    dec ecx
    add byte ptr[ecx], 1 
    inc ecx

convert_ascii:
    add byte ptr[ecx], 030h ; Convert numeric sum back to ASCII character
    dec ecx ; Move destination pointer left for the next iteration
    
    ; Check if we passed the beginning of string Y
    cmp edi, edx 
    jnl check_end
    mov edi, 0
    mov ebx, 0

check_end:
    ; Compare pointers to see if both strings are completely processed
    cmp esi, edi 
    jne conversion_loop

    ; Prepare for printing: Skip leading zeros in the result buffer
    mov eax, offset sum ; Start from the beginning of the sum buffer

find_first_digit:
    cmp byte ptr [eax], 0 ; Check for leading zeros or empty bytes
    jne print_result
    inc eax ; Move right to skip the zero
    jmp find_first_digit

print_result:
    push eax ; Push the address of the formatted result string
    push offset sum_out ; Push the format string
    call printf ; Print the result to the console
    add esp, 8 ; Clean up stack parameters

    ; Epilogue: Restore stack and frame pointers
    mov esp, ebp 
    pop ebp
    ret
main endp
end main
