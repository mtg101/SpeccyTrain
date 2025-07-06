; PRINT_CHAR_Y_X has to recalculate pixel row every char, which is slow
; this prints a row at a time, specifically for the 19x10 window

; print row from buf
; buf is pixel row at a time, precalc'd for draw speed
DRAW_WINDOW_FG_CLOUDS:
; ldir attrs for all rows
	ld		de, ATTR_SCR_ROW_0			; destination
	ld		hl, ATTR_BUF_ROW_0			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_1			; destination
	ld		hl, ATTR_BUF_ROW_1			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_2			; destination
	ld		hl, ATTR_BUF_ROW_2			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_8			; destination
	ld		hl, ATTR_BUF_ROW_8			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_9			; destination
	ld		hl, ATTR_BUF_ROW_9			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move


; now blit the pixel rows... 
	ld		hl, CLOUDS_LAYER_PIXEL_BUF	; start of pixel buffer, row-by-row for ldir
										; ldir incs it, but we also need to step over extra column used for shifts
	
	ld		de, ROW_0_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_0_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_0_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_0_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
		
	ld		de, ROW_0_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_0_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_0_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_0_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column


	ld		de, ROW_1_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_1_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_2_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column


	ld		hl, FG_LAYER_PIXEL_BUF		; now the fg


	ld		de, ROW_8_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_8_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_9_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
										; don't skip for new row
	
    ret									; PRINT_CHAR_ROW


DRAW_WINDOW_BUILDINGS:
; ldir attrs for all rows
	ld		de, ATTR_SCR_ROW_3			; destination
	ld		hl, ATTR_BUF_ROW_3			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_4			; destination
	ld		hl, ATTR_BUF_ROW_4			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_5			; destination
	ld		hl, ATTR_BUF_ROW_5			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_6			; destination
	ld		hl, ATTR_BUF_ROW_6			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move

	ld		de, ATTR_SCR_ROW_7			; destination
	ld		hl, ATTR_BUF_ROW_7			; source, attr buf
	ld		bc, WIN_COL_VIS				; count
	ldir								; move


; now blit the pixel rows... 

	ld		hl, BUILDINGS_LAYER_PIXEL_BUF
										; start of pixel buffer, skipping over clouds
										; ldir incs it, but we also need to step over extra column used for shifts

	ld		de, ROW_3_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_3_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_4_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_5_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_6_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_0			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_1			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_2			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_3			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_4			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_5			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_6			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
	inc		hl							; stop over extra column
	
	ld		de, ROW_7_LINE_7			; pixel row in memory
	ld		bc, WIN_COL_VIS				; num to copy again
	ldir
										; don't skip for new row
	
    ret									; PRINT_CHAR_ROW



; hl points to char pixels: 8 bytes
; ix points to first byte of buffer
; blits all 8 bytes into correct offsets
; trashes hl, de and a
BUF_CHAR_PIXELS:
	ld		a, (hl)							; byte of pixel data
	ld		(ix), a							; into buffer
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		(ix + (WIN_COL_VIS+1)), a		; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		(ix + ((WIN_COL_VIS+1) * 2)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		(ix + ((WIN_COL_VIS+1) * 3)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		(ix + ((WIN_COL_VIS+1) * 4)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		(ix + ((WIN_COL_VIS+1) * 5)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		(ix + ((WIN_COL_VIS+1) * 6)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
; can't index (WIN_COL_VIS * 7) as it's > 127 8bitty things
	ld		de, (WIN_COL_VIS+1) * 7			; the oversized offset
	ld		hl, ix							; the base
	add		hl, de							; add 'em
	ld		(hl), a							; into buffer

	ret										; BUF_CHAR_PIXELS


; hl points to char pixels: 8 bytes
; ix points to first byte of buffer
; XORs all 8 bytes into correct offsets
; trashes hl, de and a
XOR_CHAR_PIXELS:
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix)							; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix), a							; into buffer
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix + (WIN_COL_VIS+1))		; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix + (WIN_COL_VIS+1)), a		; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix + ((WIN_COL_VIS+1) * 2))	; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix + ((WIN_COL_VIS+1) * 2)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix + ((WIN_COL_VIS+1) * 3))	; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix + ((WIN_COL_VIS+1) * 3)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix + ((WIN_COL_VIS+1) * 4))	; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix + ((WIN_COL_VIS+1) * 4)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix + ((WIN_COL_VIS+1) * 5))	; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix + ((WIN_COL_VIS+1) * 5)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
	ld		d, (ix + ((WIN_COL_VIS+1) * 6))	; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(ix + ((WIN_COL_VIS+1) * 6)), a	; into buffer with row offset
	
	inc		hl								; next byte of char pixel data
	ld		a, (hl)							; byte of pixel data
; can't index (WIN_COL_VIS * 7) as it's > 127 8bitty things
	ld		de, (WIN_COL_VIS+1) * 7			; the oversized offset
	ld		hl, ix							; the base
	add		hl, de							; add 'em
	
	ld		d, (hl)							; get existing buffer data
	xor 	d								; xor in the pixels
	ld		(hl), a							; into buffer

	ret										; XOR_CHAR_PIXELS


PRINT_ROW_PIXEL_BUF: 				
CLOUDS_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * WIN_CLOUD_ROWS * 8
BUILDINGS_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * WIN_BUILDING_ROWS * 8
FG_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * WIN_FG_ROWS * 8


SINGLE_CHAR_PIXEL_BUF_1:
	defs	8						; 8 byte buf for a single char

SINGLE_CHAR_PIXEL_BUF_2:
	defs	8						; 8 byte buf for a single char

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
