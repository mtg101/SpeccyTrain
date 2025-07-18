; taken from https://github.com/breakintoprogram/lib-spectrum/blob/master/lib/output.z80


;
; Title:	ZX Spectrum Standard Output Routines
; Author:	Dean Belfield
; Created:	29/07/2011
; Last Updated:	08/02/2020
;
; Requires:
;
; Modinfo:
;
; 02/07/2012:	Added Pixel_Address_Down and Pixel_Address_Up routines
; 04/07/2012:	Moved Clear_Screen to Screen_Buffer
; 08/02/2010:	Added Print_BC
;		Moved Clear_Screen into here (originally in screen_buffer.z80)
;		All output routines refactored to use HL for screen address
;		Added Fill_Attr routine
;

; Simple clear-screen routine
; Uses LDIR to block clear memory
; A:  Colour to clear attribute block of memory with
;
Clear_Screen:		LD HL,16384			; Start address of screen bitmap
			LD DE,16385			; Address + 1
			LD BC,6144			; Length of bitmap memory to clear
			LD (HL),0			; Set the first byte to 0
			LDIR				; Copy this byte to the second, and so on
			LD BC,767			; Length of attribute memory, less one to clear
			LD (HL),A			; Set the first byte to A
			LDIR				; Copy this byte to the second, and so on
			RET

; Fill a box of the screen with a solid colour
;  A: The colour
; HL: Address in the attribute map
;  C: Width
;  B: Height
;
Fill_Attr:		LD DE,32
1:			PUSH HL	
			PUSH BC
2:			LD (HL), A
			INC L
			DEC C
			JR NZ, 2B
			POP BC
			POP HL
			ADD HL,DE
			DJNZ 1B
			RET

; Print String Data
; First two bytes of string contain X and Y char position, then the string
; Individual strings are terminated with 0xFE
; End of data is terminated with 0xFF
; IX: Address of string
;
Print_String:		LD L,(IX+0)			; Fetch the X coordinate
			INC IX				; Increase HL to the next memory location
			LD H,(IX+0)			; Fetch the Y coordinate
			INC IX				; Increase HL to the next memory location
			CALL Get_Char_Address		; Calculate the screen address (in DE)
Print_String_0:		LD A,(IX)			; Fetch the character to print
			INC IX				; Increase HL to the next character
			CP 0xFE				; Compare with 0xFE
			JR Z,Print_String		; If it is equal to 0xFE then loop back to print next string
			RET NC				; If it is greater or equal to (carry bit set) then
			CALL Print_Char			; Print the character
			INC L				; Go to the next screen address
			JR Print_String_0		; Loop back to print next character
			RET

; Get screen address
; H = Y character position
; L = X character position
; Returns address in HL
;
Get_Char_Address:	LD A,H
			AND %00000111
			RRA
			RRA
			RRA
			RRA
			OR L
			LD L,A
			LD A,H
			AND %00011000
			OR %01000000
			LD H,A
			RET				; Returns screen address in HL

; Move HL down one character line
;
Char_Address_Down:	LD A, L
			ADD A, 32
			LD L, A
			RET NC 
			LD A, H 
			ADD A, 8 
			LD H, A
			RET 

; Get screen address
; B = Y pixel position
; C = X pixel position
; Returns address in HL and pixel position within character in A
;
Get_Pixel_Address:	LD A,B				; Calculate Y2,Y1,Y0
			AND %00000111			; Mask out unwanted bits
			OR %01000000			; Set base address of screen
			LD H,A				; Store in H
			LD A,B				; Calculate Y7,Y6
			RRA				; Shift to position
			RRA
			RRA
			AND %00011000			; Mask out unwanted bits
			OR H				; OR with Y2,Y1,Y0
			LD H,A				; Store in H
			LD A,B				; Calculate Y5,Y4,Y3
			RLA				; Shift to position
			RLA
			AND %11100000			; Mask out unwanted bits
			LD L,A				; Store in L
			LD A,C				; Calculate X4,X3,X2,X1,X0
			RRA				; Shift into position
			RRA
			RRA
			AND %00011111			; Mask out unwanted bits
			OR L				; OR with Y5,Y4,Y3
			LD L,A				; Store in L
			LD A,C
			AND 7
			RET

; Move HL down one pixel line
;
Pixel_Address_Down:	INC H				; Go down onto the next pixel line
			LD A,H				; Check if we have gone onto next character boundary
			AND 7
			RET NZ				; No, so skip the next bit
			LD A,L				; Go onto the next character line
			ADD A,32
			LD L,A
			RET C				; Check if we have gone onto next third of screen
			LD A,H				; Yes, so go onto next third
			SUB 8
			LD H,A
			RET

; Move HL up one pixel line
;
Pixel_Address_Up:	DEC H				; Go up onto the next pixel line
			LD A,H				; Check if we have gone onto the next character boundary
			AND 7
			CP 7
			RET NZ
			LD A,L
			SUB 32
			LD L,A
			RET C
			LD A,H
			ADD A,8
			LD H,A
			RET

; Print a single BCD value
;  A: Character to print
; HL: Screen address to print character at
;
Print_BCD_8		LD A, (IX) : INC IX: CALL Print_BCD
Print_BCD_6		LD A, (IX) : INC IX: CALL Print_BCD
Print_BCD_4		LD A, (IX) : INC IX: CALL Print_BCD
Print_BCD_2		LD A, (IX) : INC IX
Print_BCD:		PUSH AF				; Store the value
			AND 0xF0			; Get the top nibble
			RRA				; Shift into bottom nibble
			RRA
			RRA
			RRA
			ADD A, '0'			; Add to ASCII '0'
			CALL Print_Char			; Print the character
			INC L				; Move right one space
			POP AF
			AND 0x0F			; Get the bottom nibble
			ADD A, '0'			; Add to ASCII '0'
			CALL Print_Char			; Print
			INC L				; Move right one space
			RET

; Print a single character out to an X/Y position
;  A: Character to print
;  C: X Coordinate
;  B: Y Coordinate
; DE: Address of character set
;
Print_Char_At:		PUSH AF
			CALL Get_Char_Address
			POP AF				; Fall through to Print_Char
;
; Print a single character out to a screen address
;  A:  Character to print
;  HL: Screen address to print character at
;  DE: Address of character set (if entering at Print_Char_UDG)
; No SM code here - needs to be re-enterent if called on interrupt
;
Print_Char:		LD DE, 0x3C00			; Address of character set in ROM
			PUSH HL
			LD B, 0				; Get index into character set
			LD C, A
			DUP 3
			SLA C
			RL B
			EDUP
			EX DE, HL
			ADD HL, BC 
			EX DE, HL	
			CALL Print_UDG8
			POP HL
			RET 	

; Print a UDG (Single Height)
; DE - Character data
; HL - Screen address
;
Print_UDG8:		LD B,8				; Loop counter
2:			LD A,(DE)			; Get the byte from the ROM into A
			LD (HL),A			; Stick A onto the screen
			INC DE				; Goto next byte of character
			INC H				; Goto next line on screen
			DJNZ 2B				; Loop around whilst it is Not Zero (NZ)
			RET