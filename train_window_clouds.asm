
ANIMATE_CLOUDS:
	call	CLOUD_PIXEL_SHIFT			; shift everything 1 pix over
	ld		a, (CLOUD_FRAME_COUNTER)	; inc frame counter
	inc		a
	ld		(CLOUD_FRAME_COUNTER), a
	cp		8							; if we've done 8 shifts, we need a new block loaded to offscreen col
	jr		nz, ANIMATE_CLOUDS_DONE
	ld		a, 0
	ld		(CLOUD_FRAME_COUNTER), a	; counter reset
	call	ANIMATE_CLOUDS_MOVE_BLOCK

ANIMATE_CLOUDS_DONE:
	ret									; ANIMATE_CLOUDS

CLOUD_PIXEL_SHIFT:
	ld		b, WIN_CLOUD_ROWS * 8		; total rows to shift (liner as it's offscreen buf not the weird screen)
	cp		a							; reset the carry bit

	; CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS is where we start
	ld		hl, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS
CLOUD_PIXEL_SHIFT_LOOP:
	; rotate, move left, for entire row - manually counting WIN_COL_VIS
	rl		(hl)						; 19
	dec		hl							; move left to next byte

	rl		(hl)						; 18
	dec		hl							; move left to next byte

	rl		(hl)						; 17
	dec		hl							; move left to next byte

	rl		(hl)						; 16
	dec		hl							; move left to next byte

	rl		(hl)						; 15
	dec		hl							; move left to next byte

	rl		(hl)						; 14
	dec		hl							; move left to next byte

	rl		(hl)						; 13
	dec		hl							; move left to next byte

	rl		(hl)						; 12
	dec		hl							; move left to next byte

	rl		(hl)						; 11
	dec		hl							; move left to next byte

	rl		(hl)						; 10
	dec		hl							; move left to next byte

	rl		(hl)						; 9
	dec		hl							; move left to next byte

	rl		(hl)						; 8
	dec		hl							; move left to next byte

	rl		(hl)						; 7
	dec		hl							; move left to next byte

	rl		(hl)						; 6
	dec		hl							; move left to next byte

	rl		(hl)						; 5
	dec		hl							; move left to next byte

	rl		(hl)						; 4
	dec		hl							; move left to next byte

	rl		(hl)						; 3
	dec		hl							; move left to next byte

	rl		(hl)						; 2
	dec		hl							; move left to next byte

	rl		(hl)						; 1
	dec		hl							; move left to next byte

	rl		(hl)						; 0

	ld		d, 0						; move back to end of row, then move down a row
	ld		e, (WIN_COL_VIS * 2) + 1	; we dec'd hl back to start, so move back (WIN_COL_VIS)
	add		hl, de						; then next row (WIN_COL_VIS+1)

	djnz	CLOUD_PIXEL_SHIFT_LOOP		; next row

	call	CLOUD_LAYER_TO_RENDER

	ret									; CLOUD_PIXEL_SHIFT


CLOUD_LAYER_TO_RENDER:
	; attrs
	ld		de, RENDER_ATTR_BUF_ROW_0
	ld		hl, CLOUD_ATTR_BUF
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_1
	ld		hl, CLOUD_ATTR_BUF + WIN_COL_TOTAL
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_2
	ld		hl, CLOUD_ATTR_BUF + (WIN_COL_TOTAL * 2)
	ld		bc, WIN_COL_VIS
	ldir

	; pixels
	ld		de, WINDOW_RENDER_PIXEL_BUF_CLOUDS	; start of pixel render buf: 0_0
	ld		hl, CLOUDS_LAYER_PIXEL_BUF	; start of layer buf
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir								; copy over

										; de correctly inc'd already: 0_1
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 0_2
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 0_3
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 0_4
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 0_5
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 0_6
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 0_7
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_0
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_1
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_2
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_3
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_4
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_5
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_6
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_7
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_0
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_1
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_2
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_3
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_4
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_5
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_6
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_7
	inc		hl							; step over extra col from FG_LAYER_PIXEL_BUF
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

	ret									; CLOUDS_LAYER_TO_RENDER



ANIMATE_CLOUDS_MOVE_BLOCK:
	call	SHIFT_CLOUDS_BLOCK_LEFT								
	ld		de, (NEXT_CLOUD_COL)		; move col left
	dec		de
	ld		(NEXT_CLOUD_COL), de
	ld		a, (NEXT_CLOUD_COL)			; check if extra buff empty
	cp		WIN_COL_VIS+1			
	call	m, ADD_CLOUDS				; load more if needed
	call	LOAD_BLOCK_CLOUD_LAYER_BUF	
	ret									; ANIMATE_CLOUDS

SHIFT_CLOUDS_BLOCK_LEFT:				; unrolled for speed, honest!
	; chars only (attrs static)
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
	
	ret								; SHIFT_CLOUDS_BLOCK_LEFT

SETUP_CLOUDS:
; static attrs
	ld		b, WIN_CLOUD_ROWS * WIN_COL_TOTAL
	ld		a, %00101111			; everything white on cyan
	ld		de, CLOUD_ATTR_BUF
SETUP_CLOUD_ATTRS_LOOP:
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_CLOUD_ATTRS_LOOP
; and the udgs
	call	ADD_CLOUDS
	call	LOAD_BLOCK_CLOUD_LAYER_BUF
	ret								; SETUP_CLOUDS

ADD_CLOUDS:
	call	RNG						; change (NEXT_RNG) - diff to builds, in case of weird repeats

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
	ret								; ADD_CLOUDS

BLANK_CLOUD_WIN_COL:				; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld		(CLOUD_CHAR_TO_BUF), a

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

	ld		b, d							; correct row
	ld		a, UDG_HEDGE_CLOUD_1x2_L		; hedge udg in a
	ld		(CLOUD_CHAR_TO_BUF), a

	call	BUF_CLOUD_ROW_AT_COL			; buf it

	ld		bc, (NEXT_CLOUD_COL)			; move to next column
	inc		bc
	ld		(NEXT_CLOUD_COL), bc

	call	BLANK_CLOUD_WIN_COL				; clear first

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
	
	pop		de					
	ret								; BUF_ROW_AT_COL


LOAD_BLOCK_CLOUD_LAYER_BUF:
; load row 0 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_0)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS
	call	BUF_CHAR_PIXELS_VIS_1
; load row 1 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_1)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 8)
	call	BUF_CHAR_PIXELS_VIS_1

; load row 2 offscreen char
	ld		a, (CHAR_BUF_OFF_ROW_2)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 2 * 8)
	call	BUF_CHAR_PIXELS_VIS_1

	ret									; LOAD_BLOCK_CLOUD_LAYER_BUF

BUF_CLOUD_CHAR_ROWS:					; only called during setup, not animate
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

	call	BUF_CHAR_PIXELS_VIS_1
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

CLOUDS_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * WIN_CLOUD_ROWS * 8

NEXT_CLOUD_COL:
	defw	0
	
CLOUD_CHAR_TO_BUF:
	defb	0
	
CLOUD_FRAME_COUNTER:
	defb	0
