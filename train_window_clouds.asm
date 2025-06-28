
SETUP_CLOUDS:
	ld		b, WIN_CLOUD_ROWS * WIN_COL_TOTAL
	ld		a, %00101111			; everything cyan pap, white ink
	ld		de, CLOUD_ATTR_BUF
SETUP_CLOUD_ATTR_LOOP:
	ld		(de), a
	inc		hl
	inc		de
	djnz	SETUP_CLOUD_ATTR_LOOP

; chars
	ld		a, %00000000			; blank
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; 8 byte buf
	ld		(hl), a					; 0
	inc		hl
	ld		(hl), a					; 1
	inc		hl
	ld		(hl), a					; 2
	inc		hl
	ld		(hl), a					; 3
	inc		hl
	ld		(hl), a					; 4
	inc		hl
	ld		(hl), a					; 5
	inc		hl
	ld		(hl), a					; 6
	inc		hl
	ld		(hl), a					; 7

	ld		b, (WIN_COL_VIS+1) 		
	ld		ix, CLOUD_LAYER_PIXEL_BUF		; first row
SETUP_CLOUD_CHAR_LOOP_1:
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; call trashes it so have to reload every loop
	call	BUF_CHAR_PIXELS
	inc		ix
	djnz	SETUP_CLOUD_CHAR_LOOP_1

	ld		b, (WIN_COL_VIS+1) 		
	ld		ix, CLOUD_LAYER_PIXEL_BUF + ((WIN_COL_VIS+1) * 8)		; second row
SETUP_CLOUD_CHAR_LOOP_2:
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; call trashes it so have to reload every loop
	call	BUF_CHAR_PIXELS
	inc		ix
	djnz	SETUP_CLOUD_CHAR_LOOP_2

	ld		b, (WIN_COL_VIS+1) 		
	ld		ix, CLOUD_LAYER_PIXEL_BUF + ((WIN_COL_VIS+1) * 8 * 2)		; third row
SETUP_CLOUD_CHAR_LOOP_3:
	ld		hl, SINGLE_CHAR_PIXEL_BUF	; call trashes it so have to reload every loop
	call	BUF_CHAR_PIXELS
	inc		ix
	djnz	SETUP_CLOUD_CHAR_LOOP_3

	ret								; SETUP_CLOUDS

ANIMATE_CLOUDS:
	ret								; ANIMATE_CLOUDS

