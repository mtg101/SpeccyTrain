	DEVICE ZXSPECTRUM48 			; needed for SNA export (must be tab indented)
	org $8000
	
	INCLUDE "speccy_defs.asm"		; must be indented
	

START:
	call	DRAW_SCENE
  
  
  
  


END:
	ret
  
 
DRAW_SCENE:
; draw characters


; draw 

	ret

SCENE_CHARACTERS:
	; RLE char, numTimes (max 255 - b is 8bit!)
	; total 32*22=704 (ignoring channel 1 lower area for now)
	defb	C_SPACE, 255
	defb	C_SPACE, 255
	defb	C_SPACE, 194

SCENE_ATTRS:
	; RLE attr, numTime (max 255 - b is lower bit!)
	; total 32*24=768 (ignoring channel 1 lower area for now)

 
  
; Deployment: Snapshot
   SAVESNA 	"speccy_train.sna", START
   