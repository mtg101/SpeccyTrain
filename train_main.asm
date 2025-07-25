	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION	; for VSCODE and debugging
	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000						; the uncontended 32KiB
	
; re-use the scene buffers for the building buffer too
CHAR_WINDOW_BUF:
CLOUD_CHAR_BUF:							
	defs	WIN_CLOUD_ROWS * WIN_COL_TOTAL
MOUNTAIN_CHAR_BUF:							
	defs	WIN_MOUNTAIN_ROWS * WIN_COL_TOTAL
BUILDING_CHAR_BUF:
	defs	WIN_BUILDING_ROWS * WIN_COL_TOTAL
	
ATTR_WINDOW_BUF:
CLOUD_ATTR_BUF:							
	defs	WIN_CLOUD_ROWS * WIN_COL_TOTAL	
MOUNTAINS_ATTR_BUF:							
	defs	WIN_MOUNTAIN_ROWS * WIN_COL_TOTAL	
BUILDING_ATTR_BUF:						
	defs	WIN_BUILDING_ROWS * WIN_COL_TOTAL
FG_ATTR_BUF:							
	defs	WIN_FG_ROWS * WIN_COL_TOTAL

CHAR_SCENE_BUF:						; needs 768 bytes total
	defs	768						; separate so can do loading screen... todo optimize

ATTR_SCENE_BUF:						; needs 768 bytes total
	defs	768						; separate so can flip attrs after setup... todo optimize						

FRAME_COUNTER:
	defw	0

	INCLUDE "speccy_defs.asm"		; must be indented
	INCLUDE "print_char_y_x.asm"
	INCLUDE "draw_window.asm"
	INCLUDE "train_scene.asm"
	INCLUDE "train_window_main.asm"
	INCLUDE "maths.asm"
	INCLUDE "train_boarding_screen.asm"
	INCLUDE "vector.asm"
	
START:
	call	INITIALISE_INTERRUPT	; IM2 with ROM trick
	call	LOAD_BOARDING_SCREEN	; show something while setup
	call	SETUP_WINDOW			; doesn't render, takes time
	call	WAIT_FOR_USER			; varying RNG seed - comment out while debugging (and uncomment...)
	call	DRAW_SCENE				; blue ink/pap as it loads, to avoid trashing loading screen 
	call	LOAD_WINDOW_UDGS		; reload for animation


ANIMATE_MAIN:
	call	ANIMATE_CLOUDS
	call	ANIMATE_COPTER
	call	ANIMATE_MOUNTAINS
	call	ANIMATE_BUILDINGS
	call	ANIMATE_FG
	call	ANIMATE_WINDOW_TUNNEL

	halt							; wait for vsync before draw

	call	ANIMATE_SCENE_HANDLES		; first as it's higher up (and should be very quick)
	call	ANIMATE_TRAIN_SCENE_SIGN	; also fast
	call	DRAW_WINDOW					; the big one...

	ld		hl, (FRAME_COUNTER)		
	inc		hl						; next frame
	ld		(FRAME_COUNTER), hl

	jr		ANIMATE_MAIN


; set up IM2 - so we don't wate time scanning keyboard and so on
; use ROM trick for interrupt table
; from http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/interrupts 
INITIALISE_INTERRUPT:   			
	di                              ; Disable interrupts
	ld		hl, INTERRUPT
	ld		ix, $FFF0				; This code is to be written at 0xFF
	ld		(ix + $04), $C3         ; Opcode for JP
	ld		(ix + $05), l           ; Store the address of the interrupt routine in
	ld		(ix + $06), h
	ld		(ix + $0F), $18         ; Opcode for JR; this will do JR to FFF4h
	ld		a, $39                  ; Interrupt table at page 0x3900 (ROM)
	ld		i, a                    ; Set the interrupt register to that page
	im		2                       ; Set the interrupt mode
	ei                              ; Enable interrupts
	ret								; Initialise_Interrupt
 
INTERRUPT:              
	; push af                       ; save all the registers on the stack
	; push bc                       ; this is probably not necessary unless
	; push de                       ; we're looking at returning cleanly
	; push hl                       ; back to basic at some point
	; push ix
	; exx
	; ex af,af
	; push af
	; push bc
	; push de
	; push hl
	; push iy


; static border
 	; ld		a, COL_BLK
 	; out		($FE), a

	; .3480 nop

 	; ld		a, COL_BLU
 	; out		($FE), a


	; pop iy                        ; restore all the registers
	; pop hl
	; pop de
	; pop bc
	; pop af
	; exx
	; ex af,af
	; pop ix
	; pop hl
	; pop de
	; pop bc
	; pop af
	ei                               ; Enable interrupts
	ret                              ; INTERRUPT


; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   