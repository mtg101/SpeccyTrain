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

ATTR_RED_PAP	= %00010000
ATTR_CYN_PAP	= %00101000
ATTR_GRN_PAP	= %00100000


; ROM calls
ROM_CLS			= $0DAF					; cls and open Channel 2 
ROM_BORDER		= $229B					; set border to value in a

; system vars
UDG_START		= $FF58
ATTR_START		= $5800

