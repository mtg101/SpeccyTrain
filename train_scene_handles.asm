
; no setup needed
ANIMATE_SCENE_HANDLES:
	ld		a, (FRAME_COUNTER)
	and 	%000011000						; change every few frames
	cp 		%00000000						; mid/left/mid/right
	jp		z, ANIMATE_HANDLES_MID
	cp 		%00001000
	jp 		z, ANIMATE_HANDLES_LEFT
	cp		%00010000
	jr 		z, ANIMATE_HANDLES_MID
	
ANIMATE_HANDLES_RIGHT:
; left
	ld 		a, 4
	ld		(PRINT_AT_Y), a
	ld 		a, 6
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_T_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_M_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 6
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_BM_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BL_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 7
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BR_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

; right
	ld 		a, 4
	ld		(PRINT_AT_Y), a
	ld 		a, 30
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_T_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_M_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 6
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_BM_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 29
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BL_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 31
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BR_RIGHT_PIXELS
	call 	PRINT_DE_AT_Y_X

	jp		ANIMATE_SCENE_HANDLES_DONE		; skip to  end

ANIMATE_HANDLES_MID:
; left
	ld 		a, 4
	ld		(PRINT_AT_Y), a
	ld 		a, 6
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_T_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_M_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 6
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_BM_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BL_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 7
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BR_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

; right
	ld 		a, 4
	ld		(PRINT_AT_Y), a
	ld 		a, 30
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_T_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_M_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 6
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_BM_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 29
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BL_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 31
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BR_MID_PIXELS
	call 	PRINT_DE_AT_Y_X

	jr		ANIMATE_SCENE_HANDLES_DONE		; skip to  end

ANIMATE_HANDLES_LEFT:
; left
	ld 		a, 4
	ld		(PRINT_AT_Y), a
	ld 		a, 6
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_T_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_M_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 6
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_BM_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BL_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 7
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BR_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

; right
	ld 		a, 4
	ld		(PRINT_AT_Y), a
	ld 		a, 30
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_T_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 5
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_M_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 6
	ld		(PRINT_AT_Y), a
	ld		de, HANDLES_BM_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 29
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BL_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	ld 		a, 31
	ld		(PRINT_AT_X), a
	ld		de, HANDLES_BR_LEFT_PIXELS
	call 	PRINT_DE_AT_Y_X

	jr		ANIMATE_SCENE_HANDLES_DONE		; skip to  end

ANIMATE_SCENE_HANDLES_DONE:
	ret										; ANIMATE_SCENE_HANDLES


HANDLES_T_LEFT_PIXELS:
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00110000

HANDLES_M_LEFT_PIXELS:
	defb	%00110000
	defb	%00110000
	defb	%00110000
	defb	%01100000
	defb	%01100000
	defb	%01100000
	defb	%01100000
	defb	%01100000

HANDLES_BL_LEFT_PIXELS:
	defb	%00000001
	defb	%00000111
	defb	%00000111
	defb	%00001111
	defb	%00001111
	defb	%00000111
	defb	%00000111
	defb	%00000001

HANDLES_BM_LEFT_PIXELS:
	defb	%11000000
	defb	%11100000
	defb	%11100000
	defb	%11110000
	defb	%11100000
	defb	%11100000
	defb	%11000000
	defb	%10000000

HANDLES_T_MID_PIXELS:
HANDLES_M_MID_PIXELS:
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000

HANDLES_BM_MID_PIXELS:
	defb	%00111100
	defb	%01111110
	defb	%01111110
	defb	%11111111
	defb	%11111111
	defb	%01111110
	defb	%01111110
	defb	%00011000

HANDLES_T_RIGHT_PIXELS:
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00001100

HANDLES_M_RIGHT_PIXELS:
	defb	%00001100
	defb	%00001100
	defb	%00001100
	defb	%00000110
	defb	%00000110
	defb	%00000110
	defb	%00000110
	defb	%00000011

HANDLES_BM_RIGHT_PIXELS:
	defb	%00000011
	defb	%00000111
	defb	%00000111
	defb	%00001111
	defb	%00000111
	defb	%00000111
	defb	%00000011
	defb	%00000001

HANDLES_BR_RIGHT_PIXELS:
	defb	%10000000
	defb	%11100000
	defb	%11100000
	defb	%11110000
	defb	%11110000
	defb	%11100000
	defb	%11100000
	defb	%10000000

HANDLES_BR_LEFT_PIXELS:
HANDLES_BL_MID_PIXELS:
HANDLES_BR_MID_PIXELS:
HANDLES_BL_RIGHT_PIXELS:
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000

