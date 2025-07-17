; gfx data
	INCLUDE "train_scene_data.asm"
	INCLUDE "train_scene_handles.asm"

DRAW_SCENE:
	call	LOAD_SCENE_UDGS

; blue ink on blue paper while we render the scene
	ld		a, ATTR_ALL_BLU			; blank before we do stuff
	ld		(ATTR_P), a				; blue like border for loading
	call	ROM_CLS					; simple way to set all blue without ldir

; RLE characters to buffer
	ld		hl, SCENE_CHARACTERS	; load addr of RLE characters 
	ld		de, CHAR_SCENE_BUF		; buffer pointer
									; set ink white so drawing is invisible until ready
LOOP_CHAR:
	ld		a, (hl)					; get char to display
	cp		a, 0					; check it's not null
	jr		z, CHAR_BUF_DONE		; if null we're done
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
	ld		de, ATTR_SCENE_BUF		; de points to ATTR buffer
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

	
DRAW_SCENE_CHARS:					; invisible due to ink&paper smae
; RST chars
	ld		hl, CHAR_SCENE_BUF		; point to start of buffer
	
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


; ldir ATTRs (will show what's been drawn above while pap&ink were the same)
	ld		de, ATTR_START			; ATTR mem target
	ld		hl, ATTR_SCENE_BUF		; buffer source
	ld		bc, NUM_SCREEN_ATTRS	; num attrs to blit
	ldir

	call	DRAW_SCENE_WHEEL


	ret								; DRAW_SCENE

; draw the bicycle wheel usinng vector.asm routines
DRAW_SCENE_WHEEL:
	; Draw Line routine
	; B = Y pixel position 1
	; C = X pixel position 1
	; D = Y pixel position 2
	; E = X pixel position 2

	; Draw Circle (Beta - uses Plot to draw the circle outline as a proof of concept)
	; B = Y pixel position of circle centre
	; C = X pixel position of circle centre
	; A = Radius of circle

	; 3-pix wide tyre
	ld		b, 167					; 191 is bottom, 8 above for floor=183, radius 16=167
	ld		c, 0					; half wheel showing (can't go negative, minimum can show if half)
	ld		a, 16					; radius
	call 	Draw_Circle

	ld		b, 167					; 191 is bottom, 8 above for floor=183, radius 16=167
	ld		c, 0					; half wheel showing (can't go negative, minimum can show if half)
	ld		a, 17					; radius
	call 	Draw_Circle

	ld		b, 167					; 191 is bottom, 8 above for floor=183, radius 16=167
	ld		c, 0					; half wheel showing (can't go negative, minimum can show if half)
	ld		a, 18					; radius
	call 	Draw_Circle

	; spokes

	; top stright
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 151					; y target
	ld		e, 0					; X target
	call 	Draw_Line

	; first right top
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 151					; y target
	ld		e, 8					; X target
	call 	Draw_Line

	; second right top
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 159					; y target
	ld		e, 12					; X target
	call 	Draw_Line

	; centre horizontal
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 167					; y target
	ld		e, 16					; X target
	call 	Draw_Line

	; second right bottom
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 175					; y target
	ld		e, 12					; X target
	call 	Draw_Line

	; first right bottom
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 183					; y target
	ld		e, 8					; X target
	call 	Draw_Line

	; vertical down
	ld		b, 167					; start spokes at wheel centre y
	ld		c, 0					; start spokes at wheel centre y
	ld		d, 183					; y target
	ld		e, 0					; X target
	call 	Draw_Line

	ret								; DRAW_SCENE_WHEEL 

LOAD_SCENE_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS_SCENE_PIXELS	; my UDGs
	ld		bc, NUM_SCENE_UDGS * 8	; loop
	ldir
	ret								; LOAD_UDGS
