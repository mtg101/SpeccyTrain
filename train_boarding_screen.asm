

LOAD_BOARDING_SCREEN:
	; blue loading screen, matching border
	ld		a, ATTR_ALL_BLU			
	ld		(ATTR_P), a				; blue like border for loading
	call	ROM_CLS					; simple way to set all blue without ldir

	; blue border
	ld		a, COL_BLU
	call	ROM_BORDER				; sets border to val in a

; RLE attrs to buffer
	ld		hl, BOARDING_SCENE_ATTRS	; load addr of RLE attrs
	ld		de, ATTR_SCENE_BUF		; de points to ATTR buffer
BOARDING_LOOP_ATTR:
	ld		a, (hl)					; get attr to use
	cp		a, 0					; check it's not null
	jr		z, BOARDING_ATTR_BUF_DONE		; if null we're done
	inc		hl						; move to num times
	ld		b, (hl)					; load b counter with num times to display
BOARDING_LOOP_RLE_ATTR:						; assume: num times not 0...
	ld		(de), a					; put the attr in buffer
	inc		de
	djnz	BOARDING_LOOP_RLE_ATTR			; lool until done
	
	inc		hl						; next attr (null check comes at start of loop)
	jr		BOARDING_LOOP_ATTR				; next RLE block
	
BOARDING_ATTR_BUF_DONE:
	; ldir ATTRs to screen
	ld		de, ATTR_START			; ATTR mem target
	ld		hl, ATTR_SCENE_BUF		; buffer source
	ld		bc, NUM_SCREEN_ATTRS	; num attrs to blit
	ldir

	ret										; LOAD_BOARDING_SCREEN

; shows text, starts counter, waits for user, then sets RNG seed before continuing
WAIT_FOR_USER:
	; show text on boarding screen
	; print_chat_at_y_x loop, with attrs set too
	ld		a, 0
	ld		(PRINT_AT_Y), a
	ld		a, 0
	ld		(PRINT_AT_X), a
	ld		hl, BOARDING_SCENE_PRESS_SPACE
	ld		de, ATTR_START + (0*32) + 0	; attr index
BOARDING_SCENE_PRESS_SPACE_TEXT_LOOP:
	; next char
	ld		a, (hl)

	cp		0								; is it 0null terminator?
	jr		z,  BOARDING_SCENE_WAIT_LOOP

	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_AT_Y_X

	; next attr
	ld		a, %10110001
	ld		(de), a

	; move to next col
	ld		a, (PRINT_AT_X)
	inc		a
	ld		(PRINT_AT_X), a

	; next char
	inc		hl
	; next attr
	inc		de

	jr		BOARDING_SCENE_PRESS_SPACE_TEXT_LOOP

	ld		de, 0					; wait counter
BOARDING_SCENE_WAIT_LOOP:
	halt							; wait for next frame
	inc		de						; inc wait counter	

	; keyboard stuff turns out to be pretty easy
	; see http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/keyboard
	; ok TODO understand how in a, (c) knows which bank of keys we're talking about..
	; magically knows because we're pssing in c from bc or something?

	; space pressed?
	ld		bc, $7FFE				; space to b (space in bit 0)
	in		a, (c)					; read keys
	bit		0, a					; space is bit 0
	jr		nz, BOARDING_SCENE_WAIT_LOOP	; 1 means key not pressed, 0 pressed

BOARDING_SCENE_WAIT_DONE:
	ld 		(SEED1), de

	ret										; WAIT_FOR_USER

BOARDING_SCENE_PRESS_SPACE:
	defb	"Press SPACE to board!", 0


BOARDING_SCENE_ATTRS:
	; RLE attr, numTime (max 255 - b is lower bit!), 0 terminated - total 768
	defb	%00001000, 120
	defb	%01000000, 4
	defb	%00001000, 27
	defb	%01000000, 1
	defb	%00010000, 4
	defb	%01000000, 1
	defb	%00001000, 26
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%00001000, 3
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 25
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%00001000, 3
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 25
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%00001000, 3
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 4
	defb	%01000000, 5
	defb	%00001000, 16
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%00001000, 3
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 3
	defb	%01000000, 1
	defb	%00110000, 5
	defb	%01000000, 1
	defb	%00001000, 15
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%00001000, 2
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 5
	defb	%01000000, 4
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 15
	defb	%01000000, 1
	defb	%00010000, 3
	defb	%01000000, 1
	defb	%00001000, 9
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 6
	defb	%01000000, 1
	defb	%00001000, 3
	defb	%01000000, 1
	defb	%00001000, 4
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%01000000, 2
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 7
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 6
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 3
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%01000000, 2
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 6
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 7
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 3
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 1
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 5
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 8
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 4
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 1
	defb	%01000000, 1
	defb	%00010000, 1
	defb	%01000000, 1
	defb	%00001000, 4
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 9
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 5
	defb	%01000000, 1
	defb	%00001000, 3
	defb	%01000000, 1
	defb	%00001000, 4
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 11
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 15
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 4
	defb	%00001000, 8
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 15
	defb	%01000000, 1
	defb	%00110000, 5
	defb	%01000000, 1
	defb	%00001000, 6
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 15
	defb	%01000000, 5
	defb	%00001000, 7
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 26
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 25
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 1
	defb	%01000000, 1
	defb	%00110000, 1
	defb	%01000000, 1
	defb	%00001000, 26
	defb	%01000000, 1
	defb	%00001000, 3
	defb	%01000000, 1
	defb	%00001000, 13 + 32

	defb	0
