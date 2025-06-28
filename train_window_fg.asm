

SETUP_FG:
; attrs
	ld		b, WIN_FG_ROWS * WIN_COL_TOTAL
	ld		a, %01100100			; everything bright, green pap, green ink (flip attrs to make vis)
	ld		de, FG_ATTR_BUF
SETUP_FG_ATTRS_LOOP:
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_FG_ATTRS_LOOP

; chars
	ld		a, %00011000			; vertical pole 
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; 8 byte buf
	ld		(hl), a					; 0
	inc		hl
	ld		(hl), a					; 1
	inc		hl
	ld		(hl), a					; 2
	inc		hl
	ld		(hl), a					; 3
	inc		hl
	ld		(hl), a					; 4
	inc		hl
	ld		(hl), a					; 5
	inc		hl
	ld		(hl), a					; 6
	inc		hl
	ld		(hl), a					; 7

	ld		b, (WIN_COL_VIS+1) 		
	ld		ix, FG_LAYER_PIXEL_BUF		; first row
SETUP_FG_CHAR_LOOP_1:
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; call trashes it so have to reload every loop
	call	BUF_CHAR_PIXELS
	inc		ix
	djnz	SETUP_FG_CHAR_LOOP_1

	ld		b, (WIN_COL_VIS+1) 		
	ld		ix, FG_LAYER_PIXEL_BUF + ((WIN_COL_VIS+1) * 8)		; second row
SETUP_FG_CHAR_LOOP_2:
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; call trashes it so have to reload every loop
	call	BUF_CHAR_PIXELS
	inc		ix
	djnz	SETUP_FG_CHAR_LOOP_2

	ret								; SETUP_FG

; animate by flipping attrs to show | characters, based on LUT
ANIMATE_FG:
	ld		a, (FG_COUNTER)			; counter in a

; 'draw' new pole
	ld		e, a					; 16-buit adds
	ld		d, 0					

	ld		hl, FG_CHAR_LUT			; points to start of LUT
	add		hl, de					; hl points to col value in LUT
	ld		c, (hl)					; c is the col to draw
	ld		b, 0					; 17-bit adds

	ld		hl, FG_ATTR_BUF			; start of attr buffer
	add		hl, bc					; point to first row col
	ld		(hl), %01100000			; bright black on green 'draws' row 1
	ld		bc, WIN_COL_TOTAL		; skip down a row
	add		hl, bc
	ld		(hl), %01100000			; bright black on green 'draws' row 2

; clear old pole
	cp		0						; we don't need to clear if it's index 0 (cheaty tricks)
	jr		z, FG_CLEAR_POLE_DONE

	dec		e						; previous entry in LUT					
	ld		hl, FG_CHAR_LUT			; points to start of LUT
	add		hl, de					; hl points to col value in LUT
	ld		c, (hl)					; c is the col to draw
	ld		b, 0					; 17-bit adds

	ld		hl, FG_ATTR_BUF			; start of attr buffer
	add		hl, bc					; point to first row col
	ld		(hl), %01100100			; bright green on green clears row 1
	ld		bc, WIN_COL_TOTAL		; skip down a row
	add		hl, bc
	ld		(hl), %01100100			; bright green on green clears row 2
FG_CLEAR_POLE_DONE:

; inc counter
	inc		a
	cp		FG_CHAR_MAP_SIZE + 1	; as we past the end of our LUT?
	jr		nz, ANIMATE_FG_INC_DONE
	xor		a						; quicker and smaller than ld a, 0 :)
ANIMATE_FG_INC_DONE:
	ld		(FG_COUNTER), a			; store counter back to memory
	ret								; ANIMATE_FG

	
FG_COUNTER:
	defb	0

; counter is index to which column to 'draw' in
; (it's actuall attr flipping)
; to not draw, we 'draw' in offscreen buffer (saves lots of conditionals)
; counter-1 is where to clear (counter reset to zero special case, we cheat and don't need to undraw)
FG_CHAR_MAP_SIZE	= 14	; doesn't need to be round! 
FG_CHAR_LUT:
	defb	21		; count=0 - not showing, 21 is offscreen buf
	defb	21		; count=1 - not showing
	defb	21		; count=2 - not showing
	defb	21		; count=3 - not showing
	defb	21		; count=4 - not showing
	defb	21		; count=5 - not showing
	defb	18		; count=6, appears on far right
	defb	15		; count=7, moved 3 to the left
	defb	12		; count=8, moved 3 to the left
	defb	9		; count=9, moved 3 to the left
	defb	6		; count=10, moved 3 to the left
	defb	3		; count=11, moved 3 to the left
	defb	0		; count=12, moved 3 to the left
	defb	21		; count=13, final is always blank
					; so on count=0 we can just skip clearing, rather than having extra logic


