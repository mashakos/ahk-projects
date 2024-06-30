#NoEnv
; a1 = enter
; b2 = brwsr back
; x3 = stop
; y4 = right click
; lb5 = leftclick
; lbr6 = rightclick
; start8 = play/pause

; ltrigger/ Z > 60 = skip back
; rtrigger/ Z < 40 = skip next

; a1 = space
; b2 = o
; x3 = page up
; y4 = page dwn
; lb5 = r
; lbr6 = f
; start8 = play/pause
; select7 = ctrl+f
; rightthumb10 = toggle3d

; ltrigger/ Z > 60 = skip back
; rtrigger/ Z < 40 = skip next

; If you want to unconditionally use a specific joystick number, change
; the following value from 0 to the number of the joystick (1-16).
; A value of 0 causes the joystick number to be auto-detected:
JoystickNumber = 0
JoysticksArray := Object()
JoysticksArrCnt = 0

; Auto-detect the joystick number if called for:
if JoystickNumber <= 0
{
    Loop 16  ; Query each joystick number to find out which ones exist.
    {
        GetKeyState, JoyName, %A_Index%JoyName
        gamepadState := XInput_GetState( JoystickNumber - 1 )
        if JoyName <> and gamepadState
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
}

#SingleInstance force
#Include Ini.ahk

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier := 0.30 * (A_ScreenWidth / 1280)

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 3

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

ButtonLeft = 9
ButtonRightFace = 4
ButtonSelMulti = 7
ButtonToggle3D = 10
ButtonPrev = 5
ButtonNext = 6
ButtonEnter = 1
ButtonBack = 2
ButtonPlay = 8
ButtonStop = 3
ButtonGuide = 0x0400

JoystickPrefix = %JoystickNumber%Joy

Last_Move := A_TickCount
MouseState := True
MouseJoy := 1
FrameTick := 10
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

TMTBtn := 0
EscKeySet := 0
AltKeySet := 0
ProcCloseKeySet := 0

EscExitWhitelist := []
AltExitWhitelist := []
ProcCloseWhitelist := []
ProcCheck_Init := 0
ProcCheck_Tick := 0

ScreenCheck_Init := 0
ScreenCheck_Tick := 0


Run C:\Windows\ehome\ehshell.exe "%1%" /nostartupanimation /entrypoint:{CE32C570-4BEC-4aeb-AD1D-CF47B91DE0B2}\{FC9ABCCC-36CB-47ac-8BAB-03E8EF5F6F22}
SetTitleMatchMode, 1
WinWaitActive, ahk_class eHome Render Window, , 10

sleep, 1500

WinSet, Style, -0xC40000, ahk_class eHome Render Window
WinMove, ahk_class eHome Render Window,, 0, 0
WinMove, ahk_class eHome Render Window,, , , A_screenWidth, A_screenHeight

; Use "SetWindowPos" to override stubborn windows who insist on a 
; minimum size
; (in Win7, these include: explorer.exe, iexplore.exe, cmd.exe)
;
; args = hWnd,hWndAfter,x,y,cy,cy,flags
; 0x416 =
; 0x002 = SWP_NOMOVE ignore x,y
; 0x004 = SWP_NOZORDER
; 0x010 = SWP_NOACTIVE
; 0x400 = SWP_NOSENDCHANGING don't tell window
ws_ID := WinExist("ahk_class eHome Render Window")
DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,0,Int,0,Int,A_screenWidth,Int,A_screenHeight,UInt,0x416)

    SetFormat, float, 03  ; Omit decimal point from axis position percentages.

    if ShouldAct()
    if JoystickNumber > 0
    {
        SetTimer, WatchPOV, %FrameTick%
        SetTimer, WatchZTrig, %FrameTick%
        SetTimer, WatchJoystick, %FrameTick%  ; Monitor the movement of the joystick.
        SendMode, INPUT
        PoV0 = ""

        GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
        GetKeyState, joy_name, %JoystickNumber%JoyName
        GetKeyState, joy_info, %JoystickNumber%JoyInfo

        Last_Tick := 0

    }

    if JoystickNumber > 0
    {
        XInput_Init()
        SetTimer, WatchGuide, 100  ; Monitor the state of the guide button.
    }


    FileRead, ini, launchmb.ini

    EscAppKeys := ini_getAllKeyNames(ini, "EscApps")
    AltExitAppKeys := ini_getAllKeyNames(ini, "AltExitApps")
    ProcCloseAppKeys := ini_getAllKeyNames(ini, "ProcCloseApps")

    StringSplit, EscAppArray, EscAppKeys, `,
    StringSplit, AltExitAppArray, AltExitAppKeys, `,
    StringSplit, ProcCloseAppArray, ProcCloseAppKeys, `,


    Loop, % EscAppArray0
    {
        EscExitWhitelist%A_Index% := ini_getValue(ini, "EscApps", EscAppArray%A_Index%)
        EscExitWhitelist0 ++
    }
    Loop, % AltExitAppArray0
    {
        AltExitWhitelist%A_Index% := ini_getValue(ini, "AltExitApps", AltExitAppArray%A_index%)
        AltExitWhitelist0 ++
    }
    Loop, % ProcCloseAppArray0
    {
        ProcCloseWhitelist%A_Index% := ini_getValue(ini, "ProcCloseApps", ProcCloseAppArray%A_index%)
        ProcCloseWhitelist0 ++
    }



    Loop
    {

        ScreenCheck_Tick ++
        ProcCheck_Tick ++

        MouseGetPos, Mouse_X, Mouse_Y
        If(Mouse_X != Last_X || Mouse_Y != Last_Y)
        {
            If(MouseState == False)
                SystemCursor("On")
            MouseState := True
            Last_Move := A_TickCount
        }
        If(A_TickCount > Last_Move + 1000 && MouseState == True) 
        {
            SystemCursor("Off")
            MouseState := False
        }
        Last_X := Mouse_X, Last_Y := Mouse_Y


        IfWinNotExist, ahk_class eHome Render Window
        {
            SystemCursor("On")
            XInput_Term()
            ExitApp
        }

        global JoystickNumber
        global gamepadState
        global EscExitWhitelist
        global AltExitWhitelist
        global EscKeySet
        global AltKeySet

        if( ProcCheck_Init == 0)
        {
            ProcCheck_Tick = 5000
            ProcCheck_Init = 1
        }
        if( ProcCheck_Tick >= 5000)
        {
            ProcCheck_Tick = 0

            Loop, % EscExitWhitelist0
            {
                ;MsgBox, % EscExitWhitelist%A_Index%
                Process, Exist, % EscExitWhitelist%A_Index%
                if ErrorLevel != 0
                {
                    EscKeySet = 1
                }
                Else
                {
                    ;EscKeySet = 0               
                }
            }
            Loop, % AltExitWhitelist0
            {
                Process, Exist, % AltExitWhitelist%A_Index%
                if ErrorLevel != 0
                {
                    AltKeySet = 1
                }
                Else
                {
                    ;AltKeySet = 0
                }
            }        
            Loop, % ProcCloseWhitelist0
            {
                ;MsgBox, % ProcCloseWhitelist%A_index%
                Process, Exist, % ProcCloseWhitelist%A_Index%
                if ErrorLevel != 0
                {
                    ProcCloseKeySet = % ProcCloseWhitelist%A_Index%
                }
                Else
                {
                    ;ProcCloseKeySet = 0
                }
            }                    
        }

        if( ScreenCheck_Init == 0)
        {
            ScreenCheck_Tick = 2000
            ScreenCheck_Init = 1
        }
        if( ScreenCheck_Tick >= 2000)
        WinGet MMX, MinMax, ahk_class eHome Render Window
        IfWinActive, ahk_class eHome Render Window
        {
            ScreenCheck_Tick = 0;
        WinGetPos, WinX, WinY, Width, Height, ahk_class eHome Render Window
            if( MMX != -1)
            {
                if(Width != A_screenWidth || Height != A_screenHeight || WinX != 0 || WinY != 0) 
                {
                    WinSet, Style, -0xC40000, ahk_class eHome Render Window
                    WinMove, ahk_class eHome Render Window,, 0, 0
                    WinMove, ahk_class eHome Render Window,, , , A_screenWidth, A_screenHeight
                    ws_ID := WinExist("ahk_class eHome Render Window")
                    DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,0,Int,0,Int,A_screenWidth,Int,A_screenHeight,UInt,0x416)
                }
                else
                if IsFullscreen()
                IfWinActive, ahk_exe ehshell.exe
                {
                    Send, !{Enter}
                    sleep, 1000
                    WinSet, Style, -0xC40000, ahk_class eHome Render Window
                    WinMove, ahk_class eHome Render Window,, 0, 0
                    WinMove, ahk_class eHome Render Window,, , , A_screenWidth, A_screenHeight
                    ws_ID := WinExist("ahk_class eHome Render Window")
                    DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,0,Int,0,Int,A_screenWidth,Int,A_screenHeight,UInt,0x416)
                }                   
            }
        }

        if ShouldAct() and JoystickNumber > 0
        {

        joynoloop = 0
        Last_Tick += 1

            ;if Last_Tick > 5
            {
                While joynoloop < JoysticksArrCnt
                {
                    JoyNo := JoysticksArray[A_Index]
                    gamepadState := XInput_GetState( JoyNo - 1 )
                    if (gamepadState.wButtons & 0x0400 || gamepadState.wButtons & 0x0010 || gamepadState.wButtons & 0x0020 || gamepadState.wButtons & 0x0040 || gamepadState.wButtons & 0x0080 || gamepadState.wButtons & 0x0100 || gamepadState.wButtons & 0x0200 || gamepadState.wButtons & 0x1000 || gamepadState.wButtons & 0x2000 || gamepadState.wButtons & 0x4000 || gamepadState.wButtons & 0x8000)
                    {
                        JoystickNumber = %JoyNo%
                    }
                    joynoloop++
                }
                JoystickPrefix = %JoystickNumber%Joy
                GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
                GetKeyState, joy_name, %JoystickNumber%JoyName
                GetKeyState, joy_info, %JoystickNumber%JoyInfo

                Last_Tick = 0            
            }
            gamepadState := XInput_GetState( JoystickNumber - 1 )
            if gamepadState != 0
            {
                Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft
                Hotkey, %JoystickPrefix%%ButtonPrev%, ButtonPrev
                Hotkey, %JoystickPrefix%%ButtonSelMulti%, ButtonSelMulti
                Hotkey, %JoystickPrefix%%ButtonToggle3D%, ButtonToggle3D
                Hotkey, %JoystickPrefix%%ButtonRightFace%, ButtonRightFace
                Hotkey, %JoystickPrefix%%ButtonNext%, ButtonNext
                Hotkey, %JoystickPrefix%%ButtonEnter%, ButtonEnter
                Hotkey, %JoystickPrefix%%ButtonBack%, ButtonBack
                Hotkey, %JoystickPrefix%%ButtonPlay%, ButtonPlay
                Hotkey, %JoystickPrefix%%ButtonStop%, ButtonStop

                JoyThresholdUpper := 50 + JoyThreshold
                JoyThresholdLower := 50 - JoyThreshold
                if InvertYAxis
                    YAxisMultiplier = -1
                else
                    YAxisMultiplier = 1

                    IfInString, joy_info, Z
                    {
                        GetKeyState, joyz, %JoystickNumber%JoyZ
                    }
                    IfInString, joy_info, V
                    {
                        IfInString, joy_info, U
                        if ( global TMTBtn == 0)
                        {
                            GetKeyState, joyu, %JoystickNumber%JoyU
                            if(joyu < 30)
                            Send, {PgUp}
                            else
                            if(joyu > 60)
                            Send, {PgDn}

                        }
                        IfInString, joy_info, V
                        if ( global TMTBtn == 0)
                        {
                            GetKeyState, joyv, %JoystickNumber%JoyV
                            if(joyv < 30)
                            Send, {WheelUp}
                            else
                            if(joyv > 60)
                            Send, {WheelDown}
                        }
                    }
                    Else
                    {
                        IfInString, joy_info, R
                        if ( global TMTBtn == 0)
                        {
                            GetKeyState, joyr, %JoystickNumber%JoyR
                            if(joyr < 30)
                            Send, {PgUp}
                            else
                            if(joyr > 60)
                            Send, {PgDn}

                        }
                        IfInString, joy_info, U
                        if ( global TMTBtn == 0)
                        {
                            GetKeyState, joyu, %JoystickNumber%JoyU
                            if(joyu < 30)
                            Send, {WheelUp}
                            else
                            if(joyu > 60)
                            Send, {WheelDown}
                        }
                    }
            }

        }

        IfWinActive, ahk_class uplay_main
        WinClose, ahk_class uplay_main

        Sleep, 100
    }

return


IsFullscreen() {
    stop=0
    WinGet, IEControlList, ControlList, ahk_class eHome Render Window
    Loop, Parse,IEControlList, `n
    {
        if (A_LoopField = "eHome FlipEx Host Window1")
        {
            Return False
            stop=1
        }

    }
    if(stop = 0)
        Return True
}


ShouldAct()
{
    ; global JoysticksArrCnt
    ; gamepadExist := 0
    ; Loop, %JoysticksArrCnt%
    ; {
    ;     gamepadState := XInput_GetState( A_Index - 1 )
    ;     if gamepadState != 0
    ;     {
    ;        gamepadExist++
    ;     }
    ; }

    ;if ( ( WinActive( "Windows Media Center" ) || WinActive( "ahk_class _MIRACLE_20090309_1" ) ) && gamepadExist > 0 )
    if ( WinActive( "Windows Media Center" ) || WinActive( "ahk_class _MIRACLE_20090309_1" ) )
    {
        if WinActive( "ahk_class _MIRACLE_20090309_1" )
            global TMTBtn = 1
        else
            global TMTBtn = 0
        return true
    }
    return false
}


WatchJoystick:
if ShouldAct()
{
    MouseNeedsToBeMoved := false  ; Set default.
    SetFormat, float, 03
    GetKeyState, joyx, %JoystickNumber%JoyX
    GetKeyState, joyy, %JoystickNumber%JoyY

    if !(joyx = 0 and joyy = 0)
    if joyx > %JoyThresholdUpper%
    {
        MouseNeedsToBeMoved := true
        DeltaX := joyx - JoyThresholdUpper
    }
    else if joyx < %JoyThresholdLower%
    {
        MouseNeedsToBeMoved := true
        DeltaX := joyx - JoyThresholdLower
    }
    else
        DeltaX = 0
    if joyy > %JoyThresholdUpper%
    {
        MouseNeedsToBeMoved := true
        DeltaY := joyy - JoyThresholdUpper
    }
    else if joyy < %JoyThresholdLower%
    {
        MouseNeedsToBeMoved := true
        DeltaY := joyy - JoyThresholdLower
    }
    else
        DeltaY = 0
    if MouseNeedsToBeMoved
    {
        SetMouseDelay, -1  ; Makes movement smoother.
        MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
    }
}
return

; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonLeft:
if ShouldAct()
{
    global FrameTick
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
    SetTimer, WaitForLeftButtonUp, %FrameTick%
}
return

WaitForLeftButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonLeft)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForLeftButtonUp, off
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, left,,, 1, 0, U  ; Release the mouse button.    
}
return

ButtonRight:
if ShouldAct()
{
    global FrameTick
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
    SetTimer, WaitForRightButtonUp, %FrameTick%
}
return

WaitForRightButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonRight)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForRightButtonUp, off
    MouseClick, right,,, 1, 0, U  ; Release the mouse button.    
}
return


ButtonEnter:
if ShouldAct()
{
    global FrameTick
    Send, {Enter down}
    SetTimer, WaitForEnterButtonUp, %FrameTick%
}
return

WaitForEnterButtonUp:
if ShouldAct()
{  
    if GetKeyState(JoystickPrefix . ButtonEnter)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForEnterButtonUp, off
    Send, {Enter up}
}
return

ButtonBack:
if ShouldAct()
{
    global FrameTick
    if ( global TMTBtn == 0)
    {
            Send, {Browser_Back down}
    }
    else
    if ( global TMTBtn == 1)
        Send o
    SetTimer, WaitForBackButtonUp, %FrameTick%
}
return

WaitForBackButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonBack)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForBackButtonUp, off
    if ( global TMTBtn == 0)
    {
            Send, {Browser_Back up}
    }
}
return

ButtonPlay:
if ShouldAct()
{
    global FrameTick
    if ( global TMTBtn == 0)
        Send, {Media_Play_Pause down}
    else
    if ( global TMTBtn == 1)
        Send, {Space down}
    SetTimer, WaitForPlayButtonUp, %FrameTick%
}
return

WaitForPlayButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonPlay)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForPlayButtonUp, off
    if ( global TMTBtn == 0)
        Send, {Media_Play_Pause up}
    else
    if ( global TMTBtn == 1)
        Send, {Space up}
}
return

ButtonRightFace:
if ShouldAct()
{
    global FrameTick
    SetMouseDelay, -1  ; Makes movement smoother.
    if ( global TMTBtn == 0)
        MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
    else
    if ( global TMTBtn == 1)
        Send, {PgDn down}
    SetTimer, WaitForRightButtonFaceUp, %FrameTick%
}
return

WaitForRightButtonFaceUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonRightFace)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForRightButtonFaceUp, off
    if ( global TMTBtn == 0)
        MouseClick, right,,, 1, 0, U  ; Release the mouse button.    
    else
    if ( global TMTBtn == 1)
        Send, {PgDn up}
}
return


ButtonStop:
if ShouldAct()
{
    global FrameTick
    if ( global TMTBtn == 0)
        Send, {Media_Stop down}
    else
    if ( global TMTBtn == 1)
        Send, {PgUp down}
    SetTimer, WaitForStopButtonUp, %FrameTick%
}
return

WaitForStopButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonStop)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForStopButtonUp, off
    if ( global TMTBtn == 0)
        Send, {Media_Stop up}
    else
    if ( global TMTBtn == 1)
        Send, {PgUp up}
}
return

WatchPOV:

global PoV

if ShouldAct()
{
    KeyToHoldDown := (GetKeyState(JoystickNumber "JoyPOV", "p")+4500)//4500
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
            If A_LoopField && (PovT += 100)
                Send {blind}{%A_LoopField% down}
        }
}
return

WatchZTrig:
if ShouldAct()
{
    GetKeyState, joyz, %JoystickNumber%JoyZ
    KeyZToHoldDownPrev = %KeyZToHoldDown%
        if(joyz > 70)
        KeyZToHoldDown = left
        else
        if(joyz < 40)
        KeyZToHoldDown = right
        else
        KeyZToHoldDown = 
    if KeyZToHoldDown = %KeyZToHoldDownPrev%
        return
    SetKeyDelay -1
    if KeyZToHoldDownPrev
        MouseClick, %KeyZToHoldDownPrev%,,, 1, 0, U
        ;Send, {%KeyZToHoldDownPrev% up}
    if KeyZToHoldDown
        MouseClick, %KeyZToHoldDownPrev%,,, 1, 0, D
        ;Send, {%KeyZToHoldDown% down}
}
return

ButtonPrev:
if ShouldAct()
{
    global FrameTick
    if ( global TMTBtn == 0)
        Send, {Media_Prev down}
    else
    if ( global TMTBtn == 1)
        Send r
    SetTimer, WaitForPrevButtonUp, %FrameTick%
}
return

WaitForPrevButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonPrev)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForPrevButtonUp, off
    if ( global TMTBtn == 0)
        Send, {Media_Prev up}
}
return

ButtonNext:
if ShouldAct()
{
    global FrameTick
    if ( global TMTBtn == 0)
        Send, {Media_Next down}
    else
    if ( global TMTBtn == 1)
        Send f
    SetTimer, WaitForNextButtonUp, %FrameTick%
}
return

WaitForNextButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonNext)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForNextButtonUp, off
    if ( global TMTBtn == 0)
        Send, {Media_Next up}
}
return

ButtonSelMulti:
if ShouldAct()
{
    global FrameTick
    ; if ( global TMTBtn == 0)
    ;     Send, {Media_Next down}
    ; else
    if ( global TMTBtn == 1)
        Send, ^f
    SetTimer, WaitForSelMultiButtonUp, %FrameTick%
}
return

WaitForSelMultiButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonSelMulti)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForSelMultiButtonUp, off
    ; if ( global TMTBtn == 0)
    ;     Send, {Media_Next up}
    ; else
    ; if ( global TMTBtn == 1)
    ;     Send ^f
}
return

ButtonToggle3D:
if ShouldAct()
{
    ; if ( global TMTBtn == 0)
    ;     Send, {Media_Next down}
    ; else
    if ( global TMTBtn == 1)
    {
        Send {Ctrl down}
        Sleep 20
        Send {t down}
        Sleep 10
        Send {t up}
        Sleep 10
        Send {Ctrl up}
    }
    ; SetTimer, WaitForToggle3DButtonUp, 10
}
return

WaitForToggle3DButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonToggle3D)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForToggle3DButtonUp, off
    ; if ( global TMTBtn == 0)
    ;     Send, {Media_Next up}
    ; else
     if ( global TMTBtn == 1)
        Send, {Ctrl up}
}
return

WatchGuide:
    JNo := 0
    global EscKeySet
    global AltKeySet
    global ProcCloseKeySet
    global JoystickNumber
    global gamepadState

    if global EscKeySet == 1
    {
        ;SetKeyDelay, 10, 10
        GuideKey = Esc
    }
    else
    if ProcCloseKeySet != 0
    {
        ;SetKeyDelay, 10, 10
        GuideKey = Browser_Back
    }
    else
    if global AltKeySet == 1
    {
        ;SetKeyDelay, -1, -1    
        GuideKey = !F4
    }
    else
    {
        ;SetKeyDelay, -1, -1
        GuideKey = Browser_Back
    }

    if global JoystickNumber > 0
        JNo := JoystickNumber - 1
        ;MsgBox % JNo
    if gamepadState := XInput_GetState( JNo )
    {
        if ( global TMTBtn == 0)
        {
            GKeyToHoldDownPrev = %GKeyToHoldDown%
                if (gamepadState.wButtons & 0x0400)
                    GKeyToHoldDown = %GuideKey%
                else
                    GKeyToHoldDown = 

            if GKeyToHoldDown = %GKeyToHoldDownPrev%
                return
            SetKeyDelay -1
            if GKeyToHoldDownPrev
            {
                Send, {%GKeyToHoldDownPrev% up}
                EscKeySet = 0
                AltKeySet = 0
                ProcCloseKeySet = 0
            }
            if GKeyToHoldDown
            {
            if( ProcCloseKeySet != 0)
            {
                WinClose, % ProcCloseKeySet
                ;sleep, 1000
            }
                WinWaitClose, % ProcCloseKeySet
                Send, {%GKeyToHoldDown% down}
            }
        }
        else
        if ( global TMTBtn == 1)
        {
            GCtrlToHoldDownPrev = %GCtrlToHoldDown%
            GXToHoldDownPrev = %GXToHoldDown%
                if (gamepadState.wButtons & 0x0400)
                {
                    Send, ^x
                }
        }
    }
return

/*  XInput by Lexikos
 *  This version of the script uses objects, so requires AutoHotkey_L.
 */

/*
    Function: XInput_Init
    
    Initializes XInput.ahk with the given XInput DLL.
    
    Parameters:
        dll     -   The path or name of the XInput DLL to load.
*/
XInput_Init(dll="xinput1_3.dll")
{
    global
    if _XInput_hm
        return
    
    ;======== CONSTANTS DEFINED IN XINPUT.H ========
    
    ; NOTE: These are based on my outdated copy of the DirectX SDK.
    ;       Newer versions of XInput may require additional constants.
    
    ; Device types available in XINPUT_CAPABILITIES
    XINPUT_DEVTYPE_GAMEPAD          := 0x01

    ; Device subtypes available in XINPUT_CAPABILITIES
    XINPUT_DEVSUBTYPE_GAMEPAD       := 0x01

    ; Flags for XINPUT_CAPABILITIES
    XINPUT_CAPS_VOICE_SUPPORTED     := 0x0004

    ; Constants for gamepad buttons
    XINPUT_GAMEPAD_GUIDE            := 0x0400
    XINPUT_GAMEPAD_DPAD_UP          := 0x0001
    XINPUT_GAMEPAD_DPAD_DOWN        := 0x0002
    XINPUT_GAMEPAD_DPAD_LEFT        := 0x0004
    XINPUT_GAMEPAD_DPAD_RIGHT       := 0x0008
    XINPUT_GAMEPAD_START            := 0x0010
    XINPUT_GAMEPAD_BACK             := 0x0020
    XINPUT_GAMEPAD_LEFT_THUMB       := 0x0040
    XINPUT_GAMEPAD_RIGHT_THUMB      := 0x0080
    XINPUT_GAMEPAD_LEFT_SHOULDER    := 0x0100
    XINPUT_GAMEPAD_RIGHT_SHOULDER   := 0x0200
    XINPUT_GAMEPAD_A                := 0x1000
    XINPUT_GAMEPAD_B                := 0x2000
    XINPUT_GAMEPAD_X                := 0x4000
    XINPUT_GAMEPAD_Y                := 0x8000

    ; Gamepad thresholds
    XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE  := 7849
    XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE := 8689
    XINPUT_GAMEPAD_TRIGGER_THRESHOLD    := 30

    ; Flags to pass to XInputGetCapabilities
    XINPUT_FLAG_GAMEPAD             := 0x00000001
    
    ;=============== END CONSTANTS =================
    
    _XInput_hm := DllCall("LoadLibrary" ,"str",dll)
    
    if !_XInput_hm
    {
        MsgBox, Failed to initialize XInput: %dll%. dll not found.
        return
    }
    
    _XInput_GetState        := DllCall("GetProcAddress" ,"ptr",_XInput_hm ,"UInt",100)
    _XInput_SetState        := DllCall("GetProcAddress" ,"ptr",_XInput_hm ,"astr","XInputSetState")
    _XInput_GetCapabilities := DllCall("GetProcAddress" ,"ptr",_XInput_hm ,"astr","XInputGetCapabilities")

    if !(_XInput_GetState && _XInput_SetState && _XInput_GetCapabilities)
    {
        XInput_Term()
        ;MsgBox, Failed to initialize XInput: function not found.
        return
    }
}

/*
    Function: XInput_GetState
    
    Retrieves the current state of the specified controller.

    Parameters:
        UserIndex   -   [in] Index of the user's controller. Can be a value from 0 to 3.
        State       -   [out] Receives the current state of the controller.
    
    Returns:
        If the function succeeds, the return value is ERROR_SUCCESS (zero).
        If the controller is not connected, the return value is ERROR_DEVICE_NOT_CONNECTED (1167).
        If the function fails, the return value is an error code defined in Winerror.h.
            http://msdn.microsoft.com/en-us/library/ms681381.aspx

    Remarks:
        XInput.dll returns controller state as a binary structure:
            http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.xinput_state
            http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.xinput_gamepad
        XInput.ahk converts this structure to an AutoHotkey_L object.
*/
XInput_GetState(UserIndex)
{
    global _XInput_GetState
    
    VarSetCapacity(xiState,16)

    if ErrorLevel := DllCall(_XInput_GetState ,"uint",UserIndex ,"uint",&xiState)
        return 0
    
    return {
    (Join,
        dwPacketNumber: NumGet(xiState,  0, "UInt")
        wButtons:       NumGet(xiState,  4, "UShort")
        bLeftTrigger:   NumGet(xiState,  6, "UChar")
        bRightTrigger:  NumGet(xiState,  7, "UChar")
        sThumbLX:       NumGet(xiState,  8, "Short")
        sThumbLY:       NumGet(xiState, 10, "Short")
        sThumbRX:       NumGet(xiState, 12, "Short")
        sThumbRY:       NumGet(xiState, 14, "Short")
    )}
}

/*
    Function: XInput_SetState
    
    Sends data to a connected controller. This function is used to activate the vibration
    function of a controller.
    
    Parameters:
        UserIndex       -   [in] Index of the user's controller. Can be a value from 0 to 3.
        LeftMotorSpeed  -   [in] Speed of the left motor, between 0 and 65535.
        RightMotorSpeed -   [in] Speed of the right motor, between 0 and 65535.
    
    Returns:
        If the function succeeds, the return value is 0 (ERROR_SUCCESS).
        If the controller is not connected, the return value is 1167 (ERROR_DEVICE_NOT_CONNECTED).
        If the function fails, the return value is an error code defined in Winerror.h.
            http://msdn.microsoft.com/en-us/library/ms681381.aspx
    
    Remarks:
        The left motor is the low-frequency rumble motor. The right motor is the
        high-frequency rumble motor. The two motors are not the same, and they create
        different vibration effects.
*/
XInput_SetState(UserIndex, LeftMotorSpeed, RightMotorSpeed)
{
    global _XInput_SetState
    return DllCall(_XInput_SetState ,"uint",UserIndex ,"uint*",LeftMotorSpeed|RightMotorSpeed<<16)
}

/*
    Function: XInput_GetCapabilities
    
    Retrieves the capabilities and features of a connected controller.
    
    Parameters:
        UserIndex   -   [in] Index of the user's controller. Can be a value in the range 0–3.
        Flags       -   [in] Input flags that identify the controller type.
                                0   - All controllers.
                                1   - XINPUT_FLAG_GAMEPAD: Xbox 360 Controllers only.
        Caps        -   [out] Receives the controller capabilities.
    
    Returns:
        If the function succeeds, the return value is 0 (ERROR_SUCCESS).
        If the controller is not connected, the return value is 1167 (ERROR_DEVICE_NOT_CONNECTED).
        If the function fails, the return value is an error code defined in Winerror.h.
            http://msdn.microsoft.com/en-us/library/ms681381.aspx
    
    Remarks:
        XInput.dll returns capabilities via a binary structure:
            http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.xinput_capabilities
        XInput.ahk converts this structure to an AutoHotkey_L object.
*/
XInput_GetCapabilities(UserIndex, Flags)
{
    global _XInput_GetCapabilities
    
    VarSetCapacity(xiCaps,20)
    
    if ErrorLevel := DllCall(_XInput_GetCapabilities ,"uint",UserIndex ,"uint",Flags ,"ptr",&xiCaps)
        return 0
    
    return,
    (Join
        {
            Type:                   NumGet(xiCaps,  0, "UChar"),
            SubType:                NumGet(xiCaps,  1, "UChar"),
            Flags:                  NumGet(xiCaps,  2, "UShort"),
            Gamepad:
            {
                wButtons:           NumGet(xiCaps,  4, "UShort"),
                bLeftTrigger:       NumGet(xiCaps,  6, "UChar"),
                bRightTrigger:      NumGet(xiCaps,  7, "UChar"),
                sThumbLX:           NumGet(xiCaps,  8, "Short"),
                sThumbLY:           NumGet(xiCaps, 10, "Short"),
                sThumbRX:           NumGet(xiCaps, 12, "Short"),
                sThumbRY:           NumGet(xiCaps, 14, "Short")
            },
            Vibration:
            {
                wLeftMotorSpeed:    NumGet(xiCaps, 16, "UShort"),
                wRightMotorSpeed:   NumGet(xiCaps, 18, "UShort")
            }
        }
    )
}

/*
    Function: XInput_Term
    Unloads the previously loaded XInput DLL.
*/
XInput_Term() {
    global
    if _XInput_hm
        DllCall("FreeLibrary","uint",_XInput_hm), _XInput_hm :=_XInput_GetState :=_XInput_SetState :=_XInput_GetCapabilities :=0
}

; TODO: XInputEnable, 'GetBatteryInformation and 'GetKeystroke.


;### This function taken from the tutorial ###

SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
    {
        $ = h                                          ; active default cursors
        VarSetCapacity( h_cursor,4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
            h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
            b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0
                , "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )
        }
    }
    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ = b  ; use blank cursors
    else
        $ = h  ; use the saved cursors

    Loop %c0%
    {
        h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
        DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
    }
}
