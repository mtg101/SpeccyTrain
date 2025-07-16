

SETUP_FG:
; attrs
	ld		b, WIN_FG_ROWS * WIN_COL_TOTAL
	ld		a, %01100000			; everything bright black ink green pap
	ld		de, FG_ATTR_BUF
SETUP_FG_ATTRS_LOOP:
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_FG_ATTRS_LOOP

; chars are blank to start - FG_LAYER_PIXEL_BUF sets 0 when setup in draw-window.asm

	ret								; SETUP_FG

; animate by flipping attrs to show | characters, based on LUT
ANIMATE_FG:
; attrs

	; shift visible left 2
	ld		bc, WIN_COL_VIS - 2					; only shifting visible bits
	ld		hl, FG_ATTR_BUF + 2					; first row
	ld		de, FG_ATTR_BUF						; move by 2
	ldir										; do it

	ld		bc, WIN_COL_VIS - 2					; only shifting visible bits
	ld		hl, FG_ATTR_BUF + WIN_COL_TOTAL + 2	; second row
	ld		de, FG_ATTR_BUF + WIN_COL_TOTAL		; move by 2
	ldir										; do it

	; decide river (1 in 64) or grass
	ld		d, %01001000			; assume river (avoids jump if it's the more common grass)

	call	RNG						; change (NEXT_RNG)
	ld		a, (NEXT_RNG)			; building / clouds changed rng since last frame
	and		%00111111 				; 0-63
	cp 		%00111111 				; is it 1 in 64?
 	jr		z, ANIMATE_FG_ATTR_GOT	; z = river ; nz grass
	ld		d, %01100000			; grass, and fall through...
ANIMATE_FG_ATTR_GOT:

	; add those to attr buff...
	ld		hl, FG_ATTR_BUF + WIN_COL_VIS - 2	; upper penultimate vis
	ld		(hl), d						
	ld		hl, FG_ATTR_BUF + WIN_COL_VIS - 1	; upper last vis
	ld		(hl), d
	ld		hl, FG_ATTR_BUF + WIN_COL_TOTAL + WIN_COL_VIS - 2 ; lower penultimate vis
	ld		(hl), %01100000						
	ld		hl, FG_ATTR_BUF + WIN_COL_TOTAL + WIN_COL_VIS -1 ; lower last
	ld		(hl), %01100000

; pixels

; clear old chars with LDIR trick
	ld		hl, FG_LAYER_PIXEL_BUF		
	ld		(hl), 0						; manually set first byte to 0
	ld		de, FG_LAYER_PIXEL_BUF+1	; already cleard first byte
	ld		bc, (WIN_COL_VIS * WIN_FG_ROWS * 8) -1 ; -1 as we did first byte by hand
	ldir								; copies the manual zero to +1, then incs so copies +1 0 to +2, etc

; where is pole?
	ld		a, (FG_COUNTER)				; 0-8
	ld		c, a						; into c for accumulator fiddling
	add		a, c						; x2
	add		a, c						; x3 (moving 3 cols at a time)
	ld		c, a						; c is now pole position (lol) (0-24)
										; aka distance from current col to pole
										; decrements as we move across cols

	ld		de, 0						; current col position
	ld		b, WIN_COL_VIS				; for each visible column
FG_POLE_WIRE_LOOP:
	ld		a, c						; distance into a
	cp		0
	jr		nz, FG_POLE_WIRE_LOOP_NOT_POLE
	; it's the pole

	; draw pole high
	push	de
	ld		hl, FG_POLE_HIGH			; call trashes it so have to reload every time
	ld		ix, FG_LAYER_PIXEL_BUF 		; first row
	add		ix, de						; add column offset
	call	BUF_CHAR_PIXELS_VIS			; buf it
	pop		de

	; draw pole low
	push	de
	ld		hl, FG_POLE_LOW				; call trashes it so have to reload every loop
	ld		ix, FG_LAYER_PIXEL_BUF + (WIN_COL_VIS * 8)		; second row
	add		ix, de						; add column offset
	call	BUF_CHAR_PIXELS_VIS			; buf it
	pop		de
	
	ld		c, FG_POLE_MAX_DIST			; set to max distance for next loop

	jr		FG_POLE_WIRE_LOOP_DONE		; skip to next loop


FG_POLE_WIRE_LOOP_NOT_POLE:
	ld		ix, FG_LAYER_PIXEL_BUF
	add		ix, de						; ix points to first byte of col

	; depending on distance

	; 1-3 high
	; 4-8 med
	; 9-16: low
	; 17-21: med
	; 22-24: high

	; high pixel matches long pole crossbar: offset 3
	; mid is therefore offset 4,  low 5







   	dec		c							; we're 1 closer to the pole in next col

FG_POLE_WIRE_LOOP_DONE:
	inc		de							; next col to draw to
	djnz	FG_POLE_WIRE_LOOP

DRAW_POLE_DONE:
; dec counter
	ld		a, (FG_COUNTER)				; only a likes (defb) loads
	cp		0				 			; as we on last frame?
	jr		nz, ANIMATE_FG_DEC_COUNTER
	ld		a, FG_COUNTER_MAX			; reset counter
	jr		ANIMATE_FG_DONE				; skip over dec

ANIMATE_FG_DEC_COUNTER:
	dec		a

ANIMATE_FG_DONE:
	ld		(FG_COUNTER), a				; store counter back to memory
	call	FG_LAYER_TO_RENDER			; copy to render buf

	ret									; ANIMATE_FG


FG_LAYER_TO_RENDER:
	; attrs
	ld		de, RENDER_ATTR_BUF_ROW_8
	ld		hl, FG_ATTR_BUF
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_9
	ld		hl, FG_ATTR_BUF + WIN_COL_TOTAL
	ld		bc, WIN_COL_VIS
	ldir

	; pixels
	ld		de, WINDOW_RENDER_PIXEL_BUF_FG		; start of pixel render buf
	ld		hl, FG_LAYER_PIXEL_BUF				; start of layer buf
	ld		bc, WIN_COL_VIS * WIN_FG_ROWS * 8	; copy all at once
	ldir										; copy over

	ret											; FG_LAYER_TO_RENDER


FG_LAYER_PIXEL_BUF:
	defs		WIN_COL_VIS * WIN_FG_ROWS * 8
	

FG_COUNTER_MAX = 8							; 9 frames, 0-8
FG_POLE_MAX_DIST = FG_COUNTER_MAX * 3		; poles move 3 blocks at a time
FG_COUNTER:
	defb	FG_COUNTER_MAX

FG_POLE_HIGH:
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%11111111
	defb	%00011000
	defb	%00111100
	defb	%00011000
	defb	%00011000

FG_POLE_LOW:
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
