
ANIMATE_CLOUDS:
	ld		a, (CLOUD_FRAME_COUNTER)	; inc frame counter
	inc		a
	ld		(CLOUD_FRAME_COUNTER), a
	cp		8							; 0-7 shifts, at 8 we move a whole block
	jr		nz, ANIMATE_CLOUDS_DONE
	ld		a, 0
	ld		(CLOUD_FRAME_COUNTER), a	; counter reset
	call	ANIMATE_CLOUDS_MOVE_BLOCK

ANIMATE_CLOUDS_DONE:
	ret									; ANIMATE_CLOUDS


ANIMATE_CLOUDS_MOVE_BLOCK:
	call	LOAD_BLOCK_SHIFT_CLOUD_LAYER_BUF	
	call	SHIFT_CLOUDS_LEFT								
	ld		de, (NEXT_CLOUD_COL)	; move col left
	dec		de
	ld		(NEXT_CLOUD_COL), de
	ld		a, (NEXT_CLOUD_COL)		; check if extra buff empty
	cp		WIN_COL_VIS+1			
	call	m, SETUP_CLOUDS			; load more if needed
	ret								; ANIMATE_CLOUDS

SHIFT_CLOUDS_LEFT:				; unrolled for speed, honest!
	; chars
	ld		de, CHAR_BUF_OFF_ROW_0		; target
	ld		hl, CHAR_BUF_OFF_ROW_0 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUF_OFF_ROW_1		; target
	ld		hl, CHAR_BUF_OFF_ROW_1 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUF_OFF_ROW_2		; target
	ld		hl, CHAR_BUF_OFF_ROW_2 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	
	; attrs
	ld		de, ATTR_BUF_ROW_0		; target
	ld		hl, ATTR_BUF_ROW_0 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUF_ROW_1		; target
	ld		hl, ATTR_BUF_ROW_1 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUF_ROW_2		; target
	ld		hl, ATTR_BUF_ROW_2 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	
	ret								; SHIFT_CLOUDS_LEFT

SETUP_CLOUDS:
	call	RNG						; rng in a (diff to builds, in case of weird repeats)
	ld		(NEXT_RNG), a			; NEXT_RNG is now rng

	ld		a, %00010000			; mask for type, only need one bit
	and		(hl)					; get type from generated next cloud

	cp		%00000000				; 50/50
	call	z, ADD_CLOUD_GAP		; bit not set, gap, 50/50
	call	nz, ADD_CLOUD			; bit set, cloud, 50/50
	
	ld		a, WIN_COL_VIS			; have we filled the buffer? 
									; +1 as needed or pixel-by-pixel shift
									; so make consistent
	ld		hl, NEXT_CLOUD_COL
	cp		(hl)
	call	p, SETUP_CLOUDS			; branch if positive
									; something in buffer 
	ret								; SETUP_CLOUDS

BLANK_CLOUD_WIN_COL:				; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld		(CLOUD_CHAR_TO_BUF), a
	ld		a, ATTR_CYN_PAP			; sky is cyan
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, 0
	call	BUF_CLOUD_ROW_AT_COL			

	ld		b, 1
	call	BUF_CLOUD_ROW_AT_COL			

	ld		b, 2
	call	BUF_CLOUD_ROW_AT_COL			

	ret								; BLANK_CLOUD_WIN_COL

ADD_CLOUD_GAP:
	push	af						; preserve for outer logic
	call	BLANK_CLOUD_WIN_COL		; clear gap
	ld		de, (NEXT_CLOUD_COL)	; move to next column
	inc		de
	ld		(NEXT_CLOUD_COL), de
	pop		af						; restore for outer logic
	ret								; ADD_SIMPLE_GAP


ADD_CLOUD:
; load d height, e width
	ld		a, %00001100
	ld		hl, NEXT_RNG
	and		(hl)					; now a is 0000 - 0300
	rra								; shift right twice
	rra								; and it's 0-3
	ld		d, a					; d=height
	ld		a, %00000011
	and		(hl)					; now a is 0-3 
	inc		a						; now a is 1-4
	ld		e, a					; e=width

; ink color attr
	ld		a, UDG_CLOUD_ATTR		; single colour, avoids attr clash, and yellow clouds look shit
	ld		(CLOUD_ATTR_TO_BUF_BAK), a	

; which shape hedge? from width as height used to fence v hedge
	ld		a, e							; width for which cloud

	cp		0								; case 0:

	jr		z, ADD_CLOUD_1x1
	cp		1								; case 1:
	jp		z, ADD_CLOUD_1x2
	cp		2								; case 2:
	jp		z, ADD_CLOUD_TREE_TOP

; falls through to last case to save a cp
ADD_CLOUD_2x2:
; height is 50/50 high or low
	ld		a, d
	ld		d, WIN_CLOUD_ROWS - 1			; bottom row
	and		a, %00000001
	cp		%00000001
	jr		z, POS_2x2_DONE
	ld		d, WIN_CLOUD_ROWS - 2			; one up from bottom

POS_2x2_DONE:
; now buf the cloud where it should be
	call	BLANK_CLOUD_WIN_COL				; clear first
	ld      a, (CLOUD_ATTR_TO_BUF_BAK)		; BLANK_WIN_COL trashes attrs
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_2x2_BL		; BL udg in a
	ld		(CLOUD_CHAR_TO_BUF), a
	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		a, UDG_HEDGE_CLOUD_2x2_TL		; TL udg in a
	ld		(CLOUD_CHAR_TO_BUF), a
	dec		b								; above trunk
	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	call	BLANK_CLOUD_WIN_COL				; clear first
	ld      a, (CLOUD_ATTR_TO_BUF_BAK)		; BLANK_WIN_COL trashes attrs
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_2x2_BR		; BR udg in a
	ld		(CLOUD_CHAR_TO_BUF), a
	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		a, UDG_HEDGE_CLOUD_2x2_TR		; TR udg in a
	ld		(CLOUD_CHAR_TO_BUF), a
	dec		b								; above trunk
	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	ret										; ADD_CLOUD (saved extra jump before return)

ADD_CLOUD_1x1:
; height is 50/50 high or low (looks weird in row 0)
	ld		a, d
	ld		d, WIN_CLOUD_ROWS - 1			; bottom row
	and		a, %00000001
	cp		%00000001
	jr		z, POS_1x1_DONE
	ld		d, WIN_CLOUD_ROWS - 2			; one up from bottom

POS_1x1_DONE:
; now buf the cloud where it should be
	call	BLANK_CLOUD_WIN_COL				; clear first
	ld      a, (CLOUD_ATTR_TO_BUF_BAK)		; BLANK_WIN_COL trashes attrs
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_1x1			; hedge udg in a
	ld		(CLOUD_CHAR_TO_BUF), a

	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	ret										; ADD_CLOUD (saved extra jump before return)

ADD_CLOUD_1x2:
; height is 50/50 high or low (looks weird in row 0)
	ld		a, d
	ld		d, WIN_CLOUD_ROWS - 1			; bottom row
	and		a, %00000001
	cp		%00000001
	jr		z, POS_1x2_DONE
	ld		d, WIN_CLOUD_ROWS - 2			; one up from bottom

POS_1x2_DONE:
; now buf the cloud where it should be
	call	BLANK_CLOUD_WIN_COL				; clear first
	ld      a, (CLOUD_ATTR_TO_BUF_BAK)		; BLANK_WIN_COL trashes attrs
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_1x2_L		; hedge udg in a
	ld		(CLOUD_CHAR_TO_BUF), a

	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	call	BLANK_CLOUD_WIN_COL				; clear first
	ld      a, (CLOUD_ATTR_TO_BUF_BAK)		; BLANK_WIN_COL trashes attrs
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_1x2_R		; hedge udg in a
	ld		(CLOUD_CHAR_TO_BUF), a

	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	ret										; ADD_CLOUD (saved extra jump before return)

ADD_CLOUD_TREE_TOP:							; tree shape cumulo nimbus would be odd, so just use top as 1x1
; height is 50/50 high or low (looks weird in row 0)
	ld		a, d
	ld		d, WIN_CLOUD_ROWS - 1			; bottom row
	and		a, %00000001
	cp		%00000001
	jr		z, POS_TREE_TOP_DONE
	ld		d, WIN_CLOUD_ROWS - 2			; one up from bottom

POS_TREE_TOP_DONE:
; now buf the cloud where it should be
	call	BLANK_CLOUD_WIN_COL				; clear first
	ld      a, (CLOUD_ATTR_TO_BUF_BAK)		; BLANK_WIN_COL trashes attrs
	ld		(CLOUD_ATTR_TO_BUF), a

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_2x1_T		; tree top udg in a
	ld		(CLOUD_CHAR_TO_BUF), a
	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	ret										; ADD_CLOUD (saved extra jump before return)


BUF_CLOUD_ROW_AT_COL:				; b cloud row 0-3
	push	de						; don't trash de
	push	bc						; looping again so preserve bc

	ld		hl, (NEXT_CLOUD_COL)
	ld		a, b
	cp 		0
	jr		z, BUF_CLOUD_ROW_READY
	ld		de, WIN_COL_TOTAL
BUF_CLOUD_ROW_AT_COL_LOOP:
	add		hl, de					; move down a row
	djnz	BUF_CLOUD_ROW_AT_COL_LOOP	; until correct row
BUF_CLOUD_ROW_READY:				; hl is common offset
	pop		bc						; loop done restore

	ld		de, hl					; de is common offset

; char
	ld		hl, CLOUD_CHAR_BUF
	add		hl, de	
	ld		a, (CLOUD_CHAR_TO_BUF)
	ld		(hl), a					; buf char

; attr	
	ld		hl, CLOUD_ATTR_BUF	
	add		hl, de	
	ld		a, (CLOUD_ATTR_TO_BUF)
	ld		(hl), a					; buf attr
	
	pop		de					
	ret								; BUF_ROW_AT_COL


LOAD_BLOCK_SHIFT_CLOUD_LAYER_BUF:
; load row 0 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_0)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS
	call	BUF_CHAR_PIXELS
; load row 1 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_1)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 8)
	call	BUF_CHAR_PIXELS

; load row 2 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_2)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 2 * 8)
	call	BUF_CHAR_PIXELS

; ldir 3 x 8 rows on win_col_vis at super speed!
	ld		de, CLOUDS_LAYER_PIXEL_BUF
	ld		hl, CLOUDS_LAYER_PIXEL_BUF + 1
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

	ret											; LOAD_SHIFT_C_LAYER_BUF

BUF_CLOUD_CHAR_ROWS:
	ld		hl, CLOUD_CHAR_BUF			; points to next char
	ld		ix, CLOUDS_LAYER_PIXEL_BUF	; points to row pixel buf

; for each row
	ld		b, WIN_CLOUD_ROWS
BUF_CLOUD_CHAR_ROW_LOOP:

; for each column / char
	push	bc							; outer loop
	ld		b, WIN_COL_VIS				
BUF_CLOUD_CHAR_COL_LOOP:
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
	
	djnz	BUF_CLOUD_CHAR_COL_LOOP
	pop		bc							; for outer loop
	
; next row
	ld		de, WIN_COL_BUF				; de needs to skip over extra chars
	add		hl, de
	ld		de, ((WIN_COL_VIS+1) * 7) + 1	; ix needs to skip to top-left of the next block row, +1 for the extra col
	add		ix, de
	djnz	BUF_CLOUD_CHAR_ROW_LOOP

    ret									; BUF_CLOUD_CHAR_ROWS


NEXT_CLOUD_COL:
	defw	0
	
CLOUD_CHAR_TO_BUF:
	defb	0
	
CLOUD_ATTR_TO_BUF:
	defb	0

CLOUD_ATTR_TO_BUF_BAK:
	defb	0

CLOUD_FRAME_COUNTER:
	defb	0
