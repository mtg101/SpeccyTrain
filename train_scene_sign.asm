

ANIMATE_TRAIN_SCENE_SIGN:
	ret									; ANIMATE_TRAIN_SCENE_SIGN





TRAIN_SIGN_MESSAGE_1:
	defb 		"If you see something that doesn't look right, text 61016. See, say it, sorted."
	defb		"       "				; cheating space buffer, when printed sign is clear
	defb		0

TRAIN_SIGN_MESSAGE_2:
	defb 		"ZX Railway hopes you have a pleasant journey."
	defb		"       "				; cheating space buffer, when printed sign is clear
	defb		0

TRAIN_SIGN_MESSAGE_3:
	defb 		"ZX Railway service to Skylab Landing Bay, calling at Central Cavern, "
	defb		"Eugene's Lair, The Endorian Forest and arriving in Skylab Landing at 13:12"
	defb		"       "				; cheating space buffer, when printed sign is clear
	defb		0

TRAIN_SIGN_MESSAGE_4:
	defb 		"ZXR - Better than a car "
	defb		UDG_SIGN_SMILIE
	defb		"       "
	defb		0

; 0 = not displaying
; 1-4 are messages being displayed
TRAIN_SIGN_STATUS:
	defb 		0

