; file for debug routines
; should commpiler_IF our include and use really...




; print hex value on screen
; gemini AI came up with this... 

PRINT_ADDR_HEX:
    LD HL, YOUR_MEMORY_ADDRESS ; Load the 16-bit address you want to print
                                    ; Replace YOUR_MEMORY_ADDRESS with the actual address

    ; Print the high byte (first two hex digits)
    LD A, H ; Get the high byte into A
    CALL PRINT_BYTE_HEX ; Print it

    ; Print the low byte (last two hex digits)
    LD A, L ; Get the low byte into A
    CALL PRINT_BYTE_HEX ; Print it

    RET ; Return from the subroutine

; --- Subroutine to print a single byte (A register) as two hex digits ---
PRINT_BYTE_HEX:
    PUSH AF ; Save A (original byte)
    SRL A ; Shift A right 4 times to get the high nibble into the low nibble position
    SRL A
    SRL A
    SRL A
    CALL PRINT_NIBBLE_HEX ; Print the high nibble
    POP AF ; Restore A
    AND #0F ; Mask A to get only the low nibble
    CALL PRINT_NIBBLE_HEX ; Print the low nibble
    RET

; --- Subroutine to print a single nibble (A register, 0-F) as a hex character ---
PRINT_NIBBLE_HEX:
    CP #0A ; Compare with 10 (decimal)
    JR C, IS_DIGIT ; If A < 10, it's a digit (0-9)
    ADD A, #07 ; If A >= 10, it's A-F, add 7 to convert (A=10+7=17, 'A' ASCII is 65, 17+48=65)
IS_DIGIT:
    ADD A, #30 ; Add #30 (ASCII for '0') to convert 0-9 to ASCII '0'-'9'
    PUSH AF ; Save A
    CALL #1601 ; ROM routine: PRINT_CHAR (prints char in A)
    POP AF ; Restore A
    RET

; --- Data ---
YOUR_MEMORY_ADDRESS:
    DEFW #1234 ; Example address: $1234 (replace with your desired address)
                        ; Or you can use a label:
                        ; LD HL, MY_DATA_START

MY_DATA_START:
    DEFB 0, 1, 2, 3 ; Some example data