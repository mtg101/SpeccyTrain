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
	defb	ATTR_B_GRN_PAP, 20
	defb	ATTR_RED_PAP, 10
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_B_GRN_PAP, 20
	defb	ATTR_RED_PAP, 1
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 8
	defb	ATTR_BLK_PAP, 1
	defb	ATTR_RED_PAP, 1
	defb	ATTR_B_GRN_PAP, 20
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
