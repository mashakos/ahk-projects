; Xbox360 Controller as remote for Windows Media Center


JoyPrefix = 1Joy
JoyRightLastActivated = 0
JoyLeftLastActivated = 0
TriggerLastActivated = 0

#Persistent
#SingleInstance force

JoyConnect()

SetTimer, WatchPOV, 10
SetTimer, WatchJoyLeft, 10
SetTimer, WatchJoyRight, 10
SetTimer, WatchTriggers, 10

OnMessage(0x219, "notify_change") ;this message is a notification of usb device (dis)connect

Return




;the following labels are all the button assignments

ButtonA:
if ShouldAct()
	Send {Enter}
return

ButtonB:
if ShouldAct()
	Send {Backspace}
return

ButtonX:
if ShouldAct()
	Send {AppsKey} ;right-click info commands
return

ButtonY:
if ShouldAct()
	Send {Media_Play_Pause}
return

ButtonBack:
if ShouldAct()
{
	sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager ;turn off display
}
return

ButtonStart:
if ShouldAct()
	Send #!{Enter} ;green button
return

ButtonLeft:
if ShouldAct()
	Send ^b ;skip back
return

ButtonRight:
if ShouldAct()
	Send ^f ;skip forward
return

ButtonLeftJoy:
if ShouldAct()
	Send {Volume_Mute}
return

ButtonRightJoy:
if ShouldAct()
	Send ^S ;stop
return


; makes the pov act as the arrow keys
WatchPOV:
if ShouldAct()
{

	KeyToHoldDownPrev = %KeyToHoldDown%  ; Prev now holds the key that was down before (if any).

	GetKeyState, POV, %JoyPrefix%POV  ; Get position of the POV control.

	; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
	; To support them all, use a range:
	if POV < 0   				; No angle to report
	{
		KeyToHoldDown =
	}
	else if POV > 31500			; 315 to 360 degrees: Forward
	{
		KeyToHoldDown = Up
	}
	else if POV between 0 and 4500		; 0 to 45 degrees: Forward
	{
		KeyToHoldDown = Up
	}	
	else if POV between 4501 and 13500	; 45 to 135 degrees: Right
	{
		KeyToHoldDown = Right
	}
	else if POV between 13501 and 22500	; 135 to 225 degrees: Down
	{
		KeyToHoldDown = Down
	}
	else					; 225 to 315 degrees: Left
	{
		KeyToHoldDown = Left
	}

	if KeyToHoldDown = %KeyToHoldDownPrev%	; The correct key is already down (or no key is needed).
	{
		return  ; Do nothing.
	}

	; Otherwise, release the previous key and press down the new key:
	SetKeyDelay -1  ; Avoid delays between keystrokes.

	if KeyToHoldDownPrev   ; There is a previous key to release.
	    Send, {%KeyToHoldDownPrev% up}  ; Release it.
	if KeyToHoldDown   ; There is a key to press down.
	    Send, {%KeyToHoldDown% down}  ; Press it down.
}
return

; joy left is volume control (up/down) and CC(left)
WatchJoyLeft:
if ShouldAct()
{
	GetKeyState, joyx, %JoyPrefix%X
	GetKeyState, joyy, %JoyPrefix%Y

	if ( joyy <= 0 OR joyx <= 0 )
	{
		return
	}


	if joyy < 25
	{
		Send {Volume_Up}
	}

	if joyy > 75
	{
		Send {Volume_Down}
	}

	if ( JoyLeftLastActivated < 250 )
	{
		JoyLeftLastActivated := JoyLeftLastActivated + 10
		return
	}

	if joyx < 25
	{
		Send ^C ;toggle closed captioning
		JoyRightLastActivated = 0
	}

	if joyx > 75
	{
		;nothing for now
		JoyRightLastActivated = 0
	}
}
return

; joy right pgup/pgdn (channel up down, among other things) on up/down, and home/end on left/right
WatchJoyRight:
if ShouldAct()
{
	if JoyRightLastActivated < 250
	{
		JoyRightLastActivated := JoyRightLastActivated + 10
		return
	}

	GetKeyState, joyr, %JoyPrefix%R
	GetKeyState, joyu, %JoyPrefix%U

	if ( joyr <= 0 OR joyu <= 0 )
	{
		return
	}

	if joyr < 25
	{
		Send {PgUp}
		JoyRightLastActivated = 0
	}

	if joyr > 75
	{
		Send {PgDn}
		JoyRightLastActivated = 0
	}

	if joyu < 25
	{
		Send {Home}
		JoyRightLastActivated = 0
	}

	if joyu > 75
	{
		Send {End}
		JoyRightLastActivated = 0
	}

}
return

; triggers rewind(left trigger) and fastforward(right trigger)
WatchTriggers:
if ShouldAct() {
	if TriggerLastActivated < 500
	{
		TriggerLastActivated := TriggerLastActivated + 10
		return
	}

	GetKeyState, trigger, %JoyPrefix%Z

	if ( trigger <= 0 )
	{
		return
	}

	if trigger > 65 ;left
	{
		Send ^B ;rewind
		TriggerLastActivated = 0
	}

	if trigger < 35 ;right
	{
		Send ^F ;fastforward
		TriggerLastActivated = 0
	}
}
return

notify_change(wParam, lParam, msg, hwnd)
{
	reload ;reloads on (dis)connect of usb device to refresh the joystick numbers and info
	ExitApp
}

ShouldAct()
{
	if WinActive( "Windows Media Center" )
	{
		return true
	}
	return false
}

JoyConnect()
{
	Loop 4
	{
		GetKeyState, jinfo, %A_Index%JoyInfo
		if (jinfo = "")
		{
			continue
		}


		if (jinfo = "ZRUPD")
		{
			JoyPrefix = %A_Index%Joy

			Hotkey, %JoyPrefix%1, ButtonA
			Hotkey, %JoyPrefix%2, ButtonB
			Hotkey, %JoyPrefix%3, ButtonX
			Hotkey, %JoyPrefix%4, ButtonY
			Hotkey, %JoyPrefix%5, ButtonLeft
			Hotkey, %JoyPrefix%6, ButtonRight
			Hotkey, %JoyPrefix%7, ButtonBack
			Hotkey, %JoyPrefix%8, ButtonStart
			Hotkey, %JoyPrefix%9, ButtonLeftJoy
			Hotkey, %JoyPrefix%10, ButtonRightJoy
			return
		}
	}
}