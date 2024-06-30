SetTimer, ScreenShot, -1		; to start it once immediately
SetTimer, ScreenShot, 30000	; 5 min = 5 * 60000
return

#^X::ExitApp

ScreenShot:
Clipboard=
Send {PrintScreen Down}{PrintScreen Up}
;ClipWait,, 1
return