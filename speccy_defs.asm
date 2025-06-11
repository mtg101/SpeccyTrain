; character codes 
C_ENTER			= $0D
C_AT			= $16
C_UDG_1			= $90
C_SPACE			= $20

; colours
COL_BLK			= $0
COL_BLU			= $1
COL_RED			= $2
COL_MAG			= $3
COL_GRN			= $4
COL_CYN			= $5
COL_YEL			= $6
COL_WHT			= $7
COL_C_INK		= $10
COL_C_PAP		= $11
COL_C_FLA		= $12
COL_C_BRI		= $13

; f b ppp iii (flash, bright, paper, ink)
ATTR_ALL_BLK	= %01000000
ATTR_RED_PAP	= %00010000
ATTR_CYN_PAP	= %00101000
ATTR_GRN_PAP	= %00100000
ATTR_ALL_WHT	= %00111111
ATTR_YPBI		= %00110001
ATTR_WPBI		= %00111000


; ROM calls
ROM_CLS			= $0DAF					; cls and open Channel 2 
ROM_BORDER		= $229B					; set border to value in a
ROM_PRINT		= $203C					; de point to text in mem, bc is length
ROM_CHAR_PRINT	= $10					; RST $10

; system vars
UDG_START		= $FF58
ATTR_START		= $5800
SCREEN_START	= $4000
MASK_P			= $5C8E					; set bits take from existing color, not ATTR_P
ATTR_P			= $5C8D					; current ATTRs

; screen sizes
SCREEN_PIXELS	= $C000
SCREEN_ATTRS	= $300
SCREEN_2_CHARS	= $02C0

SCREEN_COLUMNS	= 32
SCREEN_2_ROWS	= 22
SCREEN_ALL_ROWS = 24
SCREEN_1_ROWS	= 2

SCREEN_255_REST	= $C2					; for 255/255/rest limit loops
