
SETUP_CLOUDS:
	ld		b, WIN_CLOUD_ROWS * WIN_COL_TOTAL
	ld		c, C_SPACE				; everything is spaces
	ld		a, %00101111			; everything cyan pap, white ink
	ld		hl, CLOUD_CHAR_BUF
	ld		de, CLOUD_ATTR_BUF
SETUP_CLOUD_LOOP:
	ld		(hl), c
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_CLOUD_LOOP
	ret								; SETUP_CLOUDS

ANIMATE_CLOUDS:
	ret								; ANIMATE_CLOUDS

