; RST $10 is slow...
; I suspect this is due to dealing with control chars like AT ans the >$8F chars for BASIC words, etc
; this routine blits the char to the y, x position
; it does not deal with ATTRs
; it uses vars PRINT_AT_Y, PRINT_AT_X & PRINT_CHAR 


; any char
PRINT_CHAR_AT_Y_X:
    push	af
    push	bc
    push	de
    push	hl

; if it's a UDG, just jump to that
	ld		a, (PRINT_CHAR)
	cp		MAX_ROM_CHAR
	jp		p, PRINT_CHAR_ENTRY	; jr doesn't have p check...
	
; else get ROM char addr
	ld		de, ROM_CHARS		; first char (space)
	sub		C_SPACE				; offset from first char
	jr		z, DONE_CHAR_PIXEL_ADDR	; if it's space, we're done

; step to correct char pixel addr...
	ld		b, a				; loop index
	ld		hl, ROM_CHARS		; for math
	ld		de, 64				; 8x8 UDG
CHAR_ADDR_LOOP:
	add		hl, de				; step to next char
	djnz	CHAR_ADDR_LOOP
	ld		de, hl				; de with char addr ready for printing
; and jump to DONE_CHAR_PIXEL_ADDR
	jr	DONE_CHAR_PIXEL_ADDR
; DONE PRINT_CHAR_AT_Y_X


; optimized for only UDGs
PRINT_UDG_AT_Y_X:
    push	af
    push	bc
    push	de
    push	hl

PRINT_CHAR_ENTRY:				; for call from PRINT_CHAR_AT_Y_X
; put mem addr of UDG pixels in de
	ld		a, (PRINT_CHAR)		; udg TO PRINT
	sub		C_UDG_1				; make into offset from base UDG

	ld		hl, UDG_START		; mem address of first UDG's pixels
	
	cp		0					; no need to move for first UDG
	jr		z, DONE_CHAR_PIXEL_ADDR
	ld		b, a				; loop index
	ld		de, 64				; 8x8 UDG
UDG_ADDR_LOOP:
	add		hl, de				; step over
	djnz	UDG_ADDR_LOOP

DONE_CHAR_PIXEL_ADDR:
	ld		de, hl				; de points to pixels for our char

	ld		a, (PRINT_AT_Y)		; block Y
	sla		a					; multiple by 8 to make in pixel
	sla		a
	sla		a
	ld		b, 	a				; b has y pixel

	ld		a, (PRINT_AT_X)		; block Y
	sla		a					; multiple by 8 to make in pixel
	sla		a
	sla		a
	ld		c, 	a				; c has x pixel
	
	call	GET_PIXEL_ADDRESS	; pixel address in hl
	
; blit each row, unrolled
	ld		a, (de)				; byte to draw in a, line 0
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 1
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 2
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 3
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 4
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 5
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 6
	ld		(hl), a				; draw it
	
	inc		de					; next byte/row of char
	call	NEXT_PIXEL_ROW		; complicated math to move hl down a row
	ld		a, (de)				; byte to draw in a, line 7
	ld		(hl), a				; draw it
	
	pop		hl
	pop		de
	pop		bc
	pop		af
    ret							; PRINT_UDG_AT_Y_X / PRINT_CHAR_AT_Y_X:


; based on http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/screen-memory-layout 
;  b = Y pixel position
;  c = X pixel position
; Returns address in hl
GET_PIXEL_ADDRESS:
	ld 		a, b				; Calculate Y2,Y1,Y0
	and 	%00000111   		; Mask out unwanted bits
	or		%01000000			; Set base address of screen
	ld		h, a				; Store in h
	ld		a, b				; Calculate Y7,Y6
	rra							; Shift to position
	rra
	rra
	and		%00011000			; Mask out unwanted bits
	or		h					; OR with Y2,Y1,Y0
	ld		h, a				; Store in h
	ld		a, b				; Calculate Y5,Y4,Y3
	rla							; Shift to position
	rla
	and		%11100000			; Mask out unwanted bits
	ld		l, a				; Store in l
	ld		a, c				; Calculate X4,X3,X2,X1,X0
	rra							; Shift into position
	rra
	rra
	and		%00011111			; Mask out unwanted bits
	or		l					; OR with Y5,Y4,Y3
	ld		l, a				; Store in l
	
	ret							; Get_Pixel_Address
	
	
; hl is current pixel address
; hl updated to point to next row
; trashes af
NEXT_PIXEL_ROW:
	ld		a, h     			; A = upper part of the address. 010T TSSS.
	and		$07					; Keeps the scanline.
	cp		$07					; Check if scanline is 7.
	jr		z, NEXT_PIXEL_ROW_CONTINUE     ; Yes, change of line.

; Scanline is not 7.
	inc		h					; Increases the scanline by 1 and exits.
	ret							; NEXT_PIXEL_ROW

NEXT_PIXEL_ROW_CONTINUE:
	; The row must be changed.
	ld		a, l				; A = lower part of the address. RRRC CCCC.
	add		a, $20				; Add one line (RRRC CCCC + 0010 0000).
	ld		l, a				; L = A.
	ld		a, h				; A = upper part of the address. 010T TSSS.

	jr		nc, NEXT_PIXEL_ROW_END  ; If there is no carriage, skip
								; to finish the calculation.

; There is carriage, it is necessary to change the third party.
	add		a, $08				; Add one to the third (010T TSSS + 0000 1000).

NEXT_PIXEL_ROW_END:
	and		$f8					; Keeps the fixed part and the third part.
								; Set the scanline to 0.
	ld		h, a				; H = A. Calculated address.

	ret							; NEXT_PIXEL_ROW_CONTINUE
	
PRINT_CHAR: 
	defb	0

PRINT_AT_Y: 
	defb	0
	
PRINT_AT_X:
	defb	0

