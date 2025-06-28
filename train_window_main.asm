; udgs etc
	INCLUDE "train_window_data.asm"
	INCLUDE "train_window_buildings.asm"
	INCLUDE "train_window_building_gaps.asm"
	INCLUDE "train_window_clouds.asm"
	INCLUDE "train_window_fg.asm"
	
SETUP_WINDOW:
	call	LOAD_WINDOW_UDGS
	call	SETUP_CLOUDS
	call	SETUP_BUILDINGS		
	call	SETUP_FG
	ret								; SETUP_BUILDINGS

ANIMATE_WINDOW:
	call	ANIMATE_CLOUDS
	call	ANIMATE_BUILDINGS
	call	ANIMATE_FG
	ret								; ANIMATE_WINDOW

LOAD_WINDOW_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS_WINDOW_PIXELS	; my UDGs
	ld		bc, NUM_WINDOW_UDGS * 8	; loop
	ldir
	ret								; LOAD_UDGS

; uses first 8KiB ROM for pseudo, retuns in a
RNG: 								
	ld		hl,(SEED)        		 
    ld		a,h
    and		$1F              		; keep it within first 8k of ROM.
    ld		h,a
    ld		a,(hl)           		; Get "random" number from location.
    inc		hl              		; Increment pointer.
    ld		(SEED),hl
    ret								; RNG

; data
SEED:
	defw	23						; seed 23 fnord
	
NEXT_RNG:							; ic bt bh bw 
									; ic = ink colour (blk, blue, red, mag)
									; bt - building type (50/50 gap/building)
									; bh - building height 2-5 - single UDG for now
									; bw - building width 1-4
	defb	0
	


