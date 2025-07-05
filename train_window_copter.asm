

SETUP_COPTER:
    ret                                             ; SETUP_COPTER


ANIMATE_COPTER:
    call    RNG                                     ; own rng

    ld      a, (COPTER_STATUS)
    cp      1
    call    z, DRAW_COPTER
    call    nz, DONT_DRAW_COPTER

    ret                                             ; ANIMATE_COPTER


DRAW_COPTER:
    push    af                                      ; needed for don't draw check



    ; update status
    ld      a, (NEXT_RNG)
    and     %01111111
    cp      %01111111                           
    jr      nz, DONE_DRAW_COPTER                    ; 1 in 128 stop showing
    ld      a, 0
    ld      (COPTER_STATUS), a                      ; don't draw

DONE_DRAW_COPTER:
    pop     af                                      ; needed for don't draw check
    ret                                             ; DRAW_COPTER


DONT_DRAW_COPTER:




    ; update status
    ld      a, (NEXT_RNG)
    cp      %11111111                           
    jr      nz, DONE_DRAW_COPTER                    ; 1 in 256 show
    ld      a, 1
    ld      (COPTER_STATUS), a                      ; draw now

    ret                                             ; DRAW_COPTER



UNDRAW_COPTER:
    ret                                             ; UNDRAW_COPTER


COPTER_STATUS:                                      ; on / off for now, but can get more complicated
    defb    0   



