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

; LDIR ATTRs (has to come after chars, as RST $10 uses system ink/paper :(
	ld		de, ATTR_START			; ATTR mem target
	ld		hl, ATTR_BUF			; buffer source
	ld		bc, SCREEN_ATTRS		; num attrs to blit
	LDIR

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


; screen buffers defined for now, but it's only needed during draw, wasting 1,472 bytes
; so re-use for other stuff - eg the window buffer?
; or just self manage from a single defined defb
; and use .lst to check it doesn't ovverun?
; hmm it's only worth saving space if you use it - so actually shared buffers is best use

CHAR_BUF:
	defs	SCREEN_2_CHARS			; space for chars to RST to screen
	
ATTR_BUF:
	defs	SCREEN_ATTRS			; space for the ATTRs to LDIR to screen

; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   