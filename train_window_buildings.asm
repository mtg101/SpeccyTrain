
ANIMATE_BUILDINGS:
	call	SHIFT_BUILDINGS_LEFT								
	ld		de, (NEXT_BUILDING_COL)	; move col left
	dec		de
	ld		(NEXT_BUILDING_COL), de
	ld		a, (NEXT_BUILDING_COL)	; check if extra buff empty
	cp		WIN_COL_VIS+1			
	call	m, SETUP_BUILDINGS		; call BUFFER_BUILDINGS if need to
	call	BUF_BUILDING_CHAR_ROWS	; draw to pixel buffer
	ret								; ANIMATE_BUILDINGS

SHIFT_BUILDINGS_LEFT:				; unrolled for speed, honest!
	; chars
	ld		de, CHAR_BUF_ROW_3		; target
	ld		hl, CHAR_BUF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, CHAR_BUF_ROW_4		; target
	ld		hl, CHAR_BUF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, CHAR_BUF_ROW_5		; target
	ld		hl, CHAR_BUF_ROW_5 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, CHAR_BUF_ROW_6		; target
	ld		hl, CHAR_BUF_ROW_6 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, CHAR_BUF_ROW_7		; target
	ld		hl, CHAR_BUF_ROW_7 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
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
	ret								; BUFFER_BUILDINGS

BLANK_BUILDING_WIN_COL						; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld		(CHAR_TO_BUF), a
	ld		a, ATTR_CYN_PAP			; sky is cyan
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROW_START + 1	; index from 1...
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 2
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 3
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 4
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 5
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

	ld		a, WIN_BUILDING_ROW_END + 2	; +2 for index from 1 in two ways...
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

BUF_ROW_AT_COL:						; b row 1-10 (bjnz means can't 0 index...)
	push	de						; don't trash de
	push	bc						; looping again so preserve bc

	dec		b
	
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
	ld		hl, CHAR_BUF
	add		hl, de	
	ld		a, (CHAR_TO_BUF)
	ld		(hl), a					; buf char

; attr	
	ld		hl, ATTR_BUF	
	add		hl, de	
	ld		a, (ATTR_TO_BUF)
	ld		(hl), a					; buf attr
	
	pop		de					
	ret								; BUF_ROW_AT_COL
	
	
; uses iy, so need to fuck around with ei/di and iy to protect things from 
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

