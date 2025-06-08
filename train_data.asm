SCENE_CHARACTERS:
	; RLE char, numTimes (max 255 - b is 8bit!), 0 terminated
	; total 32*22=704 (ignoring channel 1 lower area for now)
	defb	'*', 32
	defb	'-', 32
	defb	$86, 128
	defb	C_SPACE, 33
	defb	$84, 1
	defb	$8C, 3
	defb	$88, 1
	defb	C_SPACE, 27
	defb	$85, 1
	defb	'Z', 1
	defb	'X', 1
	defb	'R', 1
	defb	$8A, 1
	defb	C_SPACE, 27
	defb	$81, 1
	defb	$83, 3
	defb	$82, 1
	defb	C_SPACE, 218
	defb	C_UDG_1, 192
	defb	0

SCENE_ATTRS:
	; RLE attr, numTime (max 255 - b is lower bit!), 0 terminated
	; total 32*24=768 (ignoring channel 1 lower area for now)
	defb	ATTR_RED_PAP, 200
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 6
	defb	ATTR_YPBI, 3
	defb	ATTR_RED_PAP, 3
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_CYN_PAP, 20
	defb	ATTR_RED_PAP, 12
	defb	ATTR_GRN_PAP, 20
	defb	ATTR_RED_PAP, 10
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_GRN_PAP, 20
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_GRN_PAP, 20
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8	
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 22
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8	
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 2
	defb	ATTR_BLK_PAP, 18
	defb	ATTR_RED_PAP, 2
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 4
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 12
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 4
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 3
	defb	ATTR_RED_PAP, 18
	defb	ATTR_BLK_PAP, 3
	defb	ATTR_RED_PAP, 9
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 20
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 10
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 20
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 3


	defb	ATTR_BLK_PAP, 64
	defb	0

; UDGs
NUM_UDGS			= 7

UDG_DITHER			= $90

UDG_FENCE			= $91
UDG_FENCE_COL		= COL_BLK

UDG_WALL			= $92
UDG_WALL_COL		= COL_RED

UDG_HEDGE			= $93
UDG_HEDGE_COL		= COL_GRN

UDG_TREE_LOW		= $94
UDG_TREE_LOW_COL	= COL_RED

UDG_TREE_HIGH		= $95
UDG_TREE_HIGH_GRN	= COL_GRN

UDG_BUILDING		= $96
UDG_BUILDING_COL	= COL_BLK

UDGS:
; UDG_DITHER
	defb	%10101010
	defb	%01010101
	defb	%10101010
	defb	%01010101
	defb	%10101010
	defb	%01010101
	defb	%10101010
	defb	%01010101

; UDG_FENCE
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%01010101
	defb	%11111111
	defb	%10101010
	defb	%10101010

; UDG_WALL
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%11111111
	defb	%01010101
	defb	%10101010
	defb	%10101010
	defb	%01010101

; UDG_HEDGE
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%00000000
	defb	%01110100
	defb	%01111110
	defb	%11111111

; UDG_TREE_LOW
	defb	%00011000
	defb	%00011000
	defb	%00011000
	defb	%00011100
	defb	%00011000
	defb	%00011000
	defb	%00111100
	defb	%01111100

; UDG_TREE_HIGH
	defb	%00011000
	defb	%00111100
	defb	%01111110
	defb	%01111110
	defb	%01111100
	defb	%00111100
	defb	%00111100
	defb	%00011000

; UDG_BUILDING
	defb	%11111111
	defb	%10000001
	defb	%10000001
	defb	%10000001
	defb	%10000001
	defb	%11111111
	defb	%11111111
	defb	%11111111

; window details
WIN_COL_VIS			= 20				; 20 vis, 4 extra buf
WIN_ROWS			= 10
WIN_COL_TOTAL		= 24

WIN_ROW_START		= 6
WIN_COL_START		= 8



