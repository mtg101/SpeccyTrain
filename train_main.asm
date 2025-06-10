	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000
	
	INCLUDE "speccy_defs.asm"		; must be indented
	INCLUDE "train_scene.asm"
	INCLUDE "train_window.asm"
	

START:
	EI								; need for halts
	call	LOAD_UDGS
	call	DRAW_SCENE
	call	SETUP_BUILDINGS
	call	ANIMATE

EXIT:
	ret

ANIMATE:
	halt
	call	DRAW_BUILDINGS			; draw 'em
	call	SHIFT_BUILDINGS_LEFT								
	ld		de, (NEXT_BUILDING_COL)	; move col left
	dec		de
	ld		(NEXT_BUILDING_COL), de
	ld		a, (NEXT_BUILDING_COL)	; check if extra buff empty
	cp		WIN_COL_VIS+1
	call	m, BUFFER_BUILDINGS		; call BUFFER_BUILDINGS if need to
	jr		ANIMATE
; end main loop


; re-use the scene buffers for the building buffer too
; as we need more window buffers for other parallaxes, will need more management
; hopefully all bufs will fit into scene's 1,472 bytes - a resonable working memory!
BUILDING_CHAR_BUF:						; share same as the scene ram
CHAR_BUF:
	defs	SCREEN_2_CHARS			; space for chars to RST to screen
	
BUILDING_ATTR_BUF:
ATTR_BUF:
	defs	SCREEN_ATTRS			; space for the ATTRs to ldir to screen

; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   