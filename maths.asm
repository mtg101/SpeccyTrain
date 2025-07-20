
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

; seeds are static for setup
; but then we wait for user to press space and use coutners to ramdomize seeds for animation
SEED1:
	defw	255
SEED2:
	defw	1312					
	
NEXT_RNG:
	defw	0
	



