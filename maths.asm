
; rand16 from http://z80-heaven.wikidot.com/advanced-math#toc72 
RNG: 								
    ld 		hl, (SEED1)
    ld 		b, h
    ld 		c, l
    add 	hl, hl
    add 	hl, hl
    inc 	l
    add 	hl,bc
    ld 		(SEED1),hl
    ld 		hl,(SEED2)
    add 	hl,hl
    sbc 	a, a
    and 	%00101101
    xor 	l
    ld 		l, a
    ld 		(SEED2),hl
    add 	hl,bc
	ld		(NEXT_RNG), hl			; store in (NEXT_RNG)
    ret								; RNG

; data
SEED1:
	defw	23						; during setup gets overwritten by WAIT_FOR_USER 
                                    ; from train_boarding_scene
                                    ; after waiting for user, to vary sequence each run
SEED2:
	defw	24601					; can't vary this one during setup, as only have one user input
	
NEXT_RNG:
	defw	0
	



