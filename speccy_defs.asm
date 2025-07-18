; character codes 
C_ENTER			= $0D
C_AT			= $16
C_UDG_1			= $90
C_SPACE			= $20

; colours
COL_BLK			= $0            ; 000
COL_BLU			= $1            ; 001
COL_RED			= $2            ; 010
COL_MAG			= $3            ; 011
COL_GRN			= $4            ; 100
COL_CYN			= $5            ; 101
COL_YEL			= $6            ; 110
COL_WHT			= $7            ; 111
COL_C_INK		= $10
COL_C_PAP		= $11
COL_C_FLA		= $12
COL_C_BRI		= $13

; f b ppp iii (flash, bright, paper, ink)
ATTR_ALL_BLK	= %01000000
ATTR_ALL_BLU	= %00001001
ATTR_RED_PAP	= %00010000
ATTR_BRED_PAP	= %01010000
ATTR_CYN_PAP	= %00101000
ATTR_BGRN_PAP	= %01100000
ATTR_GRN_PAP	= %00100000
ATTR_ALL_WHT	= %00111111
ATTR_YPBI		= %00110001
ATTR_BPYI		= %00001110
ATTR_BKPYI		= %00000110
ATTR_BYPBI		= %01110001
ATTR_WPBI		= %00111000
ATTR_CPRI       = %00101010
ATTR_RPCI       = %00010101
ATTR_RPBI		= %00010001
ATTR_RPGI       = %00010100
ATTR_RPYI		= %00010110
ATTR_BRPYI		= %01010110
ATTR_RPWI		= %00010111
ATTR_BRPWI		= %01010111



; ROM calls
ROM_CLS			= $0DAF					; cls and open Channel 2 
ROM_BORDER		= $229B					; set border to value in a
ROM_BEEPER      = $03B5                 ; hl pitch, de duration (based on pitch...)
                                        ; HL = Pitch = 437500 / Frequency – 30.125
                                        ; DE = Duration = Frequency * Seconds

; system vars
UDG_START		= $FF58
ATTR_START		= $5800
SCREEN_START	= $4000
MASK_P			= $5C8E					; set bits take from existing color, not ATTR_P
ATTR_P			= $5C8D					; current ATTRs
ROM_TOP			= $3FFF
ROM_CHARS		= $3D00					; pixels
MAX_ROM_CHAR	= $8F
BORDCR          = $5C48                 ; Border colour * 8; (currently using ROM_BORDER call)
                                        ; also contains the attributes normally used for the lower half of the screen.
                                        ; only useful for reading, actually setting the border requires OUT (254, a) 
                                        ; where a is the colour (not * 8)

; screen sizes
NUM_SCREEN_PIXELS	= $C000
NUM_SCREEN_ATTRS	= $300
NUM_SCREEN_2_CHARS	= $02C0
NUM_SCREEN_CHARS	= $300

SCREEN_COLUMNS	= 32
SCREEN_2_ROWS	= 22
SCREEN_ALL_ROWS = 24
SCREEN_1_ROWS	= 2

SCREEN_255_REST	= $C2					; for 255/255/rest limit loops
