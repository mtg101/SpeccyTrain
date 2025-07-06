

SETUP_COPTER:                                       
    ; nowt to do
    ret                                             ; SETUP_COPTER


ANIMATE_COPTER:
    call    RNG                                     ; own rng

    ld      a, (COPTER_STATUS)                      
    cp      1                                       
    jr      nz, DONE_ANIMATE_COPTER                          ; only draw if we should

    ; left copter
	ld		hl, UDG_COPTER_LEFT_PIXELS              ; we know the udg at compile time, so just point
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 10 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

    ; right copter
	ld		hl, UDG_COPTER_RIGHT_PIXELS              ; we know the udg at compile time, so just point
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 11 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

DONE_ANIMATE_COPTER:    
    ret                                             ; ANIMATE_COPTER

UNDRAW_COPTER_UPDATE_STATUS:                                      
    ld      a, (COPTER_STATUS)                      ; check if we're supposed to undraw
    cp      1
    jr      nz, UNDRAW_DONT_DRAW                    ; don't need to undraw

    ; left copter
	ld		hl, UDG_COPTER_LEFT_PIXELS              ; we know the udg at compile time, so just point
    ; fixed position in second row
	ld		ix, CLOUDS_LAYER_PIXEL_BUF + 10 + ((WIN_COL_VIS + 1) * 8)
	call	XOR_CHAR_PIXELS

    ; right copter
	ld		hl, UDG_COPTER_RIGHT_PIXELS              ; we know the udg at compile time, so just point
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



