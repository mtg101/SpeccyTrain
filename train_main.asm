	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION	; for VSCODE and debugging
	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000
	
; re-use the scene buffers for the building buffer too
; so define before includes -- which does mean it's between code rather than just being at end...
BUILDING_CHAR_BUF:						; share same as the scene ram
CHAR_BUF:
	defs	NUM_SCREEN_CHARS			; space for chars to RST to screen
	
BUILDING_ATTR_BUF:
ATTR_BUF:
	defs	NUM_SCREEN_ATTRS			; space for the ATTRs to ldir to screen

	INCLUDE "speccy_defs.asm"		; must be indented
	INCLUDE "print_char_y_x.asm"
	INCLUDE "print_char_row.asm"
	INCLUDE "udgs.asm"
	INCLUDE "train_scene.asm"
	INCLUDE "train_window.asm"
	
START:
	call	Initialise_Interrupt		; IM2 with ROM trick
	call	LOAD_UDGS
	call	DRAW_SCENE
	call	SETUP_BUILDINGS
	call	ANIMATE_ROW

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

ANIMATE_ROW:
	call	BUF_CHAR_ROWS			; buffer things row-by-row
	halt							; wait for vsync
	call	PRINT_CHAR_ROW			; draw row-by-row
	call	SHIFT_BUILDINGS_LEFT								
	ld		de, (NEXT_BUILDING_COL)	; move col left
	dec		de
	ld		(NEXT_BUILDING_COL), de
	ld		a, (NEXT_BUILDING_COL)	; check if extra buff empty
	cp		WIN_COL_VIS+1
	call	m, BUFFER_BUILDINGS		; call BUFFER_BUILDINGS if need to
	jr		ANIMATE_ROW

; set up IM2 - so can use iy and don't wate time scanning keyboard and so on
; use ROM trick for interrupt table
; from http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/interrupts 
Initialise_Interrupt:   			
	DI                                      ; Disable interrupts
	LD HL,Interrupt
	LD IX,0xFFF0                            ; This code is to be written at 0xFF
	LD (IX+04h),0xC3                        ; Opcode for JP
	LD (IX+05h),L                           ; Store the address of the interrupt routine in
	LD (IX+06h),H
	LD (IX+0Fh),0x18                        ; Opcode for JR; this will do JR to FFF4h
	LD A,0x39                               ; Interrupt table at page 0x3900 (ROM)
	LD I,A                                  ; Set the interrupt register to that page
	IM 2                                    ; Set the interrupt mode
	EI                                      ; Enable interrupts
	RET										; Initialise_Interrupt
 
Interrupt:              
	DI                                      ; Disable interrupts 
	PUSH AF                                 ; Save all the registers on the stack
	PUSH BC                                 ; This is probably not necessary unless
	PUSH DE                                 ; we're looking at returning cleanly
	PUSH HL                                 ; back to BASIC at some point
	PUSH IX
	EXX
	EX AF,AF'
	PUSH AF
	PUSH BC
	PUSH DE
	PUSH HL
	PUSH IY
;
; Your code here...
;
; But I do't need any, just need to resume from halt
; 
	POP IY                                  ; Restore all the registers
	POP HL
	POP DE
	POP BC
	POP AF
	EXX
	EX AF,AF'
	POP IX
	POP HL
	POP DE
	POP BC
	POP AF
	EI                                      ; Enable interrupts
	RET                                     ; And return


; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   