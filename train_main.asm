	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION	; for VSCODE and debugging
	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000
	
; re-use the scene buffers for the building buffer too
CHAR_BUF:							; needs 768 bytes total
CLOUD_CHAR_BUF:							
	defs	WIN_CLOUD_ROWS * WIN_COL_TOTAL
BUILDING_CHAR_BUF:
	defs	WIN_BUILDING_ROWS * WIN_COL_TOTAL
EXTRA_CHAR_BUF:
	defs	584						; top up to 768 for scene buf
	
ATTR_BUF:							; needs 768 bytes total
CLOUD_ATTR_BUF:							
	defs	WIN_CLOUD_ROWS * WIN_COL_TOTAL	
BUILDING_ATTR_BUF:						
	defs	WIN_BUILDING_ROWS * WIN_COL_TOTAL
FG_ATTR_BUF:							
	defs	WIN_FG_ROWS * WIN_COL_TOTAL
EXTRA_ATTR_BUF:
	defs	538						; top up to 768 for scene buf

FRAME_COUNTER:
	defb	0

	INCLUDE "speccy_defs.asm"		; must be indented
	INCLUDE "print_char_y_x.asm"
	INCLUDE "draw_window.asm"
	INCLUDE "train_scene.asm"
	INCLUDE "train_window_main.asm"
	INCLUDE "train_window_copter.asm"
	
START:
	call	INITIALISE_INTERRUPT	; IM2 with ROM trick
	call	DRAW_SCENE
	call	SETUP_WINDOW

;	jr		ANIMATE_MAIN_BORDER		; use the border version, normally commented out

ANIMATE_MAIN:
	ld		a, (FRAME_COUNTER)		; load frame counter
	bit		0, a					; z is now ready for after vsync
	call	z, ANIMATE_FLIP
	call	nz, ANIMATE_FLOP
	inc		a
	ld		(FRAME_COUNTER), a

	jr		ANIMATE_MAIN

ANIMATE_FLIP:
	push	af						; for other conditional jumps
	call	ANIMATE_CLOUDS
	call	ANIMATE_COPTER
	call	ANIMATE_FG
	halt							; wait for vsync before draw
	call	DRAW_WINDOW_FG_CLOUDS				
	call	UNDRAW_COPTER
	pop		af						; for other conditional jumps
	ret								; ANIMATE_FLIP

ANIMATE_FLOP:
	push	af						; for other conditional jumps
	call	ANIMATE_BUILDINGS
	halt							; wait for vsync before draw
	call	DRAW_WINDOW_BUILDINGS
	pop		af						; for other conditional jumps
	ret								; ANIMATE_FLOP




; ANIMATE_MAIN_BORDER:				; this will break every time timings change... but fun to play with
; 									; and TODO needs the flip/flop animation doing to work again now...
; 	halt							; wait for vsync
; 	ld		a, COL_RED
; 	out		($FE), a
; 	call	DRAW_WINDOW				; draw row-by-row
; 	.4 nop							; timing desu!
; 	ld		a, COL_BLK
; 	out		($FE), a
; 	call	ANIMATE_WINDOW			; commented out to show the static border working
; 									; can also make animate_window do less and fit in under 1 frame
; 									; at time of writing, clouds&fg work, but buildings on own don't
; 	jr		ANIMATE_MAIN_BORDER


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
	; di                            ; disable interrupts 
	; push af                       ; save all the registers on the stack
	; push bc                       ; this is probably not necessary unless
	; push de                       ; we're looking at returning cleanly
	; push hl                       ; back to basic at some point
	; push ix
	; exx
	; ex af,af'
	; push af
	; push bc
	; push de
	; push hl
	; push iy
;
; Your code here...
;
; But I don't need any, just need to resume from halt
; Also means can not bother DI/EI, push/popping, etc, so commented out
; 
	; pop iy                        ; restore all the registers
	; pop hl
	; pop de
	; pop bc
	; pop af
	; exx
	; ex af,af'
	; pop ix
	; pop hl
	; pop de
	; pop bc
	; pop af
	ei                               ; Enable interrupts
	ret                              ; INTERRUPT


; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   