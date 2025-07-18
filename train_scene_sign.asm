

ANIMATE_TRAIN_SCENE_SIGN:
	; are we showing text?
	ld 		a, (TRAIN_SIGN_STATUS)
	cp		0
	jr		nz, ANIMATE_TRAIN_SCENE_SIGN_TEXT

	; so not showing
	call	RNG
	ld		a, (NEXT_RNG)				; should we start text? 
	cp		0 							; 1 in 256 for now
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
LABEL1:

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
	; byte shift the screen

	ld		de, TRAIN_SIGN_LINE_0
	ld		hl, TRAIN_SIGN_LINE_0 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_1
	ld		hl, TRAIN_SIGN_LINE_1 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_2
	ld		hl, TRAIN_SIGN_LINE_2 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_3
	ld		hl, TRAIN_SIGN_LINE_3 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_4
	ld		hl, TRAIN_SIGN_LINE_4 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_5
	ld		hl, TRAIN_SIGN_LINE_5 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_6
	ld		hl, TRAIN_SIGN_LINE_6 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	ld		de, TRAIN_SIGN_LINE_7
	ld		hl, TRAIN_SIGN_LINE_7 + 1
	ldi													; 7 wide, so 6 x ldi
	ldi
	ldi
	ldi
	ldi
	ldi

	; are we done?
	; check 0null terminator
	ld		hl, (TRAIN_SIGN_MESSAGE_PTR)
	ld		a, (hl)
	cp		0
	jr		nz, TRAIN_SIGN_NEXT_CHAR

	; so we're done
	; just set status
	; as space buffer means all text has scrolled off already
	ld		(TRAIN_SIGN_STATUS), a						; a is already 0 from above
	ret													; return early ANIMATE_TRAIN_SCENE_SIGN

TRAIN_SIGN_NEXT_CHAR:
	; write new char on right
	ld		a, 7										 
	ld 		(PRINT_AT_X), a
	ld		a, 11										
	ld 		(PRINT_AT_Y), a
	ld		hl, (TRAIN_SIGN_MESSAGE_PTR)				; hl has ptr to next char
	ld		a, (hl)										; char to print from message ptr
	ld		(PRINT_CHAR), a
	call	PRINT_CHAR_AT_Y_X

	; move ptr along message
	ld 		hl, (TRAIN_SIGN_MESSAGE_PTR)
	inc		hl
	ld 		(TRAIN_SIGN_MESSAGE_PTR), hl

	ret													; ANIMATE_TRAIN_SCENE_SIGN





TRAIN_SIGN_MESSAGE_1:
	defb 	"If you see something that doesn't look right, text 61016."
	defb	"     See it. Say it. Sorted."
	defb	"       "				; cheating space buffer, when printed sign is clear
	defb	0

TRAIN_SIGN_MESSAGE_2:
	defb 	"ZX Railway hopes you have a pleasant journey."
	defb	"       "				; cheating space buffer, when printed sign is clear
	defb	0

TRAIN_SIGN_MESSAGE_3:
	defb 	"ZX Railway service to Skylab Landing Bay.        Calling at Central Cavern, "
	defb	"Eugene's Lair, The Endorian Forest and arriving in Skylab Landing at 13:12"
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

; %010 y7y6 y2y1y0 y5y4y3 x4x3x2x1x0
;
; x=1  > 00001
; y=11, x 8 for pixel row = 88 = 01011000
; bit fuckery = 01 000 011
TRAIN_SIGN_LINE_0	= %0100100001100001
TRAIN_SIGN_LINE_1	= %0100100101100001
TRAIN_SIGN_LINE_2	= %0100101001100001
TRAIN_SIGN_LINE_3	= %0100101101100001
TRAIN_SIGN_LINE_4	= %0100110001100001
TRAIN_SIGN_LINE_5	= %0100110101100001
TRAIN_SIGN_LINE_6	= %0100111001100001
TRAIN_SIGN_LINE_7	= %0100111101100001


