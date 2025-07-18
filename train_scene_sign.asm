

ANIMATE_TRAIN_SCENE_SIGN:
	; are we showing text?
	ld 		a, (TRAIN_SIGN_STATUS)
	cp		0
	jr		nz, ANIMATE_TRAIN_SCENE_SIGN_TEXT

	; so not showing
	ld 		a, (FRAME_COUNTER)
	and		%00000001
	cp		0
	jr		z, ANIMATE_TRAIN_SCENE_CAN_TURN_ON

	ret									; frame counter must be 0 for nybble logic

ANIMATE_TRAIN_SCENE_CAN_TURN_ON:
	call	RNG
	ld		a, (NEXT_RNG)				; should we start text? 
	and 	%00011111					; 1 in 32, ev other frame is like in 64, often but want to see
	cp		0 							
	ret		nz							; keep not showing, return early from ANIMATE_TRAIN_SCENE_SIGN

	; turn on text

	; 1 in 4 random which message
	; new rng for it
	call	RNG
	ld		a, (NEXT_RNG)				
	and		%00000011					; 0-3
	cp 		0
	jr 		z, ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_1

	cp 		1
	jr 		z, ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_2

	cp 		2
	jr 		z, ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_3

; fall through to...

ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_4:
	ld		hl, TRAIN_SIGN_MESSAGE_4
	jr 		ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_GOT

ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_3:
	ld		hl, TRAIN_SIGN_MESSAGE_3
	jr 		ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_GOT

ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_2:
	ld		hl, TRAIN_SIGN_MESSAGE_2
	jr 		ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_GOT

ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_1:
	ld		hl, TRAIN_SIGN_MESSAGE_1
; fall through to...

ANIMATE_TRAIN_SCENE_SIGN_MESSAGE_GOT:
	ld 		(TRAIN_SIGN_MESSAGE_PTR), hl				; point to the start of the message

	; flip status
	ld		a, 1
	ld 		(TRAIN_SIGN_STATUS), a

; fall through and start drawing...

ANIMATE_TRAIN_SCENE_SIGN_TEXT:
	; get next char
	ld		hl, (TRAIN_SIGN_MESSAGE_PTR)
	ld		a, (hl)

	; if it's the null terminator, we're done - spaces already took care of clearing
	cp 		0
	jr		nz, ANIMATE_TRAIN_SCENE_DRAW
	; just need to flip status
	ld		a, 0
	ld		(TRAIN_SIGN_STATUS), a
	ret											; just out of here...

ANIMATE_TRAIN_SCENE_DRAW:
	; get char pixels in hl
	ld 		(PRINT_CHAR), a								
	call 	PRINT_CHAR_PIXEL_MEM						

	; get frame counter 
	; 0 - high nybble
	; 1 - low nybble, move message ptr
	ld 		a, (FRAME_COUNTER)
	and		%00000001
	ld 		c, a								; store in c

	ld 		de, hl								; hl needed for rld

; pixel row 0
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_0			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_0:
	ld		hl, TRAIN_SIGN_LINE_END_0
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 1
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_1			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_1:
	ld		hl, TRAIN_SIGN_LINE_END_1
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 2
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_2			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_2:
	ld		hl, TRAIN_SIGN_LINE_END_2
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 3
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_3			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_3:
	ld		hl, TRAIN_SIGN_LINE_END_3
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 4
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_4			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_4:
	ld		hl, TRAIN_SIGN_LINE_END_4
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 5
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_5			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_5:
	ld		hl, TRAIN_SIGN_LINE_END_5
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 6
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	inc		de									; move to next byte of pixels
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_6			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_6:
	ld		hl, TRAIN_SIGN_LINE_END_6
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

; pixel row 7
	ld		a, c
	cp		0									; 0 means have to shift
	ld		a, (de)								; grab pixels now
	jr		nz, TRAIN_SIGN_NYBBLE_GOT_7			; 1 low nybble, don't need to do anything

	; 0 so high nybble - and don't care about high bits in a, so just shift
	rra
	rra
	rra
	rra
TRAIN_SIGN_NYBBLE_GOT_7:
	ld		hl, TRAIN_SIGN_LINE_END_7
	; nybble shift
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 
	dec 	hl
	rld 

	; frame counter bit 0: 1 is move ptr
	ld		a, c
	cp		0
	jr		z, ANIMATE_TRAIN_SCENE_SIGN_TEXT_DONE

	; move ptr
	ld 		hl, (TRAIN_SIGN_MESSAGE_PTR)
	inc		hl  
	ld		(TRAIN_SIGN_MESSAGE_PTR), hl

ANIMATE_TRAIN_SCENE_SIGN_TEXT_DONE:
	ret											; ANIMATE_TRAIN_SCENE_SIGN_TEXT




TRAIN_SIGN_MESSAGE_1:
	defb 	"If you see something that doesn't look right, text 61016."
	defb	"     See it. Say it. Sorted."
	defb	"       "				; cheating space buffer, when printed sign is clear
	defb	0

TRAIN_SIGN_MESSAGE_2:
	defb 	"Scan the QR code on your table to order bento "
	defb 	UDG_SIGN_BENTO
	defb 	" banchan "
	defb 	UDG_SIGN_BANCHAN
	defb 	" and drinks "
	defb 	UDG_SIGN_DRINKS
	defb	"       "				; cheating space buffer, when printed sign is clear
	defb	0

TRAIN_SIGN_MESSAGE_3:
	defb 	"ZX Railway service to Skylab Landing Bay.        Calling at Central Cavern, "
	defb	"Eugene's Lair, The Endorian Forest and arriving in Skylab Landing Bay at 13:12"
	defb	"       "				; cheating space buffer, when printed sign is clear
	defb	0

TRAIN_SIGN_MESSAGE_4:
	defb 	"ZXR - Better than a car "
	defb	UDG_SIGN_SMILIE
	defb	"       "
	defb	0

; 0 = not displaying
TRAIN_SIGN_STATUS:
	defb 	0

; points to where we are in a message
TRAIN_SIGN_MESSAGE_PTR:
	defw 	0

; screen maths...
; points to end of sign, not the start, as we're walking backward

; %010 y7y6 y2y1y0 y5y4y3 x4x3x2x1x0
;
; x=8  > 01000
; y=11, x 8 for pixel row = 88 = 01011000
; bit fuckery = 01 000 011
TRAIN_SIGN_LINE_END_0	= %0100100001100111 ; hack to 7???/
TRAIN_SIGN_LINE_END_1	= %0100100101100111
TRAIN_SIGN_LINE_END_2	= %0100101001100111
TRAIN_SIGN_LINE_END_3	= %0100101101100111
TRAIN_SIGN_LINE_END_4	= %0100110001100111
TRAIN_SIGN_LINE_END_5	= %0100110101100111
TRAIN_SIGN_LINE_END_6	= %0100111001100111
TRAIN_SIGN_LINE_END_7	= %0100111101100111


