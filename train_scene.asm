; gfx data
	INCLUDE "train_scene_data.asm"

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
	jr		z, ATTR_BUF_DONE		; if null we're done
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
	ret

   