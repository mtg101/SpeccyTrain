
SETUP_MOUNTAINS:
	; attrs
	ld		b, (WIN_MOUNTAIN_ROWS-1) * WIN_COL_TOTAL	; not the cloud row
	ld		a, %00101000								; everything black ink (to show errors) over cyan pap
	ld		de, MOUNTAINS_ATTR_BUF						; not the cloud
SETUP_MOUNTAIN_ATTRS_LOOP:
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_MOUNTAIN_ATTRS_LOOP

	ret									; SETUP_MOUNTAINSS

ANIMATE_MOUNTAINS:
	call 	MOUNTAINS_LAYER_TO_RENDER
	ret									; ANIMATE_MOUNTAINSS

MOUNTAINS_LAYER_TO_RENDER:
	; attrs
	; top row is clouds, they dictat attrs,
	ld		de, RENDER_ATTR_BUF_ROW_3
	ld		hl, MOUNTAINS_ATTR_BUF + WIN_COL_TOTAL
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_4
	ld		hl, MOUNTAINS_ATTR_BUF + (WIN_COL_TOTAL * 2)
	ld		bc, WIN_COL_VIS
	ldir

	ld		de, RENDER_ATTR_BUF_ROW_5
	ld		hl, MOUNTAINS_ATTR_BUF + (WIN_COL_TOTAL * 3)
	ld		bc, WIN_COL_VIS
	ldir

	ret									; MOUNTAINSS_LAYER_TO_RENDER

MOUNTAINSS_LAYER_PIXEL_BUF:
	defs		(WIN_COL_VIS+1) * WIN_MOUNTAIN_ROWS * 8

