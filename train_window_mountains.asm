
SETUP_MOUNTAINS:
	; attrs
	ld		b, WIN_COL_TOTAL							; not the cloud row
	ld		a, %00101000								; everything black ink (to show errors) over cyan pap

	ld		de, MOUNTAINS_ATTR_BUF + WIN_COL_TOTAL		; not the cloud

	ld		b, WIN_COL_TOTAL
	ld		a, %00101000								; cyan pap
SETUP_MOUNTAIN_ATTRS_LOOP_1:
	ld		(de), a
	inc		de
	djnz	SETUP_MOUNTAIN_ATTRS_LOOP_1

	ld		b, WIN_COL_TOTAL
	ld		a, %00010101								; cyan ink, red pap
SETUP_MOUNTAIN_ATTRS_LOOP_2:
	ld		(de), a
	inc		de
	djnz	SETUP_MOUNTAIN_ATTRS_LOOP_2

	ld		b, WIN_COL_TOTAL
	ld		a, %00010000								; red pap
SETUP_MOUNTAIN_ATTRS_LOOP_3:
	ld		(de), a
	inc		de
	djnz	SETUP_MOUNTAIN_ATTRS_LOOP_3


	; pixels
	; not doing cloud OR yet
	; top and bottom are all 0s which is what we want for pap tricks
	; middle row needs diagonal slashes


	; make diag
	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; 8 byte buf
	ld		a, %11111111				
	ld		(hl), a						; 0
	inc		hl
	ld		a, %11111110			
	ld		(hl), a						; 1
	inc		hl
	ld		a, %11111100				
	ld		(hl), a						; 2
	inc		hl
	ld		a, %11111000				
	ld		(hl), a						; 3
	inc		hl
	ld		a, %11110000				
	ld		(hl), a						; 4
	inc		hl
	ld		a, %11100000				
	ld		(hl), a						; 5
	inc		hl
	ld		a, %11000000				
	ld		(hl), a						; 6
	inc		hl
	ld		a, %10000000				
	ld		(hl), a						; 7

	ld		b, WIN_COL_VIS-6
	ld		ix, 3 + MOUNTAINS_LAYER_PIXEL_BUF + ((WIN_COL_VIS+1) * 8) * 2	; middle building row
SETUP_MOUNTAIN_PIXEL_LOOP:	
	push	bc							; outer loop

	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; reload ev time as it gets trashed
	inc		ix
	call	BUF_CHAR_PIXELS_VIS_1		; buf it

	pop		bc							; outer loop
	djnz	SETUP_MOUNTAIN_PIXEL_LOOP

	ret									; SETUP_MOUNTAINSS

ANIMATE_MOUNTAINS:
	call 	MOUNTAINS_LAYER_TO_RENDER
	ret									; ANIMATE_MOUNTAINSS

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
	; not doing cloud stuff yet

	; so just 3 building rows



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

