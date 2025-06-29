
ANIMATE_BUILDINGS:
	call	LOAD_SHIFT_B_LAYER_BUF	
	call	SHIFT_BUILDINGS_LEFT								
	ld		de, (NEXT_BUILDING_COL)	; move col left
	dec		de
	ld		(NEXT_BUILDING_COL), de
	ld		a, (NEXT_BUILDING_COL)	; check if extra buff empty
	cp		WIN_COL_VIS+1			
	call	m, SETUP_BUILDINGS		; load more if needed
	ret								; ANIMATE_BUILDINGS

SHIFT_BUILDINGS_LEFT:				; unrolled for speed, honest!
	; chars
	ld		de, CHAR_BUF_OFF_ROW_3		; target
	ld		hl, CHAR_BUF_OFF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUF_OFF_ROW_4		; target
	ld		hl, CHAR_BUF_OFF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUF_OFF_ROW_5		; target
	ld		hl, CHAR_BUF_OFF_ROW_5 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUF_OFF_ROW_6		; target
	ld		hl, CHAR_BUF_OFF_ROW_6 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUF_OFF_ROW_7		; target
	ld		hl, CHAR_BUF_OFF_ROW_7 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	
	; attrs
	ld		de, ATTR_BUF_ROW_3		; target
	ld		hl, ATTR_BUF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUF_ROW_4		; target
	ld		hl, ATTR_BUF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUF_ROW_5		; target
	ld		hl, ATTR_BUF_ROW_5 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUF_ROW_6		; target
	ld		hl, ATTR_BUF_ROW_6 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUF_ROW_7		; target
	ld		hl, ATTR_BUF_ROW_7 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	
	ret								; SHIFT_BUILDINGS_LEFT

SETUP_BUILDINGS:
	call	RNG						; rng in a
	ld		(NEXT_RNG), a			; NEXT_BUILDING is now rng

	ld		a, %00010000			; mask for type, only need one bit
	and		(hl)					; get type from generated next building

	cp		%00000000				; 50/50
	call	z, ADD_GAP				; bit not set, gap, 50/50
	call	nz, ADD_BUILDING		; bit set, building, 50/50
	
	ld		a, WIN_COL_VIS			; have we filled the buffer? 
									; +1 as needed or pixel-by-pixel shift
									; so make consistent
	ld		hl, NEXT_BUILDING_COL
	cp		(hl)
	call	p, SETUP_BUILDINGS		; branch if positive
									; something in buffer 
	ret								; SETUP_BUILDINGS

BLANK_BUILDING_WIN_COL:				; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld		(CHAR_TO_BUF), a
	ld		a, ATTR_CYN_PAP			; sky is cyan
	ld		(ATTR_TO_BUF), a

	ld		b, 0
	call	BUF_ROW_AT_COL			

	ld		b, 1
	call	BUF_ROW_AT_COL			

	ld		b, 2
	call	BUF_ROW_AT_COL			

	ld		b, 3
	call	BUF_ROW_AT_COL			

	ld		b, 4
	call	BUF_ROW_AT_COL			

	ret								; BLANK_WIN_COL



ADD_BUILDING:
; load d height, e width
	ld		a, %00001100
	ld		hl, NEXT_RNG
	and		(hl)					; now a is 0000 - 0300
	rra								; shift right twice
	rra
	inc		a						; inc twice so 2-5
	inc		a
	ld		d, a					; d=height
	ld		a, %00000011
	and		(hl)					; now a is 0-3 
	inc		a						; now a is 1-4
	ld		e, a					; e=width

; ink color attr
	ld		a, %11000000			; color in top 1 bit - blue or black
	and		(hl)
	rra
	rra
	rra
	rra
	rra
	rra								; now in lowest bits
	and		%00000001				; clear others
	or		UDG_BUILDING_ATTR		; add pap colour
	ld		(BUILD_ATTR_TO_BUF), a		

	ld		b, e					; for each column...

ADD_BULDING_COL_LOOP:
	push	bc
	call	BLANK_BUILDING_WIN_COL	; clear first
	ld      a, (BUILD_ATTR_TO_BUF)	; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a
	pop		bc						; loops...
	push	bc

	ld		b, d					; add building UDGs to height
ADD_BULDING_ROW_LOOP:
	push	bc						; preserve bc

	ld		a, WIN_BUILDING_ROWS 	; base row
	sub		b						; then height
	ld		b, a					; into b for call
	ld		a, UDG_BUILDING			; building udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL			; buf it
	pop		bc						; restore bc
	djnz	ADD_BULDING_ROW_LOOP
	
	ld		bc, (NEXT_BUILDING_COL)	; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	pop		bc
	djnz	ADD_BULDING_COL_LOOP
	
	ret								; ADD_BUILDING

BUF_ROW_AT_COL:						; b building row 0-4 
	push	de						; don't trash de
	push	bc						; looping again so preserve bc

	ld		hl, (NEXT_BUILDING_COL)
	ld		a, b
	cp 		0
	jr		z, BUF_ROW_READY
	ld		de, WIN_COL_TOTAL
BUF_ROW_AT_COL_LOOP:
	add		hl, de					; move down a row
	djnz	BUF_ROW_AT_COL_LOOP		; until correct row
BUF_ROW_READY:						; hl is common offset
	pop		bc						; loop done restore

	ld		de, hl					; de is common offset

; char
	ld		hl, BUILDING_CHAR_BUF
	add		hl, de	
	ld		a, (CHAR_TO_BUF)
	ld		(hl), a					; buf char

; attr	
	ld		hl, BUILDING_ATTR_BUF	
	add		hl, de	
	ld		a, (ATTR_TO_BUF)
	ld		(hl), a					; buf attr
	
	pop		de					
	ret								; BUF_ROW_AT_COL






LOAD_SHIFT_B_LAYER_BUF:
; load row 0 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_3)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS
	call	BUF_CHAR_PIXELS

; load row 1 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_4)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 8)
	call	BUF_CHAR_PIXELS

; load row 2 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_5)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 2 * 8)
	call	BUF_CHAR_PIXELS

; load row 3 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_6)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 3 * 8)
	call	BUF_CHAR_PIXELS

; load row 4 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_7)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 4 * 8)
	call	BUF_CHAR_PIXELS

; ldir 5 x 8 rows on win_col_vis at super speed!
	ld		de, BUILDINGS_LAYER_PIXEL_BUF
	ld		hl, BUILDINGS_LAYER_PIXEL_BUF + 1
	ld		bc, WIN_COL_VIS
	ldir										; 0x0

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x1

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x2

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x3

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x4

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x5

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x6

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 0x7

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x0

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x1

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x2

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x3

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x4

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x5

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x6

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 1x7

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x0

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x1

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x2

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x3

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x4

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x5

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x6

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 2x7

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x0

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x1

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x2

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x3

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x4

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x5

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x6

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 3x7

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x0

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x1

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x2

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x3

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x4

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x5

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x6

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 4x7

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x0

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x1

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x2

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x3

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x4

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x5

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x6

	inc		de									; extra col
	inc		hl									; extra col
	ld		bc, WIN_COL_VIS
	ldir										; 5x7

	ret											; LOAD_SHIFT_B_LAYER_BUF

BUF_BUILDING_CHAR_ROWS:
	ld		hl, BUILDING_CHAR_BUF			; points to next char
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF	; points to row pixel buf

; for each row
	ld		b, WIN_BUILDING_ROWS
BUF_BUILDING_CHAR_ROW_LOOP:

; for each column / char
	push	bc							; outer loop
	ld		b, WIN_COL_VIS				
BUF_BUILDING_CHAR_COL_LOOP:
; get char pixels
; iy points to next char
	ld		a, (hl)
	ld		(PRINT_CHAR), a
	push	hl							; used for pixels
	push	bc
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	pop		bc

	call	BUF_CHAR_PIXELS
	pop		hl			

; next column / char
	inc		hl							; next char
	inc		ix							; step to next column, for that char to draw its pixel rows
	
	djnz	BUF_BUILDING_CHAR_COL_LOOP
	pop		bc							; for outer loop
	
; next row
	ld		de, WIN_COL_BUF				; iy needs to skip over extra chars
	add		hl, de
	ld		de, ((WIN_COL_VIS+1) * 7) + 1	; ix needs to skip to top-left of the next block row, +1 for the extra col
	add		ix, de
	djnz	BUF_BUILDING_CHAR_ROW_LOOP

    ret									; BUF_BUILDING_CHAR_ROWS


NEXT_BUILDING_COL:
	defw	0
	
CHAR_BUF_INDEX_ADDR:
	defw	0
	
ATTR_BUF_INDEX_ADDR:
	defw	0

ATTR_SCR_INDEX_ADDR:
	defw	0

CHAR_TO_BUF:
	defb	0
	
ATTR_TO_BUF:
	defb	0

BUILD_ATTR_TO_BUF:
	defb	0

