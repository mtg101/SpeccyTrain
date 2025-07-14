

SETUP_COPTER:                                       
    ; nowt to do
    ret                                             ; SETUP_COPTER


ANIMATE_COPTER:
    ld      a, (COPTER_COL) 
    cp      0
    jr      z, DONE_ANIMATE_COPTER                 ; only draw if we should

    ; animate udgs by hand
    ld      a, (FRAME_COUNTER)                      
    and     %00000011                               ; 0-3

    cp      %00000000
    jr      nz, ANIMATE_NOT_0

    ; right on (redundant first time but works)
    ld      hl, COPTER_RIGHT_PIXELS + 1              ; second row
    ld      a, %11111111                            ; all on
    ld      (hl), a                                 ; hack the udg

    jr      ANIMATE_DRAW_COPTER                     ; ready to draw now

ANIMATE_NOT_0:
    cp      %00000001
    jr      nz, ANIMATE_NOT_1

    ; left off (redundant first time but works)
    ld      hl, COPTER_LEFT_PIXELS + 1              ; second row
    ld      a, %00000000                            ; all off
    ld      (hl), a                                 ; hack the udg

    jr      ANIMATE_DRAW_COPTER                     ; ready to draw now

ANIMATE_NOT_1:
    cp      %00000010
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

    ; sound once per loop
    ; sounds crap if you don't tweak it based on other things going on
    ; annoying as hell while debugging, so turned off
    ; ld      hl, C_1_PITCH
    ; ld      de, C_1_DUR_1S / 64
    ; call    BEEP

    ; fall through

ANIMATE_DRAW_COPTER:
    ; draw left copter
	ld		hl, COPTER_LEFT_PIXELS                  ; don't need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS + (WIN_COL_VIS * 8)
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ; draw right copter
	ld		hl, COPTER_RIGHT_PIXELS                 ; don't need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS + 1 + (WIN_COL_VIS * 8)
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL+1
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

DONE_ANIMATE_COPTER:
    ret                                             ; ANIMATE_COPTER

UNDRAW_COPTER_UPDATE_STATUS:          
    call    RNG                                     ; own rng

    ld      a, (COPTER_COL)                         ; check if we're supposed to undraw
    cp      0
    jr      z, UNDRAW_DONT_DRAW                    ; don't need to undraw

    ; left copter
	ld		hl, COPTER_LEFT_PIXELS                  ; dot need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS + (WIN_COL_VIS * 8)
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ; right copter
	ld		hl, COPTER_RIGHT_PIXELS              ; don't; need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS + 1 + (WIN_COL_VIS * 8)
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ; should we stop showing?
    ld      a, (NEXT_RNG)
    and     %01111111
    cp      %01111111                               ; 1 in 128 stop showing
    jr      nz, DONE_STATUS_COPTER                  
    ld      a, 0
    ld      (COPTER_COL), a                      
    jr      DONE_STATUS_COPTER                      ; extra jump over the status update for didn't draw

UNDRAW_DONT_DRAW:
    ; should we start showing?
    ld      a, (NEXT_RNG)                           ; 1 in 256 start showing
    cp      %11111111                               
    jr      nz, DONE_STATUS_COPTER                  

    ; random col 1-16
    call    RNG                                     ; new one to avoid always %11010111 for row
    ld      a, (NEXT_RNG)
    and     %00001111                               ; 0-15
    inc     a                                       ; 1-16
    ld      (COPTER_COL), a                         ; save to status

DONE_STATUS_COPTER:
    ret                                             ; UNDRAW_COPTER_UPDATE_STATUS


COPTER_COL:                                         ; 0 is off, 2-17 col (from 0-15 + 2 rng)
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

