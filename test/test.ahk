#SingleInstance force

JoystickNumber = 1
PoVTick := 64
PoV = ; POV hat, d-pad look up
(
Up
Up + Right
Right
Down + Right
Down
Down + Left
Left
Up + Left
)

StringSplit, PoV, PoV, `n, `r%A_Tab%%A_Space%

	        SetTimer, WatchPOV, %FrameTick%
	        ;SendMode, INPUT
	        PoV0 = ""
#esc::Exitapp

WatchPOV:

global PoV

{
	KeyToHoldDown := (GetKeyState(JoystickNumber "JoyPOV", "p")+4500)//4500
	;if (KeyToHoldDown != 0 && KeyToHoldDownPrev != 0)
	If (KeyToHoldDownPrev != KeyToHoldDown)
	{
		Loop, Parse, PoV%KeyToHoldDownPrev%, +, %A_Tab%%A_Space%
			If A_LoopField 
				Send {blind}{%A_LoopField% up}
		Loop, Parse, PoV%KeyToHoldDown%, +, %A_Tab%%A_Space%
			If A_LoopField 
				Send {blind}{%A_LoopField% down}

		KeyToHoldDownPrev := KeyToHoldDown
		PoVT := A_TickCount
	}
	else if (KeyToHoldDown) && (A_TickCount - PoVT > 500 ) ; auto-repeat
		{
		Loop, Parse, PoV%KeyToHoldDown%, +, %A_Tab%%A_Space%
			If A_LoopField && (PovT += 50)
				Send {blind}{%A_LoopField% down}
		}
}
return
