	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000
	
	INCLUDE "speccy_defs.asm"		; must be indented
	

START:
	EI								; need for halts
	call	DRAW_SCENE
	call	SETUP_BUILDINGS
	
	call	ANIMATE

EXIT:
	ret

SETUP_BUILDINGS:
	ret;

ANIMATE:
	halt
	jr		ANIMATE
   
DRAW_SCENE:
; basic border
	ld		a, COL_CYN				; cyan in a
	call	ROM_BORDER				; sets border to val in a
	
; clear screen
	call	ROM_CLS					; so AT works, not just print at bottom of screen

; set UDG
	ld		hl, UDG_START			; load first UDG addr
	ld		b, 4					; 2 lots of alternating pattern
LOOP_UDG:	
	ld		(hl), %10101010			; load alternate 1010 patters, 'unrolled' ;)
	inc 	hl
	ld		(hl), %01010101
	inc 	hl
	djnz	LOOP_UDG				
	

; draw characters	
	ld		hl, SCENE_CHARACTERS	; load addr of characters 
LOOP_CHAR:
	ld		a, (hl)					; get char to display
	cp		a, 0					; check it's not null
	jr		z, CHARS_DONE			; if null we're done
	inc		hl						; move to num times
	ld		b, (hl)					; load b counter with num times to display
LOOP_RLE_CHAR:						; assume: num times not 0...
	push	af						; rst break a, so save
	rst		$10						; print the char
	pop		af						; resotre a
	djnz	LOOP_RLE_CHAR			; loop until done
	
	inc 	hl						; next char (null check comes at start of loop)
	jr		LOOP_CHAR				; next RLE block
	
CHARS_DONE:

; draw attrs
	ld		hl, SCENE_ATTRS
	ld		de, ATTR_START			; de points to ATTR mem
LOOP_ATTR:
	ld		a, (hl)					; get attr to use
	cp		a, 0					; check it's not null
	jr		z, ATTRS_DONE			; if null we're done
	inc		hl						; move to num times
	ld		b, (hl)					; load b counter with num times to display
LOOP_RLE_ATTR:						; assume: num times not 0...
	ld		(de), a					; put the attr on screen
	inc		de
	djnz	LOOP_RLE_ATTR			; lool until done
	
	inc		hl						; next attr (null check comes at start of loop)
	jr		LOOP_ATTR				; next RLE block
	
ATTRS_DONE:

DRAW_SCENE_DONE:
	ret

SCENE_CHARACTERS:
	; RLE char, numTimes (max 255 - b is 8bit!), 0 terminated
	; total 32*22=704 (ignoring channel 1 lower area for now)
	defb	'*', 32
	defb	'-', 32
	defb	$86, 128
	defb	C_SPACE, 33
	defb	$84, 1
	defb	$8C, 3
	defb	$88, 1
	defb	C_SPACE, 27
	defb	$85, 1
	defb	'Z', 1
	defb	'X', 1
	defb	'R', 1
	defb	$8A, 1
	defb	C_SPACE, 27
	defb	$81, 1
	defb	$83, 3
	defb	$82, 1
	defb	C_SPACE, 218
	defb	C_UDG_1, 192
	defb	0

SCENE_ATTRS:
	; RLE attr, numTime (max 255 - b is lower bit!), 0 terminated
	; total 32*24=768 (ignoring channel 1 lower area for now)
	defb	ATTR_RED_PAP, 200
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 6
	defb	ATTR_YPBI, 3
	defb	ATTR_RED_PAP, 3
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_GRN_PAP, 20
	defb	ATTR_RED_PAP, 10
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_GRN_PAP, 20
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_GRN_PAP, 20
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8	
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 22
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8	
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 2
	defb	ATTR_BLK_PAP, 18
	defb	ATTR_RED_PAP, 2
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 3
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 14
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 3
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 3
	defb	ATTR_RED_PAP, 18
	defb	ATTR_BLK_PAP, 3
	defb	ATTR_RED_PAP, 9
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 20
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 10
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 20
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 3


	defb	ATTR_BLK_PAP, 64
	defb	0

; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   