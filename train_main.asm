	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000
	
	INCLUDE "speccy_defs.asm"		; must be indented
	INCLUDE "train_data.asm"
	

START:
	EI								; need for halts
	call	LOAD_UDGS
	call	DRAW_SCENE
	call	SETUP_BUILDINGS
	call	ANIMATE

EXIT:
	ret

SETUP_BUILDINGS:
	call	BUFFER_BUILDINGS		; buffer based on the rng 
	ret;

ANIMATE:
	halt
	call	DRAW_BUILDINGS			; draw 'em
									; shift each row left
									; add more if needed 
									; move col left
									; check if extra buff empty
									; recall BUFFER_BUILDINGS if need to
	jr		ANIMATE
; end main loop

DRAW_BUILDINGS:						
	ld		b, WIN_ROWS				
DRAW_BUILDINGS_LOOP:
	call	DRAW_BUIDLING_ROW		; draw each row
	djnz	DRAW_BUILDINGS_LOOP
	ret
	
DRAW_BUIDLING_ROW:					; b row 1-10 (can't index 0)
	push	bc						; preserve parent loop
	dec		b						; 0-9
; get AT d, e
	ld		a, WIN_ROW_START		
	add		b						; add rows
	ld		d, a
	ld		e, WIN_COL_START		; always same

; hl needs the addr of the chars to RST
	ld		hl, BUILDING_BUF		
	ld		a, b
	cp		0						; 
	jr		z, DRAW_BUILDING_ROW_OFFSET	; already at the start
	push	de						; ran out of registers
	ld		de, WIN_COL_TOTAL
DRAW_BUIDLING_ROW_BUF_LOOP:	
	add		hl, de			 		; add extra rows
	djnz	DRAW_BUIDLING_ROW_BUF_LOOP
	pop		de
	
DRAW_BUILDING_ROW_OFFSET:			; de is y, x - hl pointing to chars to RST
	ld		a, C_AT
	RST		$10						; AT
	ld		a, d
	RST		$10						; y	
	ld		a, e
	RST		$10						; x
	ld		b, WIN_COL_VIS
DRAW_BUILDING_ROW_OFFSET_LOOP:
	ld		a, (hl)					; load char
	RST		$10						; print
	inc		hl						; next char
	djnz	DRAW_BUILDING_ROW_OFFSET_LOOP
	
	pop		bc						; restore loop var
	ret

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
	ret

BLANK_WIN_COL						; whole column blank (space)
	ld		a, C_SPACE				; we're printing spaces
	ld 		b, WIN_ROWS	
ADD_BLANK_LOOP:
	call	BUF_ROW_AT_COL			; draw the char to buffer
	djnz	ADD_BLANK_LOOP			; until done all rows
	ret

ADD_GAP:
	call	BLANK_WIN_COL
	ld		de, (NEXT_BUILDING_COL)	; move to next column
	inc		de
	ld		(NEXT_BUILDING_COL), de
	ret
	
ADD_UDG_GAP:						; which one from other bits in NEXT_BUILDING
	call	BLANK_WIN_COL			; clear first
	
	ld		a, %00000011
	ld		hl, NEXT_BUILDING
	and		(hl)					; now a is 0-3 
	ld		d, a					; a for math
	ld		a, C_UDG_1				; first UDG
	inc		a						; step over dither
	add		a, d					; find udg
	ld		b, WIN_ROWS-2			; draw in top grass row
	call	BUF_ROW_AT_COL

	ld		c, a					; remember UDG
	ld		a, d					; 0-3 type
	cp		%00000011				; is it a tree?
	jr		nz, NOT_TREE	
	ld		a, c					; tree bottom
	inc		a						; next udg (tree top)
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
	ld		hl, NEXT_BUILDING
	and		(hl)					; now a is 0-3 
	inc		a						; now a is 1-4
	ld		e, a					; e=width

	ld		b, e					; for each column...
ADD_BULDING_COL_LOOP:
	push	bc
	call	BLANK_WIN_COL			; clear first
									; add building UDGs to height
									; HACK - just add single UDG at base
	ld		b, d
ADD_BULDING_ROW_LOOP:
	push	bc						; preserve bc
	ld		a, WIN_ROWS-1			; starts at top grass
	sub		b						; then height
	ld		b, a					; into b for call
	ld		a, C_UDG_1 + 6			; building udg in a
	call	BUF_ROW_AT_COL			; buf it
	pop		bc						; restore bc
	djnz	ADD_BULDING_ROW_LOOP
	
	
	ld		bc, (NEXT_BUILDING_COL)	; move to next column
	inc		bc
	ld		(NEXT_BUILDING_COL), bc
	pop		bc
	djnz	ADD_BULDING_COL_LOOP
	
	ret;

BUF_ROW_AT_COL:						; a char, b row 1-10 (bjnz means can't 0 index...)
	push	bc						; looping again so preserve b
	push	af						; need to do math in a, but that's what to print...
	push	de						; dont' trash de
	ld		hl, BUILDING_BUF		; start of buff
	ld		de, (NEXT_BUILDING_COL)	; current col
	add		hl, de
	ld		de, WIN_COL_TOTAL
	dec		b						; indexes
	ld		a, b
	cp 		0
	jr		z, BUF_ROW_READY
BUF_ROW_AT_COL_LOOP:
	add		hl, de					; move down a row
	djnz	BUF_ROW_AT_COL_LOOP		; until correct row
BUF_ROW_READY:	
	pop		de
	pop		af
	ld		(hl), a					; draw char
	pop		bc
	ret
	
LOAD_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS				; my UDGs
	ld		bc, NUM_UDGS * 8		; loop
	ldir
	ret
  
DRAW_SCENE:
; RLE characters to buffer
	ld		hl, SCENE_CHARACTERS	; load addr of RLE characters 
	ld		de, CHAR_BUF			; buffer pointer
LOOP_CHAR:
	ld		a, (hl)					; get char to display
	cp		a, 0					; check it's not null
	jr		z, CHAR_BUF_DONE			; if null we're done
	inc		hl						; move to num times
	ld		b, (hl)					; load b counter with num times to display
LOOP_RLE_CHAR:						; assume: num times not 0...
	ld		(de), a					; copy char
	inc		de						; inc buffer offset
	djnz	LOOP_RLE_CHAR			; loop until done
	
	inc 	hl						; next char (null check comes at start of loop)
	jr		LOOP_CHAR				; next RLE block
	
CHAR_BUF_DONE:

; RLE attrs to buffer
	ld		hl, SCENE_ATTRS			; load addr of RLE attrs
	ld		de, ATTR_BUF			; de points to ATTR buffer
LOOP_ATTR:
	ld		a, (hl)					; get attr to use
	cp		a, 0					; check it's not null
	jr		z, ATTR_BUF_DONE			; if null we're done
	inc		hl						; move to num times
	ld		b, (hl)					; load b counter with num times to display
LOOP_RLE_ATTR:						; assume: num times not 0...
	ld		(de), a					; put the attr in buffer
	inc		de
	djnz	LOOP_RLE_ATTR			; lool until done
	
	inc		hl						; next attr (null check comes at start of loop)
	jr		LOOP_ATTR				; next RLE block
	
ATTR_BUF_DONE:

; basic border
	ld		a, COL_BLU				; cyan in a
	call	ROM_BORDER				; sets border to val in a
	
; clear screen
	ld		a, $FF
	ld		(MASK_P), a				; RST $10 uses ATTRs, doesn't overwrite
	call	ROM_CLS					; so AT works, not just print at bottom of screen
	halt							; wait for vsync for best chance of nice draw...
									; but t-states hurt so maybe need more tricksy stuff
; ldir ATTRs (has to come after chars, as RST $10 uses system ink/paper :(
	ld		de, ATTR_START			; ATTR mem target
	ld		hl, ATTR_BUF			; buffer source
	ld		bc, SCREEN_ATTRS		; num attrs to blit
	ldir
; RST chars
	ld		hl, CHAR_BUF			; point to start of buffer
	ld		b, 255					; 8 bit counter
CHAR_RST_1:							; so unroll and do thrice
	ld		a, (hl)					; char in a
	RST		$10						; RST it to screen
	inc		hl						; next char
	djnz	CHAR_RST_1				; loop until done
	ld		b, 255					; 8 bit counter
CHAR_RST_2:							; so unroll and do thrice
	ld		a, (hl)					; char in a
	RST		$10						; RST it to screen
	inc		hl						; next char
	djnz	CHAR_RST_2				; loop until done
	ld		b, SCREEN_255_REST		; 8 bit counter, last ones not full 255
CHAR_RST_3:							; so unroll and do thrice
	ld		a, (hl)					; char in a
	RST		$10						; RST it to screen
	inc		hl						; next char
	djnz	CHAR_RST_3				; loop until done

DRAW_SCENE_DONE:
	ret

RNG: 								; uses first 8KiB ROM for pseudo, retuns in a
	ld		hl,(SEED)        		 
    ld		a,h
    and		$1F              		; keep it within first 8k of ROM.
    ld		h,a
    ld		a,(hl)           		; Get "random" number from location.
    inc		hl              		; Increment pointer.
    ld		(SEED),hl
    ret
SEED:
	defw	23
	
NEXT_BUILDING:						; ic bt bh bw 
									; ic = paper colour (blk, blue, red, mag)
									; 	$8F is solid ink char 
									; bt - building type: 
									; 	0 blank gap
									;	1 UDG gap (reuse seed for which one)
									;	2-3 building
									; bh - building height 2-5 - single UDG for now
									; bw - building width 1-4
	defb	0
	
NEXT_BUILDING_COL:
	defw	0

; re-use the scene buffers for the building buffer too
; as we need more window buffers for other parallaxes, will need more management
; hopefully all bufs will fit into scene's 1,472 bytes - a resonable working memory!
BUILDING_BUF:						; share same as the scene ram
CHAR_BUF:
	defs	SCREEN_2_CHARS			; space for chars to RST to screen
	
ATTR_BUF:
	defs	SCREEN_ATTRS			; space for the ATTRs to ldir to screen

; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   