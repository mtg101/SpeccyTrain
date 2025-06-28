ADD_GAP:							; which onetype from other bits in NEXT_BUILDING
	push	af						; preserve for outer jumps
	
	ld		a, %00001000			; use high from bh as it's not used for gaps
	ld		hl, NEXT_RNG
	and		(hl)					; now only those bits set from rng

	cp		%00000000				; 50/50
	call	z, ADD_SIMPLE_GAP		; bit not set, simple gap, 50/50
	call	nz, ADD_OTHER_GAP		; bit set, other gap, 50/50

	pop		af						; restore for outer jumps
	ret								; ADD_GAP

ADD_SIMPLE_GAP:
	push	af						; preserve for outer logic
	call	BLANK_BUILDING_WIN_COL	; clear gap
	ld		de, (NEXT_BUILDING_COL)	; move to next column
	inc		de
	ld		(NEXT_BUILDING_COL), de
	pop		af						; restore for outer logic
	ret								; ADD_SIMPLE_GAP

ADD_OTHER_GAP:
	ld		a, %00000100			; use low from bh as it's not used for gaps
	ld		hl, NEXT_RNG
	and		(hl)					; now only those bits set from rng

	cp		%00000000				; 50/50
	call	z, ADD_FENCE_GAP		; bit not set, simple gap, 50/50
	call	nz, ADD_HEDGE_GAP		; bit set, other gap, 50/50
	ret								; ADD_OTHER_GAP

ADD_FENCE_GAP:
	push	af						; preserve for outer logic
; load e width
	ld		hl, NEXT_RNG
	ld		a, %00000011
	and		(hl)					; now a is 0-3 
	inc		a						; now a is 1-4
	ld		e, a					; e=width

; ink color attr
	ld		a, UDG_FENCE_ATTR		; base black
	ld		(BUILD_ATTR_TO_BUF), a

	ld		a, %11000000			; color bits
	and		(hl)					; next building rng
	cp		0						; 1 in 4 change it's white
	jr		nz, GOT_FENCE_COLOUR	; it's not white, stick with black
	ld		a, UDG_FENCE_ATTR		; base black ink
	or		a, %00000111			; make white
	ld		(BUILD_ATTR_TO_BUF), a
GOT_FENCE_COLOUR:
; for each column...
	ld		b, e					
ADD_FENCE_COL_LOOP:
	push	bc
	call	BLANK_BUILDING_WIN_COL	; clear first
	ld      a, (BUILD_ATTR_TO_BUF)	; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1; bottom row 
	ld		a, UDG_FENCE			; fence udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL			; buf it

	ld		bc, (NEXT_BUILDING_COL)	; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	pop		bc
	djnz	ADD_FENCE_COL_LOOP		; for each column
	
	pop		af						; restore for outer logic
	ret								; ADD_SIMPLE_GAP

ADD_HEDGE_GAP:
; ink color attr
	ld		a, UDG_HEDGE_ATTR		; default green on cyan
	ld		(BUILD_ATTR_TO_BUF), a

	ld		a, %11000000			; color bits
	and		(hl)					; next building rng
	cp		0						; 1 in 4 change it's magenta
	jr		nz, GOT_HEDGE_COLOUR	; it's not magenta, stick with green
	ld		a, UDG_HEDGE_ATTR		; default green on cyan
	or		a, %00000011			; make magenta
	and		a, %11111011
	ld		(BUILD_ATTR_TO_BUF), a

GOT_HEDGE_COLOUR:
; which shape hedge? from width as height used to fence v hedge
	ld		a, %00000011
	ld		hl, NEXT_RNG
	and		(hl)					; now a is 0000 - 0300

	cp		0						; case 0:
	jr		z, ADD_HEDGE_1x1
	cp		1						; case 1:
	jr		z, ADD_HEDGE_1x2
	cp		2						; case 2:
	jp		z, ADD_HEDGE_2x1

; falls through to last case to save a cp
ADD_HEDGE_2x2:
	call	BLANK_BUILDING_WIN_COL			; clear first
	ld      a, (BUILD_ATTR_TO_BUF)			; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1		; bottom row
	ld		a, UDG_HEDGE_CLOUD_2x2_BL		; BL udg in a
	ld		(CHAR_TO_BUF), a
	call	BUF_ROW_AT_COL					; buf it

	ld		a, UDG_HEDGE_CLOUD_2x2_TL		; TL udg in a
	ld		(CHAR_TO_BUF), a
	dec		b								; above trunk
	call	BUF_ROW_AT_COL					; buf it

	ld		bc, (NEXT_BUILDING_COL)			; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc

	call	BLANK_BUILDING_WIN_COL			; clear first
	ld      a, (BUILD_ATTR_TO_BUF)			; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1		; bottom row 
	ld		a, UDG_HEDGE_CLOUD_2x2_BR		; BR udg in a
	ld		(CHAR_TO_BUF), a
	call	BUF_ROW_AT_COL					; buf it

	ld		a, UDG_HEDGE_CLOUD_2x2_TR		; TR udg in a
	ld		(CHAR_TO_BUF), a
	dec		b								; above trunk
	call	BUF_ROW_AT_COL					; buf it

	ld		bc, (NEXT_BUILDING_COL)			; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	ret								; ADD_HEDGE_GAP - yes, each hedge size routines returns main routine

ADD_HEDGE_1x1:
	call	BLANK_BUILDING_WIN_COL			; clear first
	ld      a, (BUILD_ATTR_TO_BUF)			; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1		; bottom row 
	ld		a, UDG_HEDGE_CLOUD_1x1			; hedge udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL					; buf it

	ld		bc, (NEXT_BUILDING_COL)			; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	ret								; ADD_HEDGE_GAP - yes, each hedge size routines returns main routine

ADD_HEDGE_1x2:
	call	BLANK_BUILDING_WIN_COL			; clear first
	ld      a, (BUILD_ATTR_TO_BUF)			; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1		; bottom row
	ld		a, UDG_HEDGE_CLOUD_1x2_L		; hedge udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL					; buf it

	ld		bc, (NEXT_BUILDING_COL)			; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc

	call	BLANK_BUILDING_WIN_COL			; clear first
	ld      a, (BUILD_ATTR_TO_BUF)			; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1		; bottom row
	ld		a, UDG_HEDGE_CLOUD_1x2_R		; hedge udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL					; buf it

	ld		bc, (NEXT_BUILDING_COL)			; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	ret								; ADD_HEDGE_GAP - yes, each hedge size routines returns main routine

ADD_HEDGE_2x1:
	call	BLANK_BUILDING_WIN_COL			; clear first
	ld      a, (BUILD_ATTR_TO_BUF)			; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROWS - 1		; bottom row
	ld		a, UDG_HEDGE_CLOUD_2x1_B		; tree trunk udg in a
	ld		(CHAR_TO_BUF), a
	call	BUF_ROW_AT_COL					; buf it

	ld		a, UDG_HEDGE_CLOUD_2x1_T		; tree top udg in a
	ld		(CHAR_TO_BUF), a
	dec		b								; above trunk
	call	BUF_ROW_AT_COL					; buf it

	ld		bc, (NEXT_BUILDING_COL)			; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	ret								; ADD_HEDGE_GAP - yes, each hedge size routines returns main routine

