; gfx data
	INCLUDE "train_scene_data.asm"

DRAW_SCENE:
	call	LOAD_SCENE_UDGS

; RLE characters to buffer
	ld		hl, SCENE_CHARACTERS	; load addr of RLE characters 
	ld		de, CHAR_BUF			; buffer pointer
									; set ink white so drawing is invisible until ready
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

SETUP_SCREEN:
; black loading screen
	ld		a, COL_BLK
	call	ROM_BORDER				; sets border to val in a
	ld		a, ATTR_ALL_BLK			
	ld		(ATTR_P), a				; black for loading
	call	ROM_CLS					; needed to set channel 2 for proper AT drawing (not just scrolling)

; actual setup
	ld		a, $FF
	ld		(MASK_P), a				; so RST $10 uses my  ATTRs, doesn't overwrite
	ld		a, ATTR_ALL_WHT
	ld		(ATTR_P), a				; set pap&ink white for init draw (invisible until attrs) 
	halt							; wait for vsync for best chance of nice draw...
									; but t-states hurt so maybe need more tricksy stuff

DRAW_SCENE_CHARS:					; invisible due to ink&paper white
; RST chars
	ld		hl, CHAR_BUF			; point to start of buffer
	
	ld		a, 0
	ld		(PRINT_AT_X), a			; x is 0
	ld		a, 0
	ld		(PRINT_AT_Y), a			; y is 0

	ld		b, SCREEN_ALL_ROWS		; all 24!
DRAW_SCENE_CHARS_ROW_LOOP:
	push	bc						; double loop...
	ld		b, SCREEN_COLUMNS		; all columns
DRAW_SCENE_CHARS_COl_LOOP:
	ld		a, (hl)
	ld		(PRINT_CHAR), a			; char to print from buffer
	call	PRINT_CHAR_AT_Y_X		; print char
	ld		a, (PRINT_AT_X)
	inc		a						; next col
	ld		(PRINT_AT_X), a
	inc		hl
	djnz	DRAW_SCENE_CHARS_COl_LOOP
	
	ld		a, (PRINT_AT_Y)
	inc		a						; next row
	ld		(PRINT_AT_Y), a
	pop		bc						; for outer row loop
	djnz	DRAW_SCENE_CHARS_ROW_LOOP

; basic border
	ld		a, COL_BLU
	call	ROM_BORDER				; sets border to val in a
	
; ldir ATTRs 
	ld		de, ATTR_START			; ATTR mem target
	ld		hl, ATTR_BUF			; buffer source
	ld		bc, NUM_SCREEN_ATTRS	; num attrs to blit
	ldir

	ret								; DRAW_SCENE
   
LOAD_SCENE_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS_SCENE_PIXELS	; my UDGs
	ld		bc, NUM_SCENE_UDGS * 8	; loop
	ldir
	ret								; LOAD_UDGS
