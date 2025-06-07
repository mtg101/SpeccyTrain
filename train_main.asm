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
	ret;

ANIMATE:
	halt
	jr		ANIMATE

LOAD_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS				; my UDGs
	ld		bc, NUM_UDGS * 8		; loop
	LDIR
	ret
   
DRAW_SCENE:
; basic border
	ld		a, COL_CYN				; cyan in a
	call	ROM_BORDER				; sets border to val in a
	
; clear screen
	call	ROM_CLS					; so AT works, not just print at bottom of screen

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

BUILDING_BUF:
	defs	24*10					; space for 10x20+4 window



; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   