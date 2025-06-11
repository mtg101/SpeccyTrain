; UDGs
NUM_UDGS			= 7

UDG_DITHER			= $90

UDG_FENCE			= $91
UDG_FENCE_ATTR		= %00100000	; green paper, black ink

UDG_WALL			= $92
UDG_WALL_ATTR		= %00100010	; green paper, red ink

UDG_HEDGE			= $93
UDG_HEDGE_ATTR		= %00100001	; green paper, blue ink??? 

UDG_TREE_LOW		= $94
UDG_TREE_LOW_ATTR	= %00100010	; green paper, red ink

UDG_TREE_HIGH		= $95
UDG_TREE_HIGH_ATTR	= %00101010	; cyan paper, red ink (green doesn't show against cyan, so make it autumn :)

UDG_BUILDING		= $96
UDG_BUILDING_ATTR	= %00111000	; white paper blank ink

UDG_ATTRS:
	defb	0				; dither
	defb	UDG_FENCE_ATTR
	defb	UDG_WALL_ATTR
	defb	UDG_HEDGE_ATTR	
	defb	UDG_TREE_LOW_ATTR
	defb	UDG_TREE_HIGH_ATTR
	defb	UDG_BUILDING_ATTR

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
WIN_SKY_ROWS		= 7
WIN_GRASS_ROWS		= 3

WIN_ROW_START		= 6
WIN_COL_START		= 8

WIN_ATTR_START		= ATTR_START + (WIN_ROW_START * 32) + WIN_COL_START	

