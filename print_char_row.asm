; PRINT_CHAR_Y_X has to recalculate pixel row every char, which is slow
; this prints a row at a time
; PRINT_ROW_Y - row to print
; PRINT_START_X - colum to start printing in
; PRINT_NUM_COLS - num cols to print
; PRINT_CHAR_BUF - start of chars to print
; can't print the 2x2 $70-$7F as they don't seem to have a font in ROM or anywhere


; print row from buf
; buf is pixel row at a time, precal for draw speed
PRINT_CHAR_ROW:
    push	af
    push	bc
    push	de
    push	hl
	
; get base pix addr

; for each row

; for each pix row

; ldir line
; move to next pixel row

; next pixel row

; next row

	
	pop		hl
	pop		de
	pop		bc
	pop		af
    ret							; PRINT_CHAR_ROW:

BUF_CHAR_ROWS:
    push	af
    push	bc
    push	de
    push	hl
	
; based on PRINT_NUM_COLS, num of pixels per row in PRINT_NUM_COL_PIXELS

; for each row

; for each column

; get char

; for each pixel row in char, put in PRINT_CHAR_BUF offet by PRINT_NUM_COL_PIXELS and current row

; next char

; next column

; next row

	
	pop		hl
	pop		de
	pop		bc
	pop		af
    ret							; BUF_CHAR_ROW:

PRINT_NUM_ROW_PIXELS:
	defw	0

PRINT_CHAR_BUF: 
	defs	8 * 20 * 10			; window size, 8 bytes per block (include order no constants..)

PRINT_ROW_Y: 
	defb	0
	
PRINT_START_X:
	defb	0
	
PRINT_NUM_COLS:
	defb	0
	
PRINT_NUM_ROWS:
	defb	0

