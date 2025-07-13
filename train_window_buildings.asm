
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
	ld		de, CHAR_BUILDING_BUF_OFF_ROW_0		; target
	ld		hl, CHAR_BUILDING_BUF_OFF_ROW_0 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUILDING_BUF_OFF_ROW_1		; target
	ld		hl, CHAR_BUILDING_BUF_OFF_ROW_1 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUILDING_BUF_OFF_ROW_2		; target
	ld		hl, CHAR_BUILDING_BUF_OFF_ROW_2 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUILDING_BUF_OFF_ROW_3		; target
	ld		hl, CHAR_BUILDING_BUF_OFF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	ld		de, CHAR_BUILDING_BUF_OFF_ROW_4		; target
	ld		hl, CHAR_BUILDING_BUF_OFF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_BUF - 1			; move whole buffer
	ldir
	
	; attrs
	ld		de, ATTR_BUILDING_BUF_ROW_0		; target
	ld		hl, ATTR_BUILDING_BUF_ROW_0 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUILDING_BUF_ROW_1		; target
	ld		hl, ATTR_BUILDING_BUF_ROW_1 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUILDING_BUF_ROW_2		; target
	ld		hl, ATTR_BUILDING_BUF_ROW_2 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUILDING_BUF_ROW_3		; target
	ld		hl, ATTR_BUILDING_BUF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir
	ld		de, ATTR_BUILDING_BUF_ROW_4		; target
	ld		hl, ATTR_BUILDING_BUF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_TOTAL-1		; move whole buffer
	ldir

	call	BUILDINGS_LAYER_TO_RENDER	
	
	ret								; SHIFT_BUILDINGS_LEFT

SETUP_BUILDINGS:
	call	RNG						; change (NEXT_RNG)

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
	call	BUF_BULDING_ROW_AT_COL			

	ld		b, 1
	call	BUF_BULDING_ROW_AT_COL			

	ld		b, 2
	call	BUF_BULDING_ROW_AT_COL			

	ld		a, ATTR_GRN_PAP			; grass is green
	ld		(ATTR_TO_BUF), a

	ld		b, 3
	call	BUF_BULDING_ROW_AT_COL			

	ld		b, 4
	call	BUF_BULDING_ROW_AT_COL			

	ret								; BLANK_WIN_COL



ADD_BUILDING:
; load d height, e width
	ld		a, %00001100
	ld		hl, NEXT_RNG
	and		(hl)					; now a is 0000 - 0300
	rra								; shift right twice
	rra
	inc		a						; inc twice so 1-5
	bit		5, (hl)					; random (fnord) bit test
	jr		z, STAY_SMALL			; 50/50 small
	inc		a						; make it 2-5 
STAY_SMALL:
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

	call	BUF_BULDING_ROW_AT_COL	; buf it
	pop		bc						; restore bc
	djnz	ADD_BULDING_ROW_LOOP
	
	ld		bc, (NEXT_BUILDING_COL)	; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	pop		bc
	djnz	ADD_BULDING_COL_LOOP
	
	ret								; ADD_BUILDING

BUF_BULDING_ROW_AT_COL:				; b building row 0-4 
	push	de						; don't trash de
	push	bc						; looping again so preserve bc

	ld		hl, (NEXT_BUILDING_COL)
	ld		a, b
	cp 		0
	jr		z, BUF_BUILDING_ROW_READY
	ld		de, WIN_COL_TOTAL
BUF_BUILDING_ROW_AT_COL_LOOP:
	add		hl, de					; move down a row
	djnz	BUF_BUILDING_ROW_AT_COL_LOOP	; until correct row
BUF_BUILDING_ROW_READY:						; hl is common offset
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
	ld		a, (CHAR_BUILDING_BUF_OFF_ROW_0)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS
	call	BUF_CHAR_PIXELS_VIS_1

; load row 1 offscreen char
	ld		a, (CHAR_BUILDING_BUF_OFF_ROW_1)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 8)
	call	BUF_CHAR_PIXELS_VIS_1

; load row 2 offscreen char
	ld		a, (CHAR_BUILDING_BUF_OFF_ROW_2)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 2 * 8)
	call	BUF_CHAR_PIXELS_VIS_1

; load row 3 offscreen char
	ld		a, (CHAR_BUILDING_BUF_OFF_ROW_3)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 3 * 8)
	call	BUF_CHAR_PIXELS_VIS_1

; load row 4 offscreen char
	ld		a, (CHAR_BUILDING_BUF_OFF_ROW_4)
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_PIXEL_MEM		; addr of pixels for char in hl
	ld		ix, BUILDINGS_LAYER_PIXEL_BUF + WIN_COL_VIS + ((WIN_COL_VIS+1) * 4 * 8)
	call	BUF_CHAR_PIXELS_VIS_1

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

	call	BUF_CHAR_PIXELS_VIS_1
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

BUILDINGS_LAYER_TO_RENDER:
	; building attrs
	; takes paper from mountains, ink from self, and overwites buffer (overwriting existing mountains)

	ld		hl, BUILDING_ATTR_BUF
	ld		de, RENDER_ATTR_BUF_ROW_3

	ld		b, WIN_COL_VIS
	ld		c, 0							; counts up for attr offset
RENDER_ATTR_BUF_ROW_3_LOOP:
	ld		a, (hl)							; building attr for ink
	cp		ATTR_CYN_PAP					; if it's a gap...
	jr		z, SKIP_GAP_3					; skip gap

	; it's a building...

	; change pap to cyan (hedges are green, and ldir so have to flip here)
	and		%11000111						; clear pap
	or		%00101000						; set cyan pap
	ld		(de), a							; cyan (mountain) pap, building ink, into render buf

	; are we drawing building over full mountain? 
	; if so xor means building outline is now pap
	; so if top byte of pixels in render is $FF full, change attrs
	; set pap (building outline) from builfingh ink (black/blue)
	; set ink to red, as mountains
	push	hl
	push	de

	ld		de, WINDOW_RENDER_PIXEL_BUF_BUILDINGS	; building pixel render buf
	ld		h, 0
	ld		l, c									; hl is col offset
	add		hl, de									; hl points to first pixel byte

	ld		a, (hl)									; top row pixels

	pop		de
	pop		hl

	cp		%11111111								; if top row pixels are all on, it's a whole mountain, flip
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	cp		%01111111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	cp		%01111110								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	cp		%00111111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	cp		%11111100								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	cp		%00011111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	cp		%11111000								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP

	jr		RENDER_ATTR_BUF_ROW_3_LOOP_DONE_FLIP	; not enough mountain, don't flip

RENDER_ATTR_BUF_ROW_3_LOOP_DO_FLIP
	; flip...
	; pap becomes ink
	ld		a, (hl)							; building attr for ink
	and		%00000111						; get ink
	cp		a								; clear carry
	rl		a
	rl 		a
	rl 		a								; ink moved to pap position

	push	bc								; c counts up in loop
	ld		c, a							; c stores just pap

	ld		a, (hl)							; building attr for ink again

	; ink becomes mountain red
	and		%11111000						; clear ink
	or		%00000010						; set red ink

	; pap from c
	and		%11000111						; clear pap
	or		c								; pap from c (old ink)
	pop		bc								; c back to counting

	ld		(de), a							; into render buf
	


RENDER_ATTR_BUF_ROW_3_LOOP_DONE_FLIP:
SKIP_GAP_3:
	inc		hl								; next block
	inc		de
	inc		c

	djnz	RENDER_ATTR_BUF_ROW_3_LOOP



	ld		hl, BUILDING_ATTR_BUF + WIN_COL_TOTAL
	ld		de, RENDER_ATTR_BUF_ROW_4

	ld		b, WIN_COL_VIS
	ld		c, 0							; counts up for attr offset
RENDER_ATTR_BUF_ROW_4_LOOP:
	ld		a, (hl)							; building attr for ink
	cp		ATTR_CYN_PAP					; if it's a gap...
	jr		z, SKIP_GAP_4					; skip gap

	; it's a building...

	; change pap to cyan (hedges are green, and ldir so have to flip here)
	and		%11000111						; clear pap
	or		%00101000						; set cyan pap
	ld		(de), a							; cyan (mountain) pap, building ink, into render buf

	; are we drawing building over full mountain? 
	; if so xor means building outline is now pap
	; so if top byte of pixels in render is $FF full, change attrs
	; set pap (building outline) from builfingh ink (black/blue)
	; set ink to red, as mountains
	push	hl
	push	de

	ld		de, WINDOW_RENDER_PIXEL_BUF_BUILDINGS + (WIN_COL_VIS * 8)	; building pixel render buf, offset
	ld		h, 0
	ld		l, c									; hl is col offset
	add		hl, de									; hl points to first pixel byte

	ld		a, (hl)									; top row pixels

	pop		de
	pop		hl

	cp		%11111111								; if top row pixels are all on, it's a whole mountain, flip
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	cp		%01111111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	cp		%11111110								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	cp		%00111111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	cp		%11111100								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	cp		%00011111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	cp		%11111000								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP

	jr		RENDER_ATTR_BUF_ROW_4_LOOP_DONE_FLIP	; not enough mountain, don't flip

RENDER_ATTR_BUF_ROW_4_LOOP_DO_FLIP
	; flip...
	; pap becomes ink
	ld		a, (hl)							; building attr for ink
	and		%00000111						; get ink
	cp		a								; clear carry
	rl		a
	rl 		a
	rl 		a								; ink moved to pap position

	push	bc								; c counts up in loop
	ld		c, a							; c stores just pap

	ld		a, (hl)							; building attr for ink again

	; ink becomes mountain red
	and		%11111000						; clear ink
	or		%00000010						; set red ink

	; pap from c
	and		%11000111						; clear pap
	or		c								; pap from c (old ink)
	pop		bc								; c back to counting

	ld		(de), a							; into render buf
	


RENDER_ATTR_BUF_ROW_4_LOOP_DONE_FLIP:
SKIP_GAP_4:
	inc		hl								; next block
	inc		de
	inc		c

	djnz	RENDER_ATTR_BUF_ROW_4_LOOP



	ld		hl, BUILDING_ATTR_BUF + (WIN_COL_TOTAL * 2)
	ld		de, RENDER_ATTR_BUF_ROW_5

	ld		b, WIN_COL_VIS
	ld		c, 0							; counts up for attr offset
RENDER_ATTR_BUF_ROW_5_LOOP:
	ld		a, (hl)							; mountain attr for ink
	cp		ATTR_CYN_PAP					; if it's a gap...
	jr		z, SKIP_GAP_5					; skip gap

	; it's a building...

	; change pap to cyan (hedges are green, and ldir so have to flip here)
	and		%11000111						; clear pap
	or		%00101000						; set cyan pap
	ld		(de), a							; cyan (mountain) pap, building ink, into render buf

	; are we drawing building over full mountain? 
	; if so xor means building outline is now pap
	; so if top byte of pixels in render is $FF full, change attrs
	; set pap (building outline) from builfingh ink (black/blue)
	; set ink to red, as mountains
	push	hl
	push	de

	ld		de, WINDOW_RENDER_PIXEL_BUF_BUILDINGS + ((WIN_COL_VIS * 8) * 2)	; building pixel render buf, offset
	ld		h, 0
	ld		l, c									; hl is col offset
	add		hl, de									; hl points to first pixel byte

	ld		a, (hl)									; top row pixels

	pop		de
	pop		hl

	cp		%11111111								; if top row pixels are all on, it's a whole mountain, flip
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	cp		%01111111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	cp		%11111110								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	cp		%00111111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	cp		%11111100								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	cp		%00011111								; if top row pixels are nearly all on, flip
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	cp		%11111000								; if top row pixels are nearly all on, 
	jr		z, RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP

	jr		RENDER_ATTR_BUF_ROW_5_LOOP_DONE_FLIP	; not enough mountain, don't flip

RENDER_ATTR_BUF_ROW_5_LOOP_DO_FLIP
	; flip...
	; pap becomes ink
	ld		a, (hl)							; building attr for ink
	and		%00000111						; get ink
	cp		a								; clear carry
	rl		a
	rl 		a
	rl 		a								; ink moved to pap position

	push	bc								; c counts up in loop
	ld		c, a							; c stores just pap

	ld		a, (hl)							; building attr for ink again

	; ink becomes mountain red
	and		%11111000						; clear ink
	or		%00000010						; set red ink

	; pap from c
	and		%11000111						; clear pap
	or		c								; pap from c (old ink)
	pop		bc								; c back to counting

	ld		(de), a							; into render buf
	


RENDER_ATTR_BUF_ROW_5_LOOP_DONE_FLIP:
SKIP_GAP_5:
	inc		hl								; next block
	inc		de
	inc		c

	djnz	RENDER_ATTR_BUF_ROW_5_LOOP



	; hedge attrs
	ld		de, RENDER_ATTR_BUF_ROW_6
	ld		hl, BUILDING_ATTR_BUF + (WIN_COL_TOTAL * 3)
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_7
	ld		hl, BUILDING_ATTR_BUF + (WIN_COL_TOTAL * 4)
	ld		bc, WIN_COL_VIS
	ldir

	; building pixels

	ld		de, WINDOW_RENDER_PIXEL_BUF_BUILDINGS					; building pixel render buf
	ld		hl, BUILDINGS_LAYER_PIXEL_BUF							; building pixel layer buf

	ld		b, 3 * 8												; 3 building-only rows, 8 pixel row per block

BUILDING_PIXEL_OR_LOOP:
	push	bc											; outer loop

	ld		b, WIN_COL_VIS
BUIDLING_PIXEL_OR_ROW_LOOP:
	ld		a, (de)										; existing mountain pixels from render layer
	ld		c, a										; save in c
	ld		a, (hl)										; building pixels
	xor		c											; put them together XOR
	ld		(de), a										; save back to render pixels

	inc		de											; next byte
	inc		hl

	djnz	BUIDLING_PIXEL_OR_ROW_LOOP

	inc		hl											; over the extra col
	pop		bc											; outer loop
	djnz	BUILDING_PIXEL_OR_LOOP




	; hedge pixels - just ldir
	ld		de, WINDOW_RENDER_PIXEL_BUF_HEDGE	; de render hedge bef
	ld		hl, HEDGE_LAYER_PIXEL_BUF			; hl layer hedge buf

	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_1
	inc		hl							; step over extra col
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_2
	inc		hl							; step over extra col
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_3
	inc		hl							; step over extra col
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_4
	inc		hl							; step over extra col
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_5
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_6
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 6_7
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	
										; de correctly inc'd already: 7_0
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_1
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_2
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_3
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_4
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_5
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_6
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

										; de correctly inc'd already: 7_7
	inc		hl							; step over extra col 
	ld		bc, WIN_COL_VIS				; only copy visible
	ldir	

	ret									; BUILDINGS_LAYER_TO_RENDER




BUILDINGS_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * 3 * 8				; 3 of 5 WIN_BUILDING_ROWS are buildings
HEDGE_LAYER_PIXEL_BUF:	
	defs		(WIN_COL_VIS+1) * 2 * 8				; 2 of 5 WIN_BUILDING_ROWS are hedges

NEXT_BUILDING_COL:
	defw	0
	
CHAR_TO_BUF:
	defb	0
	
ATTR_TO_BUF:
	defb	0

BUILD_ATTR_TO_BUF:
	defb	0

