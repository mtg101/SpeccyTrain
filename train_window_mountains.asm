
SETUP_MOUNTAINS:
	; attrs - all cyan pap sky, red ink mountain


	ld		a, ATTR_CPRI								; cyan pap sky, red ink mountains
	ld		de, MOUNTAINS_ATTR_BUF + WIN_COL_TOTAL		; not the cloud
	ld		b, WIN_COL_TOTAL * (WIN_MOUNTAIN_ROWS - 1)	; not the cloud
SETUP_MOUNTAIN_ATTRS_LOOP:
	ld		(de), a
	inc		de
	djnz	SETUP_MOUNTAIN_ATTRS_LOOP

	; pixels
	; just run animation a bunch of times...
	; and hack frame_counter...
	ld		b, 60							; 60 times works for 19 col vis
SETUP_MOUNTAINS_PIXELS_LOOP:
	push	bc
	call	ANIMATE_MOUNTAINS				; add and shift mountains
	pop		bc

	ld		hl, (FRAME_COUNTER)				; back frame_counter
	inc		hl
	ld		(FRAME_COUNTER), hl

	djnz	SETUP_MOUNTAINS_PIXELS_LOOP

	ld		hl, 0							; reset frame _counter
	ld		(FRAME_COUNTER), hl

	ret										; SETUP_MOUNTAINSS

ANIMATE_MOUNTAINS:
	; shift stuff 2px left
	; lazy call twice...
	; optimize later todo
	call	MOUNTAIN_PIXEL_SHIFT_LEFT
	call	MOUNTAIN_PIXEL_SHIFT_LEFT

	ld		a, (FRAME_COUNTER)				; get frame counter
	and		%00000011						; only at 0-3
	cp		0								; if we've done 4 2px shifts
	jr		nz, ANIMATE_MOUNTAINS_DONE		; we need a new block loaded to offscreen col
	call	ANIMATE_MOUNTAINS_NEW_COL_BLOCK

ANIMATE_MOUNTAINS_DONE:
	call 	MOUNTAINS_LAYER_TO_RENDER

	ret									; ANIMATE_MOUNTAINSS


ANIMATE_MOUNTAINS_NEW_COL_BLOCK:
	call	RNG							; make sure have new RNG
	ld		a, (MOUNTAINS_SKY_HEIGHT)	; current sky height in a

	; up or down?
	cp		0							; top?
	jr		z, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN

	cp		4							; bottom?
	jr		nz, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_OTHER

	; it's on bottom - 50/50 gap or up
	ld		a, (NEXT_RNG)				; rng
	bit		5, a						; 50/50
	jr		z, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP
	jr		nz, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_GAP

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_OTHER:
	ld		a, (NEXT_RNG)				; rng
	bit		7, a						; 50/50
	jr		z, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP
	; nz fall into...

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN:

	ld		b, WIN_MOUNTAIN_ROWS			; need to do all rows
	ld		c, 0							; to count up during loop
	ld		hl, MOUNTAIN_BLANK_PIXELS		; blank for sky
	ld		(MOUNTAIN_OR_SKY_PIXELS), hl

 	ld		ix, MOUNTAINS_LAYER_PIXEL_BUF + WIN_COL_VIS		; into the offscreen bit

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN_LOOP:
	ld		a, (MOUNTAINS_SKY_HEIGHT)		; 0-3 as bottom always goes up (load each time as a gets used)
	cp		c								; are we at sky height? 
	jr		z, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN_DIAG

	; draw sky/mountain
	; ix already correct
	ld		hl, (MOUNTAIN_OR_SKY_PIXELS)		; have to reload every time
 	call	BUF_CHAR_PIXELS_VIS_1			; buf it

	; skip over diag drawing
	jr		ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN_DIAG_LOOP_DONE

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN_DIAG:

	; pixels
	; ix already correct
	ld		hl, MOUNTAIN_DOWN_PIXELS		; have to reload every time
 	call	BUF_CHAR_PIXELS_VIS_1			; buf it

	; flip to using MOUNTAIN_ALL_PIXELS for mountains
	ld		hl, MOUNTAIN_ALL_PIXELS			
	ld		(MOUNTAIN_OR_SKY_PIXELS), hl

	; fall through

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN_DIAG_LOOP_DONE:
 	ld		de, (WIN_COL_VIS + 1) * 8		; pixel row offset per block
 	add		ix, de							; next block row

	inc		c								; count up

 	djnz	ANIMATE_MOUNTAINS_NEW_COL_BLOCK_DOWN_LOOP


	ld		a, (MOUNTAINS_SKY_HEIGHT)		; current sky height in a
	inc 	a								; mountain go down, sky goes up
	ld		(MOUNTAINS_SKY_HEIGHT), a		; save

	ret										; ANIMATE_MOUNTAINS_NEW_BLOCK - DOWN



ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP:

	ld		b, WIN_MOUNTAIN_ROWS			; need to do all rows
	ld		c, 0							; to count up during loop
	ld		hl, MOUNTAIN_BLANK_PIXELS		; blank for sky
	ld		(MOUNTAIN_OR_SKY_PIXELS), hl

 	ld		ix, MOUNTAINS_LAYER_PIXEL_BUF + WIN_COL_VIS		; into the offscreen bit

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP_LOOP:
	ld		a, (MOUNTAINS_SKY_HEIGHT)		; 1-4 as top always goes down (load each time as a gets used)
	dec		a								; up diags draw in upper block
	cp		c								; are we at sky height? 
	jr		z, ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP_DIAG

	; draw sky/mountain
	; ix already correct
	ld		hl, (MOUNTAIN_OR_SKY_PIXELS)	; have to reload every time
 	call	BUF_CHAR_PIXELS_VIS_1			; buf it

	; skip over diag drawing
	jr		ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP_DIAG_LOOP_DONE

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP_DIAG:

	; pixels
	; ix already correct
	ld		hl, MOUNTAIN_UP_PIXELS			; have to reload every time
 	call	BUF_CHAR_PIXELS_VIS_1			; buf it

	; flip to using MOUNTAIN_ALL_PIXELS for mountains
	ld		hl, MOUNTAIN_ALL_PIXELS			
	ld		(MOUNTAIN_OR_SKY_PIXELS), hl

	; fall through

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP_DIAG_LOOP_DONE:
 	ld		de, (WIN_COL_VIS + 1) * 8		; pixel row offset per block
 	add		ix, de							; next block row

	inc		c								; count up

 	djnz	ANIMATE_MOUNTAINS_NEW_COL_BLOCK_UP_LOOP



	ld		a, (MOUNTAINS_SKY_HEIGHT)		; current sky height in a
	dec 	a								; mountains going up, sky goes down
	ld		(MOUNTAINS_SKY_HEIGHT), a		; save

	ret										; ANIMATE_MOUNTAINS_NEW_BLOCK - UP

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_GAP:
 	ld		ix, MOUNTAINS_LAYER_PIXEL_BUF + WIN_COL_VIS		; into the offscreen bit
	ld		b, WIN_MOUNTAIN_ROWS			; need to do all rows

ANIMATE_MOUNTAINS_NEW_COL_BLOCK_GAP_LOOP:
	ld		hl, MOUNTAIN_BLANK_PIXELS		; blank for sky
 	call	BUF_CHAR_PIXELS_VIS_1			; buf it

 	ld		de, (WIN_COL_VIS + 1) * 8		; pixel row offset per block
 	add		ix, de							; next block row

	djnz	ANIMATE_MOUNTAINS_NEW_COL_BLOCK_GAP_LOOP

	; height stays 4

	ret										; ANIMATE_MOUNTAINS_NEW_BLOCK - GAP




MOUNTAIN_PIXEL_SHIFT_LEFT:
	ld		b, WIN_MOUNTAIN_ROWS * 8	; total rows to shift (liner as it's offscreen buf not the weird screen)
	cp		a							; reset the carry bit

	; CLOUDS_LAYER_PIXEL_BUF + WIN_COL_VIS is where we start
	ld		hl, MOUNTAINS_LAYER_PIXEL_BUF + WIN_COL_VIS
MOUNTAIN_PIXEL_SHIFT_LOOP:
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

	djnz	MOUNTAIN_PIXEL_SHIFT_LOOP	; next row

	ret									; CLOUD_PIXEL_SHIFT_LEFT



MOUNTAINS_LAYER_TO_RENDER:
	; attrs
	; top row is clouds, they dictate attrs
	ld		de, RENDER_ATTR_BUF_ROW_3
	ld		hl, MOUNTAINS_ATTR_BUF + WIN_COL_TOTAL
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_4
	ld		hl, MOUNTAINS_ATTR_BUF + (WIN_COL_TOTAL * 2)
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_5
	ld		hl, MOUNTAINS_ATTR_BUF + (WIN_COL_TOTAL * 3)
	ld		bc, WIN_COL_VIS
	ldir

	; pixels
	; clouds we OR over

	ld		de, WINDOW_RENDER_PIXEL_BUF_MOUNTAINS		; cloud/mountain pixel render buf
	ld		hl, MOUNTAINS_LAYER_PIXEL_BUF				; mountain top pixel layer buf

	ld		b, 8										; 8 pixel row per block, unroll later... todo
MOUNTAIN_CLOUD_PIXEL_OR_LOOP:
	push	bc											; outer loop

	ld		b, WIN_COL_VIS
MOUNTAIN_CLOUD_PIXEL_OR_ROW_LOOP:
	ld		a, (de)										; existing cloud pixels from render layer
	ld		c, a										; save in c
	ld		a, (hl)										; mountain pixels
	or		c											; put them together OR - lost in the clouds...
	ld		(de), a										; save back to render pixels

	inc		de											; next byte
	inc		hl

	djnz	MOUNTAIN_CLOUD_PIXEL_OR_ROW_LOOP

	inc		hl											; over the extra col
	pop		bc											; outer loop
	djnz	MOUNTAIN_CLOUD_PIXEL_OR_LOOP



	; 3 building rows
	ld		de, WINDOW_RENDER_PIXEL_BUF_BUILDINGS	; not doing top mountain / cloud layer: 1_0
	ld		hl, MOUNTAINS_LAYER_PIXEL_BUF_BUILDINGS	; start of layer buf
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir								; copy over

										; de correctly inc'd already: 1_1
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_2
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_3
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_4
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_5
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_6
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 1_7
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_0
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_1
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_2
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_3
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_4
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_5
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_6
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 2_7
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_0
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_1
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_2
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_3
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_4
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_5
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_6
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 3_7
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

	ret									; MOUNTAINSS_LAYER_TO_RENDER

MOUNTAINS_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * 8
MOUNTAINS_LAYER_PIXEL_BUF_BUILDINGS:
	defs		(WIN_COL_VIS+1) * (WIN_MOUNTAIN_ROWS - 1) * 8

MOUNTAINS_SKY_HEIGHT:
	defb	4							; start at bottom

MOUNTAIN_OR_SKY_PIXELS:
	defw	0

MOUNTAIN_BLANK_PIXELS:
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000

MOUNTAIN_UP_PIXELS:
	defb	%00000001
	defb	%00000011
	defb	%00000111
	defb	%00001111
	defb	%00011111
	defb	%00111111
	defb	%01111111
	defb	%11111111

MOUNTAIN_DOWN_PIXELS:
	defb	%10000000
	defb	%11000000
	defb	%11100000
	defb	%11110000
	defb	%11111000
	defb	%11111100
	defb	%11111110
	defb	%11111111

MOUNTAIN_ALL_PIXELS:
	defb	%11111111
	defb	%11111111
	defb	%11111111
	defb	%11111111
	defb	%11111111
	defb	%11111111
	defb	%11111111
	defb	%11111111


