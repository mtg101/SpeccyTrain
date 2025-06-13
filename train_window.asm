; udgs etc
	INCLUDE "train_window_data.asm"
	
SETUP_BUILDINGS:
	call	BUFFER_BUILDINGS		; buffer based on the rng 
	ret								; SETUP_BUILDINGS

SHIFT_BUILDINGS_LEFT:				; unrolled for speed, honest!
	; chars
	ld		de, CHAR_BUF_ROW_0		; target
	ld		hl, CHAR_BUF_ROW_0 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_1		; target
	ld		hl, CHAR_BUF_ROW_1 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_2		; target
	ld		hl, CHAR_BUF_ROW_2 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
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
	ld		de, CHAR_BUF_ROW_8		; target
	ld		hl, CHAR_BUF_ROW_8 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, CHAR_BUF_ROW_9		; target
	ld		hl, CHAR_BUF_ROW_9 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	
	; attrs
	ld		de, ATTR_BUF_ROW_0		; target
	ld		hl, ATTR_BUF_ROW_0 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_1		; target
	ld		hl, ATTR_BUF_ROW_1 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_2		; target
	ld		hl, ATTR_BUF_ROW_2 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
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
	ld		de, ATTR_BUF_ROW_8		; target
	ld		hl, ATTR_BUF_ROW_8 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	ld		de, ATTR_BUF_ROW_9		; target
	ld		hl, ATTR_BUF_ROW_9 + 1	; source is one to the right
	ld		bc, WIN_COL_VIS			; move whole visible window
	ldir
	
	ret														; SHIFT_BUILDINGS_LEFT

DRAW_BUILDINGS:	
	ld		hl, CHAR_BUF_ROW_0
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_0
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_0
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_0
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW

	ld		hl, CHAR_BUF_ROW_1
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_1
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_1
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_1
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_2
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_2
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_2
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_2
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_3
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_3
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_3
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_3
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_4
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_4
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_4
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_4
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_5
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_5
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_5
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_5
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_6
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_6
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_6
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_6
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_7
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_7
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_7
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_7
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_8
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_8
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_8
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_8
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		

	ld		hl, CHAR_BUF_ROW_9
	ld		(CHAR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_BUF_ROW_9
	ld		(ATTR_BUF_INDEX_ADDR), hl
	ld		hl, ATTR_SCR_ROW_9
	ld		(ATTR_SCR_INDEX_ADDR), hl
	ld		hl, CHAR_AT_Y_9
	ld		(CHAR_AT_Y), hl
	call	DRAW_BUILDING_ROW		
	ret								; DRAW_BUILDINGS
	
	
DRAW_BUILDING_ROW:
; setcursot AT y, x
	ld		a, C_AT
	RST		$10						; AT
	ld		a, (CHAR_AT_Y)
	RST		$10						; y	
	ld		a, CHAR_AT_X
	RST		$10						; x
	
; ldir attrs
	ld		de, (ATTR_SCR_INDEX_ADDR)	; destination, screen mem, starting at base window attr
	ld		hl, (ATTR_BUF_INDEX_ADDR)	; source, attr buf
	ld		bc, WIN_COL_VIS			; count
	ldir

; hl needs the addr of the chars to RST, bc the attrs - hl pointing to chars to RST
	ld		hl, (CHAR_BUF_INDEX_ADDR)	; hl indexed into char bufs
	ld		b, WIN_COL_VIS
DRAW_BUILDING_ROW_OFFSET_LOOP:
	ld		a, (hl)					; load char
	RST		$10						; print
	inc		hl						; next char
	djnz	DRAW_BUILDING_ROW_OFFSET_LOOP
	
	ret								; DRAW_BUILDING_ROW

BUFFER_BUILDINGS:
	call	RNG						; rng in a
	ld		hl, NEXT_BUILDING		
	ld		(hl), a					; NEXT_BUILDING is now rng
	ld		a, %00110000			; mask for type
	ld		hl, NEXT_BUILDING
	and		(hl)					; get type from generated next building

	ld		d, a					; store type in d
	cp		%00000000				; gap?
	call	z, ADD_GAP
	ld		a, d					; type back in a
	cp		%00010000				; udg gap?
	call	z, ADD_UDG_GAP
	ld		a, d					; type back in a
	cp		%00100000				; building1?
	call	z, ADD_BUILDING
	ld		a, d					; type back in a
	cp		%00110000				; building2?
	call	z, ADD_BUILDING
	
	ld		a, WIN_COL_VIS			; have we filled the buffer?
	ld		hl, NEXT_BUILDING_COL
	cp		(hl)
	call	p, BUFFER_BUILDINGS		; branch if positive
									; something in buffer 
	ret								; BUFFER_BUILDINGS

BLANK_WIN_COL						; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld		(CHAR_TO_BUF), a
	ld		a, ATTR_CYN_PAP			; sky is cyan
	ld		(ATTR_TO_BUF), a
	ld 		b, WIN_SKY_ROWS
ADD_BLANK_LOOP:
	call	BUF_ROW_AT_COL			; draw the char & attr to buffer
	djnz	ADD_BLANK_LOOP			; until done all rows

; unroll the grass to avoid thinking about loop logic... :(
	ld		a, ATTR_GRN_PAP			; green grass
	ld		(ATTR_TO_BUF), a
	ld		b, WIN_SKY_ROWS+1		
	call	BUF_ROW_AT_COL			; draw the char & attr to buffer
	
	ld		b, WIN_SKY_ROWS+2		
	call	BUF_ROW_AT_COL			; draw the char & attr to buffer

	ld		b, WIN_SKY_ROWS+3		
	call	BUF_ROW_AT_COL			; draw the char & attr to buffer

	ret								; BLANK_WIN_COL

ADD_GAP:
	call	BLANK_WIN_COL
	ld		de, (NEXT_BUILDING_COL)	; move to next column
	inc		de
	ld		(NEXT_BUILDING_COL), de
	ret								; ADD_GAP
	
ADD_UDG_GAP:						; which one from other bits in NEXT_BUILDING
	call	BLANK_WIN_COL			; clear first
	
	ld		a, %00000011			; us LSB for type of udg, as it's easy :)
	ld		hl, NEXT_BUILDING
	and		(hl)					; now a is 0-3 

	ld		d, a					; a for math, store char in d

	inc		a						; over dither, so 1-4

	ld		hl, UDG_ATTRS			; point to attrs
	ld		b, 0					; have to add 16 bit...
	ld		c, a
	add		hl, bc					; point correct attr
	ld		c, (HL)			

	add		a, C_UDG_1				; find correct udg
	ld		(CHAR_TO_BUF), a
	
	push	af						; register faffing!!!!!!!!!!
	ld		a, c					
	ld		(ATTR_TO_BUF), a
	pop		af

	ld		b, WIN_ROWS-2			; draw in top grass row
	call	BUF_ROW_AT_COL

	ld		a, d					; 0-3 type
	cp		%00000011				; is it a tree?
	jr		nz, NOT_TREE	
	ld		a, UDG_TREE_HIGH	
	ld		(CHAR_TO_BUF), a
	ld		a, UDG_TREE_HIGH_ATTR	; attr for tree top
	ld		(ATTR_TO_BUF), a
	ld		b, WIN_ROWS-3			; draw in bottom sky row
	call	BUF_ROW_AT_COL
									
NOT_TREE:
	ld		de, (NEXT_BUILDING_COL)	; move to next column
	inc		de
	ld		(NEXT_BUILDING_COL), de
	ret;

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
	ld		a, %11000000			; color in top 2 bits
	and		(hl)
	rra
	rra
	rra
	rra
	rra
	rra								; now in lowest bits
	and		%00000011				; clear others
	or		UDG_BUILDING_ATTR		; add ink colour 0-3 
	ld		(ATTR_TO_BUF), a		

	ld		b, e					; for each column...

ADD_BULDING_COL_LOOP:
	push	bc
	call	BLANK_WIN_COL			; clear first
	pop		bc						; c for attr...
	push	bc
	
	ld		b, d					; add building UDGs to height
ADD_BULDING_ROW_LOOP:
	push	bc						; preserve bc

	ld		a, WIN_ROWS-1			; starts at top grass
	sub		b						; then height
	ld		b, a					; into b for call
	ld		a, C_UDG_1 + 6			; building udg in a
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
	push	de						; dont' trash de
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
	pop		bc						; loop done retore

	ld		de, hl					; de is common offset

; char
	ld		hl, BUILDING_CHAR_BUF
	add		hl, de	
	ld		a, (CHAR_TO_BUF)
	ld		(hl), a					; draw char

;attr	
	ld		hl, BUILDING_ATTR_BUF	
	add		hl, de	
	ld		a, (ATTR_TO_BUF)
	ld		(hl), a					; buf attr
	
	pop		de					
	ret								; BUF_ROW_AT_COL
	
LOAD_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS				; my UDGs
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
									; bt - building type: 
									; 	0 blank gap
									;	1 UDG gap (reuse seed for which one)
									;	2-3 building
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

CHAR_AT_Y:
	defb	0

