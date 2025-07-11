

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
	ld		(hl), d
	ld		hl, FG_ATTR_BUF + WIN_COL_TOTAL + WIN_COL_VIS -1 ; lower last
	ld		(hl), d

; chars
	ld		a, (FG_COUNTER)				; only a likes (defb) loads
	ld		d, 0
	ld		e, a						; into de

	; make high pole pixels
	ld		a, %00011000				; vertical pole 
	ld		b, %00111100				; crossbar
	ld		c, %01111110				; crossbar
	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; 8 byte buf
	ld		(hl), a						; 0
	inc		hl
	ld		(hl), a						; 1
	inc		hl
	ld		(hl), b						; 2
	inc		hl
	ld		(hl), a						; 3
	inc		hl
	ld		(hl), a						; 4
	inc		hl
	ld		(hl), c						; 5
	inc		hl
	ld		(hl), a						; 6
	inc		hl
	ld		(hl), a						; 7

	; make high pole pixels
	ld		hl, SINGLE_CHAR_PIXEL_BUF_2	; 8 byte buf
	ld		(hl), a						; 0
	inc		hl
	ld		(hl), a						; 1
	inc		hl
	ld		(hl), a						; 2
	inc		hl
	ld		(hl), a						; 3
	inc		hl
	ld		(hl), a						; 4
	inc		hl
	ld		(hl), a						; 5
	inc		hl
	ld		(hl), a						; 6
	inc		hl
	ld		(hl), a						; 7

	; find pole location
	ld		hl, FG_CHAR_LUT				; points to start of LUT
	add		hl, de						; hl points to col value in LUT
	push	hl							; for the undraw later
	ld		a, (hl)						; a is the col to draw
	ld		b, 0
	ld		c, a						; bc is also col to draw for 16-bit math
	cp		255							; is it 255?
	jr		z, DRAW_POLE_DONE			; if it's 255, don't draw

	; draw pole high
	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; call trashes it so have to reload every time
	ld		ix, FG_LAYER_PIXEL_BUF 		; first row
	add		ix, bc						; add column offset
	call	BUF_CHAR_PIXELS_VIS			; buf it

	; draw pole low
	ld		hl, SINGLE_CHAR_PIXEL_BUF_2	; call trashes it so have to reload every loop
	ld		ix, FG_LAYER_PIXEL_BUF + (WIN_COL_VIS * 8)		; second row
	add		ix, bc						; add column offset
	call	BUF_CHAR_PIXELS_VIS			; buf it

DRAW_POLE_DONE:
	; make blank pixels
	ld		a, %00000000				; blank
	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; 8 byte buf
	ld		(hl), a						; 0
	inc		hl
	ld		(hl), a						; 1
	inc		hl
	ld		(hl), a						; 2
	inc		hl
	ld		(hl), a						; 3
	inc		hl
	ld		(hl), a						; 4
	inc		hl
	ld		(hl), a						; 5
	inc		hl
	ld		(hl), a						; 6
	inc		hl
	ld		(hl), a						; 7

; clear old pole
	pop		hl							; get back draw LUT index
	dec		hl							; points to previous LUT value (using special -1 index for index 0)
	ld		a, (hl)						; a is the col to draw
	ld		b, 0
	ld		c, a						; bc is also col to draw for 16-bit math
	cp		255							; is it 255? 
	jr		z, UNDRAW_POLE_DONE			; if it's 255, don't undraw

	; undraw draw pole high
	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; call trashes it so have to reload every time
	ld		ix, FG_LAYER_PIXEL_BUF 		; first row
	add		ix, bc						; add column offset
	call	BUF_CHAR_PIXELS_VIS			; buf it

	; undraw draw pole low
	ld		hl, SINGLE_CHAR_PIXEL_BUF_1	; call trashes it so have to reload every loop
	ld		ix, FG_LAYER_PIXEL_BUF + (WIN_COL_VIS * 8)		; second row
	add		ix, bc						; add column offset
	call	BUF_CHAR_PIXELS_VIS			; buf it

UNDRAW_POLE_DONE:
; inc counter
	ld		a, (FG_COUNTER)				; only a likes (defb) loads
	inc		a
	cp		FG_CHAR_MAP_SIZE 			; as we past the end of our LUT?
	jr		nz, ANIMATE_FG_INC_DONE
	xor		a							; quicker and smaller than ld a, 0 :)
ANIMATE_FG_INC_DONE:
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

	ret									; FG_LAYER_TO_RENDER


FG_LAYER_PIXEL_BUF:
	defs		WIN_COL_VIS * WIN_FG_ROWS * 8
	
FG_COUNTER:
	defb	0

; counter is index to which column to 'draw' in
; (it's actuall attr flipping)
; to not draw, we 'draw' in offscreen buffer (saves lots of conditionals)
; counter-1 is where to clear (counter reset to zero special case, we cheat and don't need to undraw)
FG_CHAR_MAP_SIZE	= 14	; doesn't need to be round! 

; special "-1" LUT value, must be same as final in list, makes undraw easier
	defb	255		; count=-1, same as final in LUT

FG_CHAR_LUT:
	defb	255		; count=0 - 255 means nothing showing
	defb	255		; count=1 - 255 means nothing showing
	defb	255		; count=2 - 255 means nothing showing
	defb	255		; count=3 - 255 means nothing showing
	defb	255		; count=4 - 255 means nothing showing
	defb	255		; count=5 - 255 means nothing showing
	defb	18		; count=6, appears on far right
	defb	15		; count=7, moved 3 to the left
	defb	12		; count=8, moved 3 to the left
	defb	9		; count=9, moved 3 to the left
	defb	6		; count=10, moved 3 to the left
	defb	3		; count=11, moved 3 to the left
	defb	0		; count=12, moved 3 to the left
	defb	255		; count=13, 255 means nothing showing


