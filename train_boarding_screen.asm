

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
