; PRINT_CHAR_Y_X has to recalculate pixel row every char, which is slow
; this prints a row at a time, specifically for the 20x10 window

; print row from buf
; buf is pixel row at a time, precalc'd for draw speed
PRINT_CHAR_ROW:
    push	af
    push	bc
    push	de
    push	hl

	ld		hl, (PRINT_CHAR_BUF)		; start of buffer
	
	ld		de, ROW_0_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	
	ld		de, ROW_0_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_0_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_0_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_0_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_0_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_0_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_0_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_1_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_2_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_3_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_4_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_5_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_6_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_7_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_8_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	ld		de, ROW_9_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	add		hl, bc						; step over pixel buffer by same amount
	ldir
	
	pop		hl
	pop		de
	pop		bc
	pop		af
    ret									; PRINT_CHAR_ROW:

BUF_CHAR_ROWS:
    push	af
    push	bc
    push	de
    push	hl
	
; for each row
	ld		b, WIN_ROWS
BUF_CHAR_ROW_LOOP:
	ld		ix, BUILDING_CHAR_BUF		; 'slow' ix but keeps it separate, and this is buff not draw
	ld		iy, PRINT_CHAR_BUF			; points to row pixel buf
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
    ret							; BUF_CHAR_ROW:

; window size 20x10x8
PRINT_CHAR_BUF: 				
	defs		20 * 10 * 8

; mem address of lines
ROW_0_LINE_0	= SCREEN_START
ROW_0_LINE_1	= SCREEN_START
ROW_0_LINE_2	= SCREEN_START
ROW_0_LINE_3	= SCREEN_START
ROW_0_LINE_4	= SCREEN_START
ROW_0_LINE_5	= SCREEN_START
ROW_0_LINE_6	= SCREEN_START
ROW_0_LINE_7	= SCREEN_START

ROW_1_LINE_0	= SCREEN_START
ROW_1_LINE_1	= SCREEN_START
ROW_1_LINE_2	= SCREEN_START
ROW_1_LINE_3	= SCREEN_START
ROW_1_LINE_4	= SCREEN_START
ROW_1_LINE_5	= SCREEN_START
ROW_1_LINE_6	= SCREEN_START
ROW_1_LINE_7	= SCREEN_START

ROW_2_LINE_0	= SCREEN_START
ROW_2_LINE_1	= SCREEN_START
ROW_2_LINE_2	= SCREEN_START
ROW_2_LINE_3	= SCREEN_START
ROW_2_LINE_4	= SCREEN_START
ROW_2_LINE_5	= SCREEN_START
ROW_2_LINE_6	= SCREEN_START
ROW_2_LINE_7	= SCREEN_START

ROW_3_LINE_0	= SCREEN_START
ROW_3_LINE_1	= SCREEN_START
ROW_3_LINE_2	= SCREEN_START
ROW_3_LINE_3	= SCREEN_START
ROW_3_LINE_4	= SCREEN_START
ROW_3_LINE_5	= SCREEN_START
ROW_3_LINE_6	= SCREEN_START
ROW_3_LINE_7	= SCREEN_START

ROW_4_LINE_0	= SCREEN_START
ROW_4_LINE_1	= SCREEN_START
ROW_4_LINE_2	= SCREEN_START
ROW_4_LINE_3	= SCREEN_START
ROW_4_LINE_4	= SCREEN_START
ROW_4_LINE_5	= SCREEN_START
ROW_4_LINE_6	= SCREEN_START
ROW_4_LINE_7	= SCREEN_START

ROW_5_LINE_0	= SCREEN_START
ROW_5_LINE_1	= SCREEN_START
ROW_5_LINE_2	= SCREEN_START
ROW_5_LINE_3	= SCREEN_START
ROW_5_LINE_4	= SCREEN_START
ROW_5_LINE_5	= SCREEN_START
ROW_5_LINE_6	= SCREEN_START
ROW_5_LINE_7	= SCREEN_START

ROW_6_LINE_0	= SCREEN_START
ROW_6_LINE_1	= SCREEN_START
ROW_6_LINE_2	= SCREEN_START
ROW_6_LINE_3	= SCREEN_START
ROW_6_LINE_4	= SCREEN_START
ROW_6_LINE_5	= SCREEN_START
ROW_6_LINE_6	= SCREEN_START
ROW_6_LINE_7	= SCREEN_START

ROW_7_LINE_0	= SCREEN_START
ROW_7_LINE_1	= SCREEN_START
ROW_7_LINE_2	= SCREEN_START
ROW_7_LINE_3	= SCREEN_START
ROW_7_LINE_4	= SCREEN_START
ROW_7_LINE_5	= SCREEN_START
ROW_7_LINE_6	= SCREEN_START
ROW_7_LINE_7	= SCREEN_START

ROW_8_LINE_0	= SCREEN_START
ROW_8_LINE_1	= SCREEN_START
ROW_8_LINE_2	= SCREEN_START
ROW_8_LINE_3	= SCREEN_START
ROW_8_LINE_4	= SCREEN_START
ROW_8_LINE_5	= SCREEN_START
ROW_8_LINE_6	= SCREEN_START
ROW_8_LINE_7	= SCREEN_START

ROW_9_LINE_0	= SCREEN_START
ROW_9_LINE_1	= SCREEN_START
ROW_9_LINE_2	= SCREEN_START
ROW_9_LINE_3	= SCREEN_START
ROW_9_LINE_4	= SCREEN_START
ROW_9_LINE_5	= SCREEN_START
ROW_9_LINE_6	= SCREEN_START
ROW_9_LINE_7	= SCREEN_START
