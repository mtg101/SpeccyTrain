; udgs etc
	INCLUDE "train_window_data.asm"
	INCLUDE "train_window_buildings.asm"
	INCLUDE "train_window_building_gaps.asm"
	INCLUDE "train_window_clouds.asm"
	INCLUDE "train_window_fg.asm"
	INCLUDE "train_window_copter.asm"
	INCLUDE "train_window_mountains.asm"

	
SETUP_WINDOW:
	call	LOAD_WINDOW_UDGS
	call	SETUP_CLOUDS
	call 	SETUP_COPTER
	call 	SETUP_MOUNTAINS
	call	SETUP_BUILDINGS		
	call	SETUP_FG
	call	BUF_CLOUD_CHAR_ROWS		; draw initisl clouds to pixel buffer
	call	BUF_BUILDING_CHAR_ROWS	; draw initisl buildings to pixel buffer
	ret								; SETUP_WINDOW

LOAD_WINDOW_UDGS:
	ld		de, UDG_START			; first UDG addr
	ld		hl, UDGS_WINDOW_PIXELS	; my UDGs
	ld		bc, NUM_WINDOW_UDGS * 8	; loop
	ldir
	ret								; LOAD_UDGS

	; NEXT_RNG low byte used for window procgen, buildings are:
		; ic bt bh bw 
		; ic = ink colour (blk, blue, red, mag)
		; bt - building type (50/50 gap/building)
		; bh - building height 2-5 - single UDG for now
		; bw - building width 1-4
	


