

ANIMATE_WINDOW_TUNNEL:
	; status
	ld 		a, (ANIMATE_WINDOW_TUNNEL_STATUS)
	
	cp		2
	jr		z, ANIMATE_WINDOW_TUNNEL_2
	cp		1
	jr		z, ANIMATE_WINDOW_TUNNEL_1

	; anything else is 0 / off

ANIMATE_WINDOW_TUNNEL_0:			; tunnel off
	; don't draw

	; rng chance turn on
	call	RNG
	ld		hl, (NEXT_RNG)			; 16-bit

	ld 		a, l					; hack 1 in 256 for testing
									; todo make 1 in 1024 and tweak
	cp		0
	ret		nz						; no changing, we're done
									; ANIMATE_WINDOW_TUNNEL

	; we are turning on!

	; status becomes 1
	ld 		a, 1
	ld		(ANIMATE_WINDOW_TUNNEL_STATUS), a

	; all offscreen bufs set to 0 black on black
	ld		a, %00000000
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + WIN_COL_VIS), a

	; fall through and draw as we've just turned on

ANIMATE_WINDOW_TUNNEL_1:			; tunnel on
	; draw
	call	ANIMATE_WINDOW_TUNNEL_SHIFT_AND_DRAW

	; are we done?
	; rng chance turn off 
	call	RNG
	ld		hl, (NEXT_RNG)			; 16-bit

	ld 		a, l					; 1 in 128
	and		%01111111
	cp		0
	ret		nz						; no changing, we're done
									; ANIMATE_WINDOW_TUNNEL

	; we are turning off!

	; status becomes 2
	ld 		a, 2
	ld		(ANIMATE_WINDOW_TUNNEL_STATUS), a

	; all offscreen bufs set to alpha $FF
	ld		a, $FF
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + WIN_COL_VIS), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + WIN_COL_VIS), a

	; set countdown timer
	ld		a, WIN_COL_VIS
	ld		(ANIMATE_WINDOW_TUNNEL_COUNTER), a

	ret								; we're done ANIMATE_WINDOW_TUNNEL

ANIMATE_WINDOW_TUNNEL_2:			; tunnel turning off
	; draw
	call	ANIMATE_WINDOW_TUNNEL_SHIFT_AND_DRAW

	; check counter
	ld		a, (ANIMATE_WINDOW_TUNNEL_COUNTER)
	cp		0
	jr		nz, ANIMATE_WINDOW_TUNNEL_2_CONTINUE	; are we done?

	; counter at zero, we're done
	; status becomes 0
	ld		(ANIMATE_WINDOW_TUNNEL_STATUS), a
	ret									; ANIMATE_WINDOW_TUNNEL

ANIMATE_WINDOW_TUNNEL_2_CONTINUE
	; dec counter
	dec		a
	ld		(ANIMATE_WINDOW_TUNNEL_COUNTER), a

	ret									; ANIMATE_WINDOW_TUNNEL


ANIMATE_WINDOW_TUNNEL_SHIFT_AND_DRAW
	; shift all rows left
	; off screen buf is alredy set to 0 when tunnel on, 255 alpha when stopping
	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + 1
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + 1
	ld		bc, WIN_COL_VIS
	ldir

	; top of bottle over screen
	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + 16
	ld		a, (de)
	ld		c, a						; store in c for later
	cp		$FF							; is it alpha?
	jr		z, ANIMATE_WINDOW_BOTTLE_SKIP_ON

	; it's not alpha - so set to blue ink black pap for bottle
	ld		a, %00000001
	ld		(de), a

ANIMATE_WINDOW_BOTTLE_SKIP_ON:

	push	bc
	call	ANIMATE_WINDOW_TUNNEL_TO_RENDER
	pop		bc

	; clear top of bottle over screen
	ld		a, c						; get for alpha check
	cp		$FF							; is it alpha?
	jr		z, ANIMATE_WINDOW_BOTTLE_SKIP_OFF

	ld		a, %00000000				; back to black on black
	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + 16
	ld		(de), a						; retore it
ANIMATE_WINDOW_BOTTLE_SKIP_OFF:	

	ret									; ANIMATE_WINDOW_TUNNEL_ATTR_BUFFER


ANIMATE_WINDOW_TUNNEL_TO_RENDER:
	ld		de, WINDOW_RENDER_ATTR_BUF
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF


	ld		b, WIN_ROW_TOTAL
ANIMATE_WINDOW_TUNNEL_TO_RENDER_ROW_LOOP:
	push	bc							; loop vars

	ld		b, WIN_COL_VIS
ANIMATE_WINDOW_TUNNEL_TO_RENDER_COL_LOOP:
	ld		a, (hl)
	cp		$FF							; is it alpha channel?
	jr		z, 	ANIMATE_WINDOW_TUNNEL_TO_RENDER_LOOP_NEXT

	; not alpha, so write
	ld		(de), a

ANIMATE_WINDOW_TUNNEL_TO_RENDER_LOOP_NEXT:
	inc		de
	inc		hl

	djnz	ANIMATE_WINDOW_TUNNEL_TO_RENDER_COL_LOOP

	inc		hl							; step over offscreen buf
	pop		bc							; loop vars

	djnz	ANIMATE_WINDOW_TUNNEL_TO_RENDER_ROW_LOOP

	ret											; FG_LAYER_TO_RENDER


ANIMATE_WINDOW_TUNNEL_ATTR_BUF:
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9:
	defs		WIN_COL_VIS+1, $FF	; all the alpha channel value


ANIMATE_WINDOW_TUNNEL_COUNTER:
	defb	0

ANIMATE_WINDOW_TUNNEL_STATUS:
	defb	0
