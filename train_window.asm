; udgs etc
	INCLUDE "train_window_data.asm"
	
SETUP_WINDOW:
	call	SETUP_CLOUDS
	call	BUFFER_BUILDINGS		
	call	SETUP_FG
	ret								; SETUP_BUILDINGS

SETUP_CLOUDS:
	ld		b, WIN_CLOUD_ROWS * WIN_COL_TOTAL
	ld		c, C_SPACE				; everything is spaces
	ld		a, %00101111			; everything cyan pap, white ink
	ld		hl, CLOUD_CHAR_BUF
	ld		de, CLOUD_ATTR_BUF
SETUP_CLOUD_LOOP:
	ld		(hl), c
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_CLOUD_LOOP
	ret								; SETUP_CLOUDS

SETUP_FG:
	ld		b, WIN_FG_ROWS * WIN_COL_TOTAL
	ld		c, C_SPACE				; everything is spaces
	ld		a, %01100000			; everything bright, green pap, black ink
	ld		hl, FG_CHAR_BUF
	ld		de, FG_ATTR_BUF
SETUP_FG_LOOP:
	ld		(hl), c
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_FG_LOOP
	ret								; SETUP_FG

ANIMATE_WINDOW:
	call	ANIMATE_CLOUDS
	call	ANIMATE_BUILDINGS
	call	ANIMATE_FG
	ret								; ANIMATE_WINDOW

ANIMATE_CLOUDS:
	ret								; ANIMATE_CLOUDS

ANIMATE_BUILDINGS:
	call	SHIFT_BUILDINGS_LEFT								
	ld		de, (NEXT_BUILDING_COL)	; move col left
	dec		de
	ld		(NEXT_BUILDING_COL), de
	ld		a, (NEXT_BUILDING_COL)	; check if extra buff empty
	cp		WIN_COL_VIS+1			
	call	m, BUFFER_BUILDINGS		; call BUFFER_BUILDINGS if need to
	ret								; ANIMATE_BUILDINGS

ANIMATE_FG:
	ret								; ANIMATE_FG

SHIFT_BUILDINGS_LEFT:				; unrolled for speed, honest!
	; chars
	ld		de, CHAR_BUF_ROW_3		; target
	ld		hl, CHAR_BUF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_4		; target
	ld		hl, CHAR_BUF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_5		; target
	ld		hl, CHAR_BUF_ROW_5 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_6		; target
	ld		hl, CHAR_BUF_ROW_6 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_7		; target
	ld		hl, CHAR_BUF_ROW_7 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	
	; attrs
	ld		de, ATTR_BUF_ROW_3		; target
	ld		hl, ATTR_BUF_ROW_3 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_4		; target
	ld		hl, ATTR_BUF_ROW_4 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_5		; target
	ld		hl, ATTR_BUF_ROW_5 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_6		; target
	ld		hl, ATTR_BUF_ROW_6 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_7		; target
	ld		hl, ATTR_BUF_ROW_7 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	
	ret								; SHIFT_BUILDINGS_LEFT

BUFFER_BUILDINGS:
	call	RNG						; rng in a
	ld		(NEXT_BUILDING), a		; NEXT_BUILDING is now rng

	ld		a, %00010000			; mask for type, only need one bit
	and		(hl)					; get type from generated next building

	cp		%00000000				; 50/50
	call	z, ADD_GAP				; bit not set, gap, 50/50
	call	nz, ADD_BUILDING		; bit set, building, 50/50
	
	ld		a, WIN_COL_VIS+1		; have we filled the buffer? 
									; +1 as needed or pixel-by-pixel shift
									; so make consistent
	ld		hl, NEXT_BUILDING_COL
	cp		(hl)
	call	p, BUFFER_BUILDINGS		; branch if positive
									; something in buffer 
	ret								; BUFFER_BUILDINGS

BLANK_BUILDING_WIN_COL						; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld		(CHAR_TO_BUF), a
	ld		a, ATTR_CYN_PAP			; sky is cyan
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROW_START + 1	; index from 1...
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 2
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 3
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 4
	call	BUF_ROW_AT_COL			

	ld		b, WIN_BUILDING_ROW_START + 5
	call	BUF_ROW_AT_COL			

	ret								; BLANK_WIN_COL

ADD_GAP:							; which onetype from other bits in NEXT_BUILDING
	push	af						; preserve for outer jumps
	
	ld		a, %00001000			; use high from bh as it's not used for gaps
	ld		hl, NEXT_BUILDING
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
	ld		hl, NEXT_BUILDING
	and		(hl)					; now only those bits set from rng

	cp		%00000000				; 50/50
	call	z, ADD_FENCE_GAP		; bit not set, simple gap, 50/50
	call	nz, ADD_HEDGE_GAP		; bit set, other gap, 50/50
	ret								; ADD_OTHER_GAP

ADD_FENCE_GAP:
	push	af						; preserve for outer logic













; load e width
	ld		hl, NEXT_BUILDING
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
	ld		b, e					; for each column...

ADD_FENCE_COL_LOOP:
	push	bc
	call	BLANK_BUILDING_WIN_COL	; clear first
	ld      a, (BUILD_ATTR_TO_BUF)	; BLANK_WIN_COL trashes attrs
	ld		(ATTR_TO_BUF), a

	ld		b, WIN_BUILDING_ROW_START + 5	; bottom row (copied from BLANK_BUILDING_WIN_COL)
	ld		a, UDG_FENCE			; fence udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL			; buf it

	ld		bc, (NEXT_BUILDING_COL)	; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	pop		bc
	djnz	ADD_FENCE_COL_LOOP
	









	pop		af						; restore for outer logic
	ret								; ADD_SIMPLE_GAP

ADD_HEDGE_GAP:
	ret								; ADD_SIMPLE_GAP


ADD_BUILDING:
; load d height, e width
	ld		a, %00001100
	ld		hl, NEXT_BUILDING
	and		(hl)					; now a is 0000 - 0300
	rra								; shift right twice
	rra
	inc		a						; inc twice so 2-5
	inc		a
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

	ld		a, WIN_BUILDING_ROW_END + 2	; +2 for index from 1 in two ways...
	sub		b						; then height
	ld		b, a					; into b for call
	ld		a, UDG_BUILDING			; building udg in a
	ld		(CHAR_TO_BUF), a

	call	BUF_ROW_AT_COL			; buf it
	pop		bc						; restore bc
	djnz	ADD_BULDING_ROW_LOOP
	
	ld		bc, (NEXT_BUILDING_COL)	; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	pop		bc
	djnz	ADD_BULDING_COL_LOOP
	
	ret								; ADD_BUILDING

BUF_ROW_AT_COL:						; b row 1-10 (bjnz means can't 0 index...)
	push	de						; don't trash de
	push	bc						; looping again so preserve bc

	dec		b
	
	ld		hl, (NEXT_BUILDING_COL)
	ld		a, b
	cp 		0
	jr		z, BUF_ROW_READY
	ld		de, WIN_COL_TOTAL
BUF_ROW_AT_COL_LOOP:
	add		hl, de					; move down a row
	djnz	BUF_ROW_AT_COL_LOOP		; until correct row
BUF_ROW_READY:						; hl is common offset
	pop		bc						; loop done restore

	ld		de, hl					; de is common offset

; char
	ld		hl, CHAR_BUF
	add		hl, de	
	ld		a, (CHAR_TO_BUF)
	ld		(hl), a					; buf char

; attr	
	ld		hl, ATTR_BUF	
	add		hl, de	
	ld		a, (ATTR_TO_BUF)
	ld		(hl), a					; buf attr
	
	pop		de					
	ret								; BUF_ROW_AT_COL
	
LOAD_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS_PIXELS			; my UDGs
	ld		bc, NUM_UDGS * 8		; loop
	ldir
	ret								; LOAD_UDGS
  

; uses first 8KiB ROM for pseudo, retuns in a
RNG: 								
	ld		hl,(SEED)        		 
    ld		a,h
    and		$1F              		; keep it within first 8k of ROM.
    ld		h,a
    ld		a,(hl)           		; Get "random" number from location.
    inc		hl              		; Increment pointer.
    ld		(SEED),hl
    ret								; RNG

; data
SEED:
	defw	23						; seed 23 fnord
	
NEXT_BUILDING:						; ic bt bh bw 
									; ic = ink colour (blk, blue, red, mag)
									; bt - building type (50/50 gap/building)
									; bh - building height 2-5 - single UDG for now
									; bw - building width 1-4
	defb	0
	
NEXT_BUILDING_COL:
	defw	0
	
CHAR_BUF_INDEX_ADDR:
	defw	0
	
ATTR_BUF_INDEX_ADDR:
	defw	0

ATTR_SCR_INDEX_ADDR:
	defw	0

CHAR_TO_BUF:
	defb	0
	
ATTR_TO_BUF:
	defb	0

BUILD_ATTR_TO_BUF:
	defb	0
