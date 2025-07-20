

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
	ld		a, (NEXT_RNG)
	cp		0						; 1 in 256
	ret		nz						; no changing, we're done
									; ANIMATE_WINDOW_TUNNEL

	; we are turning on!

	; status becomes 1
	ld 		a, 1
	ld		(ANIMATE_WINDOW_TUNNEL_STATUS), a

	; counter for light
	ld		a, LIGHT_COUNTER_MAX
	ld		(ANIMATE_WINDOW_TUNNEL_COUNTER), a


	; fall through and draw as we've just turned on

ANIMATE_WINDOW_TUNNEL_1:			; tunnel on
	; draw
	call	ANIMATE_WINDOW_TUNNEL_SHIFT_AND_DRAW

	; are we done?
	; rng chance turn off 
	call	RNG
	ld		a, (NEXT_RNG)
	and		%00111111				; 1 in 64
	cp		0
	ret		nz						; no changing, we're done
									; ANIMATE_WINDOW_TUNNEL

	; we are turning off!

	; status becomes 2
	ld 		a, 2
	ld		(ANIMATE_WINDOW_TUNNEL_STATUS), a

	; set countdown timer
	ld		a, 5					; 4 blocks at a time, 5 does 20, more than WIN_COL_VIS
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
	; shift all rows 4 left
	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	ld		de, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9
	ld		hl, ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + 4
	ld		bc, WIN_COL_VIS - 4
	ldir

	; black or alpha?

	; light
	ld		c, %00000000				; default black on black

	ld		a, (ANIMATE_WINDOW_TUNNEL_STATUS)
	cp		1							; only do light when on
	jr		nz, ANIMATE_WINDOW_TUNNEL_GOT_LIGHT

	ld		a, (ANIMATE_WINDOW_TUNNEL_COUNTER)
	cp 		0							; light when counter is done
	dec 	a							; doesn't matter if goes neg, as on 0 we reset
	ld		(ANIMATE_WINDOW_TUNNEL_COUNTER), a
	jr		nz, ANIMATE_WINDOW_TUNNEL_GOT_LIGHT

	; light is on
	ld		c, %00110110				; yellow on yellow

	; reset counter
	ld		a, LIGHT_COUNTER_MAX
	ld		(ANIMATE_WINDOW_TUNNEL_COUNTER), a

ANIMATE_WINDOW_TUNNEL_GOT_LIGHT:

	; main color
	ld		a, (ANIMATE_WINDOW_TUNNEL_STATUS)
	cp      2							; is it stopping?
	ld		a, %00000000				; default black on black
	jr		nz, ANIMATE_WINDOW_TUNNEL_BLACK_SKIP

	; stopping so alpha for both
	ld		a, $FF
	ld		c, $FF

ANIMATE_WINDOW_TUNNEL_BLACK_SKIP:
	; 4 cols of that...
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + (WIN_COL_VIS - 2)), a
	ld 		b, a
	ld 		a, c
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + (WIN_COL_VIS - 3)), a	; light
	ld		a, b
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8 + (WIN_COL_VIS - 4)), a

	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + (WIN_COL_VIS - 1)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + (WIN_COL_VIS - 2)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + (WIN_COL_VIS - 3)), a
	ld		(ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9 + (WIN_COL_VIS - 4)), a

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

	ld		b, WIN_ROW_TOTAL * WIN_COL_VIS
ANIMATE_WINDOW_TUNNEL_TO_RENDER_LOOP:
	ld		a, (hl)
	cp		$FF							; is it alpha channel?
	jr		z, 	ANIMATE_WINDOW_TUNNEL_TO_RENDER_LOOP_NEXT

	; not alpha, so write
	ld		(de), a

ANIMATE_WINDOW_TUNNEL_TO_RENDER_LOOP_NEXT:
	inc		de
	inc		hl

	djnz	ANIMATE_WINDOW_TUNNEL_TO_RENDER_LOOP

	ret											; ANIMATE_WINDOW_TUNNEL_TO_RENDER

LIGHT_COUNTER_MAX		= 8

ANIMATE_WINDOW_TUNNEL_ATTR_BUF:
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_0:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_1:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_2:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_3:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_4:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_5:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_6:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_7:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_8:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value
ANIMATE_WINDOW_TUNNEL_ATTR_BUF_9:
	defs		WIN_COL_VIS, $FF	; all the alpha channel value


ANIMATE_WINDOW_TUNNEL_COUNTER:
	defb	0

ANIMATE_WINDOW_TUNNEL_STATUS:
	defb	0
