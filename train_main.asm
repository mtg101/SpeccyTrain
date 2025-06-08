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
	call	MAKE_NEXT_BUILDING		; store random var in NEXT_BUILDING
	call	BUFFER_BUILDINGS		; buffer based on the rng 
	ret;

ANIMATE:
	halt
	call	DRAW_BUILDINGS			; draw 'em
									; shift left
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

MAKE_NEXT_BUILDING:
	call	RNG						; rnd in SEED
	ld		hl, NEXT_BUILDING		
	ld		(hl), SEED				; generate compiler warning, that's fine...
									; assume lSB, but either is random enough I assume ;)
	ret

BUFFER_BUILDINGS:
	ld		a, %00110000			; mask for type
	and		NEXT_BUILDING			; get type from generated next building
									; compiler warning - again is fine
	ld		d, a					; store type in d
	cp		%00000000				; gap?
	jr		z, ADD_GAP
	ld		a, d					; type back in a
	cp		%00010000				; udg gap?
	jr		z, ADD_UDG_GAP
	ld		a, d					; type back in a
	cp		%00100000				; building? (2 or 3 so just look at MSB)
	jr		z, ADD_BUILDING
	
	ld		a, WIN_COL_VIS			; have we filled the buffer?
	cp		NEXT_BUILDING_COL
	jr		c, BUFFER_BUILDINGS		; carry means < -- so we're always putting extra
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
	ld		de, NEXT_BUILDING_COL	; move to next column
	inc		de
	ld		(NEXT_BUILDING_COL), de
	ret
	
ADD_UDG_GAP:						; which one from other bits in NEXT_BUILDING
	call	BLANK_WIN_COL			; clear first
	
	ld		de, NEXT_BUILDING
	and		%00000011				; now it's 0-3
	ld		hl, UDG_START			; first UDG
	inc		hl						; step over dither
	add		hl, de					; find udg
	ld		a, (hl)					; put in a
	ld		b, WIN_ROWS-2			; draw in top grass row
	call	BUF_ROW_AT_COL

	cp		%00000011				; is it a tree?
	jr		nz, NOT_TREE	
	inc		hl						; next UDG is tree top								
	ld		b, WIN_ROWS-3			; draw in top grass row
	call	BUF_ROW_AT_COL
									
NOT_TREE:
	ld		de, NEXT_BUILDING_COL	; move to next column
	inc		de
	ld		(NEXT_BUILDING_COL), de
	ret;

ADD_BUILDING:
	call	ADD_UDG_GAP				; HACK it's just gaps to start...
	ret;

BUF_ROW_AT_COL:						; a char, b row 1-10 (bjnz means can't 0 index...)
	push	bc						; looping again so preserve b
	ld		hl, BUILDING_BUF		; start of buff
	ld		de, NEXT_BUILDING_COL	; current col
	add		hl, de
	ld		de, WIN_COL_TOTAL
BUF_ROW_AT_COL_LOOP:
	add		hl, de					; move down a row
	djnz	BUF_ROW_AT_COL_LOOP		; until correct row
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
	call	ROM_CLS					; so AT works, not just print at bottom of screen
	halt							; wait for vsync for best chance of nice draw...
									; but t-states hurt so maybe need more tricksy stuff
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

; ldir ATTRs (has to come after chars, as RST $10 uses system ink/paper :(
	ld		de, ATTR_START			; ATTR mem target
	ld		hl, ATTR_BUF			; buffer source
	ld		bc, SCREEN_ATTRS		; num attrs to blit
	ldir

DRAW_SCENE_DONE:
	ret

RNG: 								; uses first 8KiB ROM for pseudo
	ld		hl,(SEED)        		; SEED is both seed and the random number
    ld		a,h
    and		$1F              		; keep it within first 8k of ROM.
    ld		h,a
    ld		a,(hl)           		; Get "random" number from location.
    inc		hl              		; Increment pointer.
    ld		(SEED),hl
    ret
SEED:
	defw	0
	
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
	defb	0

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
   