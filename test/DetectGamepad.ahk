; d-pad = arrow keys
; A = A
; B = B
; X = X
; Y = Y
; R1 = L
; R2 = R
; L1 = L
; L2 = R
; START = 1
; SELECT = 5

; a1 = A
; b2 = B
; x3 = X
; y4 = Y
; lb5 = L
; lbr6 = L
; start8 = 1
; select7 = 5
; ltrigger/ Z > 60 = R
; rtrigger/ Z < 40 = R



JoystickNumber = 0
JoysticksArray := Object()
JoysticksArrCnt = 0

; END OF CONFIG SECTION. Do not make changes below this point unless
; you wish to alter the basic functionality of the script.

; Auto-detect the joystick number if called for:
if JoystickNumber <= 0
{
	Loop 16  ; Query each joystick number to find out which ones exist.
	{
		GetKeyState, JoyName, %A_Index%JoyName
		if JoyName <>
		{
			if JoystickNumber <> 0
			{
				JoysticksArrCnt += 1
				JoysticksArray[JoysticksArrCnt] := A_Index
			}
			Else
			{
				JoystickNumber = %A_Index%
				JoysticksArrCnt += 1
				JoysticksArray[JoysticksArrCnt] := A_Index
			}
		}
	}
	if JoystickNumber <= 0
	{
		MsgBox The system does not appear to have any joysticks.
		ExitApp
	}
}

#SingleInstance
SetFormat, float, 03  ; Omit decimal point from axis position percentages.
GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
GetKeyState, joy_name, %JoystickNumber%JoyName
GetKeyState, joy_info, %JoystickNumber%JoyInfo

Last_Tick := 0

Loop
{

	joynoloop = 0
	Last_Tick += 1

	if Last_Tick > 10
	{
		While joynoloop < JoysticksArrCnt
		{
			JoyNo := JoysticksArray[A_Index]
			;MsgBox, %JoyNo%
			GetKeyState, joy_buttons, %JoyNo%JoyButtons
			Loop, %joy_buttons%
			{
				GetKeyState, joy%a_index%, %JoyNo%joy%a_index%
				if joy%a_index% = D
				{
					JoystickNumber = %JoyNo%
					break
				}
			}
			joynoloop++
		}
		Last_Tick = 0
	}

	GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	GetKeyState, joy_name, %JoystickNumber%JoyName
	GetKeyState, joy_info, %JoystickNumber%JoyInfo

	buttons_down =
	Loop, %joy_buttons%
	{
		GetKeyState, joy%a_index%, %JoystickNumber%joy%a_index%
		if joy%a_index% = D
			buttons_down = %buttons_down%%a_space%%a_index%
	}
	GetKeyState, joyx, %JoystickNumber%JoyX
	axis_info = X%joyx%
	GetKeyState, joyy, %JoystickNumber%JoyY
	axis_info = %axis_info%%a_space%%a_space%Y%joyy%
	IfInString, joy_info, Z
	{
		GetKeyState, joyz, %JoystickNumber%JoyZ
		axis_info = %axis_info%%a_space%%a_space%Z%joyz%
	}
	IfInString, joy_info, R
	{
		GetKeyState, joyr, %JoystickNumber%JoyR
		axis_info = %axis_info%%a_space%%a_space%R%joyr%
	}
	IfInString, joy_info, U
	{
		GetKeyState, joyu, %JoystickNumber%JoyU
		axis_info = %axis_info%%a_space%%a_space%U%joyu%
	}
	IfInString, joy_info, V
	{
		GetKeyState, joyv, %JoystickNumber%JoyV
		axis_info = %axis_info%%a_space%%a_space%V%joyv%
	}
	IfInString, joy_info, P
	{
		GetKeyState, joyp, %JoystickNumber%JoyPOV
		axis_info = %axis_info%%a_space%%a_space%POV%joyp%
	}
	ToolTip, %joy_name% (#%JoystickNumber%):`n%axis_info%`nButtons Down: %buttons_down%`n`n(right-click the tray icon to exit)
	Sleep, 100
}
return
