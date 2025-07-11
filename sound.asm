; safe beep (preserves registers, especially af...)
; hl = Pitch = 437500 / Frequency – 30.125
; de = Duration = Frequency * Seconds
BEEP:
    push af
    push bc
    push ix

    call ROM_BEEPER                         ; Call BEEPER from ROM

    pop  ix
    pop  bc
    pop  af

    ret                                 ; BEEP

; a is FRAME_COUNTER when called from ANIMATE_MAIN
BADUM_BADUM:
    and     %01111111                   ; sound every 128 frames 

    cp      %01110000                   ; doesn't start right away
    jr      z, BADUM_BA
    
    cp      %01110001                   ; DUM shortly after BA
    jr      z, BADUM_DUM

    cp      %01111000                   ; bigger gap to second BA
    jr      z, BADUM_BA

    cp      %01111001                   ; DUM shortly after BA
    jr      z, BADUM_DUM

    ret                                 ; BADUM_BADUM

BADUM_BA:
    ld      hl, C_3_PITCH
    ld      de, C_3_DUR_1S / 256
    call    BEEP
    ret                                 ; BADUM_BADUM

BADUM_DUM:
    ld      hl, C_2_PITCH
    ld      de, C_2_DUR_1S / 256
    call    BEEP
    ret                                 ; BADUM_BADUM




; notes but note: these from AI, slightly different from code I've seen
; but not far off, and i'm just doing clicks, and internally consistent...
; all are listed 1s so divde when calling for clicks, eg /32

C_1_PITCH      = $3425                  
C_1_DUR_1S     = $0021                  

C_2_PITCH      = $19F2                  
C_2_DUR_1S     = $0041                  

C_3_PITCH      = $0CF2                  
C_3_DUR_1S     = $0083                  

C_4_PITCH      = $066A
C_4_DUR_1S     = $0106                  

C_5_PITCH      = $0326
C_5_DUR_1S     = $020B                  

