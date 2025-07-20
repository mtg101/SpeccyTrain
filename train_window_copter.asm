

SETUP_COPTER:                                       
    ; nowt to do
    ret                                             ; SETUP_COPTER


ANIMATE_COPTER:
    call    RNG                                     ; get our own

    ld      a, (COPTER_COL) 
    cp      0
    jr      z, ANIMATE_DRAW_COPTER_NOT_SHOWING      ; only draw if we should

    ; should we stop showing?
    ld      a, (NEXT_RNG)
    and     %01111111
    cp      %01111111                               ; 1 in 128 stop showing
    jr      nz, ANIMATE_COPTER_CONTINUE                  

    ; draw in top row this frame
    ; draw left copter
 	ld		hl, COPTER_LEFT_PIXELS                  ; don't need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ; draw right copter
	ld		hl, COPTER_RIGHT_PIXELS                 ; don't need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS + 1
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL+1
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ; 0 col means not showing
    ld      a, 0
    ld      (COPTER_COL), a                      

    ret                                             ; ANIMATE_COPTER

ANIMATE_COPTER_CONTINUE:
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

ANIMATE_DRAW_COPTER_NOT_SHOWING:
    ; should we start showing?
    ld      a, (NEXT_RNG)                           ; 1 in 256 start showing
    cp      %11111111                               
    ret     nz                                      ; ANIMATE_COPTER

    ; random col 1-16
    call    RNG                                     ; otherwise it's always same %____1111 position
    ld      a, (NEXT_RNG)
    and     %00001111                               ; 0-15
    inc     a                                       ; 1-16
    ld      (COPTER_COL), a                         ; save to status

    ; draw in top row this frame
    ; draw left copter
	ld		hl, COPTER_LEFT_PIXELS                  ; don't need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ; draw right copter
	ld		hl, COPTER_RIGHT_PIXELS                 ; don't need udgs
	ld		ix, WINDOW_RENDER_PIXEL_BUF_CLOUDS + 1
    ld      bc, (COPTER_COL)                        ; show at COPTOR_COL+1
    add     ix, bc
	call	XOR_CHAR_PIXELS_VIS

    ret                                             ; ANIMATE_COPTER



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

