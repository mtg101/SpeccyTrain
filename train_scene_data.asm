SCENE_CHARACTERS:
	; RLE char, numTimes (max 255 - b is 8bit!), 0 terminated
	; total 32*22=704 (ignoring channel 1 lower area for now)
	defb	'*', 32
	defb	'-', 32
	defb	C_SPACE, 104
	defb	UDG_BORDER_TL, 1
	defb	UDG_BORDER_T, 19
	defb	UDG_BORDER_TR, 1
	defb	C_SPACE, 36
	defb	UDG_BORDER_TL, 1
	defb	UDG_BORDER_T, 3
	defb	UDG_BORDER_TR, 1
	defb	C_SPACE, 27
	defb	UDG_BORDER_L, 1
	defb	'Z', 1
	defb	'X', 1
	defb	'R', 1
	defb	UDG_BORDER_R, 1
	defb	C_SPACE, 27
	defb	UDG_BORDER_BL, 1
	defb	UDG_BORDER_B, 3
	defb	UDG_BORDER_BR, 1
	defb	C_SPACE, 218
	defb	C_UDG_1, 192
	defb	C_SPACE, 64
	defb	0

SCENE_ATTRS:
	; RLE attr, numTime (max 255 - b is lower bit!), 0 terminated
	; total 32*24=768 
	defb	ATTR_RED_PAP, 168
	defb	ATTR_RPBI,    21
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 13
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 6
	defb	ATTR_YPBI, 	  3
	defb	ATTR_RED_PAP, 4
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 13
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 13
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 13
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 13
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 13
	defb	ATTR_CYN_PAP, 19
	defb	ATTR_RED_PAP, 11
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BGRN_PAP, 19
	defb	ATTR_RED_PAP, 1
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 9
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BGRN_PAP, 19
	defb	ATTR_RED_PAP, 1
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 9	
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 21
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 9
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 2
	defb	ATTR_ALL_BLK, 17
	defb	ATTR_RED_PAP, 2
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 9
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 4
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 11
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 4
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 9
	defb	ATTR_ALL_BLK, 3
	defb	ATTR_RED_PAP, 17
	defb	ATTR_ALL_BLK, 3
	defb	ATTR_RED_PAP, 10
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 19
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 11
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 19
	defb	ATTR_ALL_BLK, 1
	defb	ATTR_RED_PAP, 3


	defb	ATTR_ALL_BLK, 64
	defb	0

; UDGs
NUM_SCENE_UDGS		= 9			; max 19, $A2, due to top-RAM interrupts (plus 128k only has 19)

UDG_DITHER			= $90

UDG_BORDER_TL		= $91
UDG_BORDER_T		= $92
UDG_BORDER_TR		= $93
UDG_BORDER_R		= $94
UDG_BORDER_BR		= $95
UDG_BORDER_B		= $96
UDG_BORDER_BL		= $97
UDG_BORDER_L		= $98

UDGS_SCENE_PIXELS:
UDG_DITHER_PIXELS:
	defb	%10101010
	defb	%01010101
	defb	%10101010
	defb	%01010101
	defb	%10101010
	defb	%01010101
	defb	%10101010
	defb	%01010101

UDG_BORDER_TL_PIXELS
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000011
	defb	%00000011

UDG_BORDER_T_PIXELS
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%11111111
	defb	%11111111

UDG_BORDER_TR_PIXELS
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%11000000
	defb	%11000000

UDG_BORDER_R_PIXELS
	defb	%11000000
	defb	%11000000
	defb	%11000000
	defb	%11000000
	defb	%11000000
	defb	%11000000
	defb	%11000000
	defb	%11000000

UDG_BORDER_BR_PIXELS
	defb	%11000000
	defb	%11000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000

UDG_BORDER_B_PIXELS
	defb	%11111111
	defb	%11111111
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000

UDG_BORDER_BL_PIXELS
	defb	%00000011
	defb	%00000011
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000

UDG_BORDER_L_PIXELS
	defb	%00000011
	defb	%00000011
	defb	%00000011
	defb	%00000011
	defb	%00000011
	defb	%00000011
	defb	%00000011
	defb	%00000011



