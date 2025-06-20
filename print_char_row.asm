; PRINT_CHAR_Y_X has to recalculate pixel row every char, which is slow
; this prints a row at a time, specifically for the 20x10 window

; print row from buf
; buf is pixel row at a time, precalc'd for draw speed
PRINT_CHAR_ROW
    push	af
    push	bc
    push	de
    push	hl

	ld		hl, PRINT_ROW_PIXEL_BUF		; start of pixel buffer, row-by-row for ldir
										; ldir incs it, so we don't need to touch it again
	
	ld		de, ROW_0_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_0_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_0_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_0_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_0			; destination
	ld		hl, ATTR_BUF_ROW_0			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_0_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_0_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_0_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_0_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_1_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_1_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_1_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_1_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_1			; destination
	ld		hl, ATTR_BUF_ROW_2			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_1_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_1_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_1_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_1_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_2_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_2_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_2_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_2_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_2			; destination
	ld		hl, ATTR_BUF_ROW_2			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_2_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_2_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_2_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_2_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_3_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_3_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_3_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_3_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_3			; destination
	ld		hl, ATTR_BUF_ROW_3			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_3_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_3_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_3_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_3_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_4_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_4_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_4_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_4_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_4			; destination
	ld		hl, ATTR_BUF_ROW_4			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_4_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_4_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_4_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_4_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_5_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_5_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_5_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_5_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_5			; destination
	ld		hl, ATTR_BUF_ROW_5			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_5_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_5_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_5_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_5_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_6_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_6_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_6_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_6_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_6			; destination
	ld		hl, ATTR_BUF_ROW_6			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_6_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_6_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_6_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_6_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_7_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_7_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_7_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_7_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_7			; destination
	ld		hl, ATTR_BUF_ROW_7			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_7_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_7_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_7_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_7_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_8_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_8_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_8_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_8_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_8			; destination
	ld		hl, ATTR_BUF_ROW_8			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_8_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_8_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_8_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_8_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_9_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_9_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_9_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_9_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
; ldir attrs for row, half way through pixel rows...
	push	hl
	push	bc
	push	de

	ld		de, ATTR_SCR_ROW_9			; destination
	ld		hl, ATTR_BUF_ROW_9			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move
	
	pop		de
	pop		bc
	pop		hl
	
	ld		de, ROW_9_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_9_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_9_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	ld		de, ROW_9_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	
	pop		hl
	pop		de
	pop		bc
	pop		af
    ret									; PRINT_CHAR_ROW:

; uses iy, so need to fuck around with ei/di and iy to protect things from 
BUF_CHAR_ROWS:
	di								; back to safe mode for iy
	push	iy						; preserve for when we ei
    push	af
    push	bc
    push	de
    push	hl
	
; for each row
	ld		b, WIN_ROWS
BUF_CHAR_ROW_LOOP:
	ld		ix, BUILDING_CHAR_BUF		; 'slow' ix but keeps it separate, and this is buff not draw
	ld		iy, PRINT_ROW_PIXEL_BUF		; points to row pixel buf
										; points to first byte of block first byte, top left of block
										; math does the rest unrolled for the 0-7 lines
; for each column / char
	ld		c, b						; inner loop can use c to get row
	push	bc							; outer loop
	ld		b, WIN_COL_VIS
BUF_CHAR_COL_LOOP:
; get char pixels
; ix points to next char
	ld		(PRINT_CHAR), ix
	push	bc
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	pop		bc

; copy each pixel row, 0-7
; iy is base buffer pixel offset, 2nd row is 19 bytes away...
	ld		a, (hl)						; byte of pixel data
	ld		(iy), a						; into buffer
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
	ld		(iy + WIN_COL_VIS), a		; into buffer with row offset
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
	ld		(iy + (WIN_COL_VIS * 2)), a	; into buffer with row offset
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
	ld		(iy + (WIN_COL_VIS * 3)), a	; into buffer with row offset
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
	ld		(iy + (WIN_COL_VIS * 4)), a	; into buffer with row offset
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
	ld		(iy + (WIN_COL_VIS * 5)), a	; into buffer with row offset
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
	ld		(iy + (WIN_COL_VIS * 6)), a	; into buffer with row offset
	
	inc		hl							; next byte of char pixel data
	ld		a, (hl)						; byte of pixel data
; can't index (WIN_COL_VIS * 7) as it's > 127 8bitty things
	ld		de, (WIN_COL_VIS * 7)		; the oversized offset
	ld		hl, iy						; the base
	add		hl, de						; add 'em
	ld		(hl), a						; into buffer
	
; next column / char
	inc		ix							; next char
	inc		iy							; next byte, remember the whole point is pixel line by line
	djnz	BUF_CHAR_COL_LOOP
	pop		bc							; for outer loop
	
; next row
; inner loop altery incremented what we need
	djnz	BUF_CHAR_ROW_LOOP

	pop		hl
	pop		de
	pop		bc
	pop		af
	pop		iy							; restore before ei (or things fuck up)
	ei									; can have them on again now
    ret							; BUF_CHAR_ROW:

; window size 19x10 - 8 bytes per block, set to pattern to use as test card for basic drawing
PRINT_ROW_PIXEL_BUF: 				
	defs		19 * 10 * 8, %10101010

; mem address of line

; not based on WIN_ROW_START or similar, as we need weird bit packing...
; current values used to compare to train_window_data.asm
; WIN_COL_VIS		= 19
; WIN_ROWS			= 10
; WIN_COL_TOTAL		= 23
; WIN_SKY_ROWS		= 7
; WIN_GRASS_ROWS	= 3
;
; WIN_ROW_START		= 6
; WIN_COL_START		= 9
;
; %010 y7y6 y2y1y0 y5y4y3 x4x3x2x1x0
;
; WIN_COL_START = 9 already in bytes > 01001
 

; WIN_ROW_START = 6, x 8 for pixel row = 48 = 00110000
; bit fuckery = 00 000 110
ROW_0_LINE_0	= %0100000011001001
ROW_0_LINE_1	= %0100000111001001
ROW_0_LINE_2	= %0100001011001001
ROW_0_LINE_3	= %0100001111001001
ROW_0_LINE_4	= %0100010011001001
ROW_0_LINE_5	= %0100010111001001
ROW_0_LINE_6	= %0100011011001001
ROW_0_LINE_7	= %0100011111001001

; row 7, x 8 for pixel row = 56 = 00111000
; bit fuckery = 00 000 111
ROW_1_LINE_0	= %0100000011101001
ROW_1_LINE_1	= %0100000111101001
ROW_1_LINE_2	= %0100001011101001
ROW_1_LINE_3	= %0100001111101001
ROW_1_LINE_4	= %0100010011101001
ROW_1_LINE_5	= %0100010111101001
ROW_1_LINE_6	= %0100011011101001
ROW_1_LINE_7	= %0100011111101001

; row 8, x 8 for pixel row = 64 = 01000000
; bit fuckery = 01 000 000
ROW_2_LINE_0	= %0100100000001001
ROW_2_LINE_1	= %0100100100001001
ROW_2_LINE_2	= %0100101000001001
ROW_2_LINE_3	= %0100101100001001
ROW_2_LINE_4	= %0100110000001001
ROW_2_LINE_5	= %0100110100001001
ROW_2_LINE_6	= %0100111000001001
ROW_2_LINE_7	= %0100111100001001

; row 9, x 8 for pixel row = 72 = 01001000
; bit fuckery = 01 000 001
ROW_3_LINE_0	= %0100100000101001
ROW_3_LINE_1	= %0100100100101001
ROW_3_LINE_2	= %0100101000101001
ROW_3_LINE_3	= %0100101100101001
ROW_3_LINE_4	= %0100110000101001
ROW_3_LINE_5	= %0100110100101001
ROW_3_LINE_6	= %0100111000101001
ROW_3_LINE_7	= %0100111100101001

; row 10, x 8 for pixel row = 80 = 01010000
; bit fuckery = 01 000 010
ROW_4_LINE_0	= %0100100001001001
ROW_4_LINE_1	= %0100100101001001
ROW_4_LINE_2	= %0100101001001001
ROW_4_LINE_3	= %0100101101001001
ROW_4_LINE_4	= %0100110001001001
ROW_4_LINE_5	= %0100110101001001
ROW_4_LINE_6	= %0100111001001001
ROW_4_LINE_7	= %0100111101001001

; row 11, x 8 for pixel row = 88 = 01011000
; bit fuckery = 01 000 011
ROW_5_LINE_0	= %0100100001101001
ROW_5_LINE_1	= %0100100101101001
ROW_5_LINE_2	= %0100101001101001
ROW_5_LINE_3	= %0100101101101001
ROW_5_LINE_4	= %0100110001101001
ROW_5_LINE_5	= %0100110101101001
ROW_5_LINE_6	= %0100111001101001
ROW_5_LINE_7	= %0100111101101001

; row 12, x 8 for pixel row = 96 = 01100000
; bit fuckery = 01 000 100
ROW_6_LINE_0	= %0100100010001001
ROW_6_LINE_1	= %0100100110001001
ROW_6_LINE_2	= %0100101010001001
ROW_6_LINE_3	= %0100101110001001
ROW_6_LINE_4	= %0100110010001001
ROW_6_LINE_5	= %0100110110001001
ROW_6_LINE_6	= %0100111010001001
ROW_6_LINE_7	= %0100111110001001


; row 13, x 8 for pixel row = 104 = 01101000
; bit fuckery = 01 000 101
ROW_7_LINE_0	= %0100100010101001
ROW_7_LINE_1	= %0100100110101001
ROW_7_LINE_2	= %0100101010101001
ROW_7_LINE_3	= %0100101110101001
ROW_7_LINE_4	= %0100110010101001
ROW_7_LINE_5	= %0100110110101001
ROW_7_LINE_6	= %0100111010101001
ROW_7_LINE_7	= %0100111110101001

; row 14, x 8 for pixel row = 112 = 01110000
; bit fuckery = 01 000 110
ROW_8_LINE_0	= %0100100011001001
ROW_8_LINE_1	= %0100100111001001
ROW_8_LINE_2	= %0100101011001001
ROW_8_LINE_3	= %0100101111001001
ROW_8_LINE_4	= %0100110011001001
ROW_8_LINE_5	= %0100110111001001
ROW_8_LINE_6	= %0100111011001001
ROW_8_LINE_7	= %0100111111001001

; row 15, x 8 for pixel row = 120 = 01111000
; bit fuckery = 01 000 111
ROW_9_LINE_0	= %0100100011101001
ROW_9_LINE_1	= %0100100111101001
ROW_9_LINE_2	= %0100101011101001
ROW_9_LINE_3	= %0100101111101001
ROW_9_LINE_4	= %0100110011101001
ROW_9_LINE_5	= %0100110111101001
ROW_9_LINE_6	= %0100111011101001
ROW_9_LINE_7	= %0100111111101001
