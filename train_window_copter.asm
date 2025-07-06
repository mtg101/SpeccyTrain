

SETUP_COPTER:                                       
    ; nowt to do
    ret                                             ; SETUP_COPTER


ANIMATE_COPTER:
    ld      a, (COPTER_STATUS)                      
    cp      1                                       
    jr      nz, DONE_ANIMATE_COPTER                 ; only draw if we should

    ; animate udgs by hand
    ld      a, (FRAME_COUNTER)                      ; but we only get called every other frame
    and     %00000110                               ; so we look at next bits, act like base bits to us

    cp      %00000000
    jr      nz, ANIMATE_NOT_0

    ; right on (redundant first time but works)
    ld      hl, COPTER_RIGHT_PIXELS + 1              ; second row
    ld      a, %11111111                            ; all on
    ld      (hl), a                                 ; hack the udg

    jr      ANIMATE_DRAW_COPTER                     ; ready to draw now

ANIMATE_NOT_0:
    cp      %00000010
    jr      nz, ANIMATE_NOT_1

    ; left off (redundant first time but works)
    ld      hl, COPTER_LEFT_PIXELS + 1              ; second row
    ld      a, %00000000                            ; all off
    ld      (hl), a                                 ; hack the udg

    jr      ANIMATE_DRAW_COPTER                     ; ready to draw now

ANIMATE_NOT_1:
    cp      %00000100
    jr      nz, ANIMATE_NOT_2

    ; left on (redundant first time but works)
    ld      hl, COPTER_LEFT_PIXELS + 1              ; second row
    ld      a, %00011111                            ; blade on
    ld      (hl), a                                 ; hack the udg

    jr      ANIMATE_DRAW_COPTER                     ; ready to draw now

ANIMATE_NOT_2:                                      ; it's %000001100
    ; right off
    ld      hl, COPTER_RIGHT_PIXELS + 1             ; second row
    ld      a, %11000000                            ; still pillar
    ld      (hl), a                                 ; hack the udg

    ; fall through

ANIMATE_DRAW_COPTER:
    ; draw left copter
	ld		hl, COPTER_LEFT_PIXELS              ; don't need udgs
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 10 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

    ; draw right copter
	ld		hl, COPTER_RIGHT_PIXELS                 ; don't need udgs
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 11 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

DONE_ANIMATE_COPTER:    
    ret                                             ; ANIMATE_COPTER

UNDRAW_COPTER_UPDATE_STATUS:          
    call    RNG                                     ; own rng

    ld      a, (COPTER_STATUS)                      ; check if we're supposed to undraw
    cp      1
    jr      nz, UNDRAW_DONT_DRAW                    ; don't need to undraw

    ; left copter
	ld		hl, COPTER_LEFT_PIXELS                  ; dot need udgs
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 10 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

    ; right copter
	ld		hl, COPTER_RIGHT_PIXELS              ; don't; need udgs
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 11 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

    ; should we stop showing?
    ld      a, (NEXT_RNG)
    and     %01111111
    cp      %01111111                           
    jr      nz, DONE_STATUS_COPTER                  ; 1 in 128 stop showing
    ld      a, 0
    ld      (COPTER_STATUS), a                      
    jr      DONE_STATUS_COPTER                      ; extra jump over the status update for didn't draw

UNDRAW_DONT_DRAW:
    ; should we start showing?
    ld      a, (NEXT_RNG)
    cp      1
    jr      nz, DONE_STATUS_COPTER                  ; 1 in 256 start showing
    ld      a, 1
    ld      (COPTER_STATUS), a                      


DONE_STATUS_COPTER:
    ret                                             ; UNDRAW_COPTER_UPDATE_STATUS


COPTER_STATUS:                                      ; on / off for now, but can get more complicated
    defb    0   

COPTER_LEFT_PIXELS:
	defb	%00000000
	defb	%00011111
	defb	%00000000
	defb	%01000111
	defb	%11111111
	defb	%01000111
	defb	%00000000
	defb	%00000011

COPTER_RIGHT_PIXELS:
	defb	%11000000
	defb	%11111111
	defb	%11000000
	defb	%11111110
	defb	%11110010
	defb	%11111110
	defb	%11000000
	defb	%11110000

