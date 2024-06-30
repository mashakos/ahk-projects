; <COMPILER: v1.1.22.00>
#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance Force
DetectHiddenWindows, ON

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
JoystickNumber = 1
JoysticksArray := Object()
JoysticksArrCnt = 0

ButtonA = 1
ButtonB = 2
ButtonX = 3
ButtonY = 4
ButtonLB = 5
ButtonLBR = 6
ButtonSelect = 7
ButtonStart = 8
ButtonGuide = 0x0400

JoystickPrefix = %JoystickNumber%Joy

Last_Move := A_TickCount
MouseState := True
MouseJoy := 1
FrameTick := 10
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


MameWidth = 1920
MameHeight = 1440

ScreenCheck_Init := 0
ScreenCheck_Tick := 0





iniFile=config\settings.ini
regFileCache=""
regFile_epsxe=""
regFile_pcsxr=""
IfNotExist, %A_ScriptDir%\config\*.*
{
RunWait, cmd /c (md "%A_ScriptDir%\config"), , Hide
}
IfNotExist,%iniFile%
{
	MsgBox, 0, Setup, Not so fast! We need to set the app up first.`n -Mashakos.
	FileAppend, `n, %iniFile%
	FileAppend, [Configs]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Path=%A_ScriptDir%\config`n, %iniFile%
	IfExist, %A_ScriptDir%\config\default.reg
	{
	MsgBox, 4, Default Config File Already Exists, A default config file already exists in the config folder. Overwrite?
	IfMsgBox Yes
	{
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Vision Thing\PSEmu Pro" "%A_ScriptDir%\config\default.reg"), , Hide
	FileRead, regFileCache, %A_ScriptDir%\config\default.reg
	regFileCache = %regFileCache%`r`n
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\epsxe\config" "%A_ScriptDir%\config\default.reg"), , Hide
	FileRead, regFile_epsxe, %A_ScriptDir%\config\default.reg
	StringReplace, regFile_epsxe, regFile_epsxe, Windows Registry Editor Version 5.00, , All
	regFileCache = %regFileCache%%regFile_epsxe%
	regFileCache = %regFileCache%`r`n
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Pcsxr" "%A_ScriptDir%\config\default.reg"), , Hide
	FileRead, regFile_pcsxr, %A_ScriptDir%\config\default.reg
	StringReplace, regFile_pcsxr, regFile_pcsxr, Windows Registry Editor Version 5.00, , All
	regFileCache = %regFileCache%%regFile_pcsxr%
	regFileCache = %regFileCache%`r`n
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	FileAppend, %regFileCache%, %A_ScriptDir%\config\default.reg
	}
	}
	else
	{
	RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Vision Thing\PSEmu Pro" "%A_ScriptDir%\config\default.reg"), , Hide
	FileRead, regFileCache, %A_ScriptDir%\config\default.reg
	regFileCache = %regFileCache%`r`n
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\epsxe\config" "%A_ScriptDir%\config\default.reg"), , Hide
	FileRead, regFile_epsxe, %A_ScriptDir%\config\default.reg
	StringReplace, regFile_epsxe, regFile_epsxe, Windows Registry Editor Version 5.00, , All
	regFileCache = %regFileCache%%regFile_epsxe%
	regFileCache = %regFileCache%`r`n
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Pcsxr" "%A_ScriptDir%\config\default.reg"), , Hide
	FileRead, regFile_pcsxr, %A_ScriptDir%\config\default.reg
	StringReplace, regFile_pcsxr, regFile_pcsxr, Windows Registry Editor Version 5.00, , All
	regFileCache = %regFileCache%%regFile_pcsxr%
	regFileCache = %regFileCache%`r`n
	RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
	FileAppend, %regFileCache%, %A_ScriptDir%\config\default.reg
	}
	FileSelectFolder, drivePath, , 3, Where is ePSXe located?
	if drivePath =
	{
	Filedelete,%iniFile%
	MsgBox, 0, Setup,
				(
		Oh well, you don't want to use this app. Fine!
		-Mashakos.
	)
	ExitApp
	}
	driveLetter := SubStr(drivePath, 1, 1)
	FileAppend, `n, %iniFile%
	FileAppend, [ePSXe]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Path=%drivePath%`n, %iniFile%
	MsgBox, 4, PCSXr, Do you have PCSXr on your system?
	IfMsgBox Yes
	{
	FileSelectFolder, drivePath, , 3, Where is PCSXr located?
	if drivePath =
	{
	Filedelete,%iniFile%
	MsgBox, 0, Setup,
				(
		Oh well, you don't want to use this app. Fine!
		-Mashakos.
	)
	ExitApp
	}
	driveLetter := SubStr(drivePath, 1, 1)
	FileAppend, `n, %iniFile%
	FileAppend, [PCSXr]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Path=%drivePath%`n, %iniFile%
	}
	MsgBox, 4, psxMAME, Do you have psxMAME on your system?
	IfMsgBox Yes
	{
	FileSelectFolder, drivePath, , 3, Where is psxMAME located?
	if drivePath =
	{
	Filedelete,%iniFile%
	MsgBox, 0, Setup,
				(
		Oh well, you don't want to use this app. Fine!
		-Mashakos.
	)
	ExitApp
	}
	driveLetter := SubStr(drivePath, 1, 1)
	FileAppend, `n, %iniFile%
	FileAppend, [psxMAME]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Path=%drivePath%`n, %iniFile%
	}
	MsgBox, 4, Pinnacle Game Profiler, Do you have a Pinnacle Game Profiler config you would like to use?
	IfMsgBox Yes
	{
	FileSelectFolder, drivePath, , 3, Where is Pinnacle Game Profiler located?
	if drivePath =
	{
	Filedelete,%iniFile%
	MsgBox, 0, Setup,
				(
		Oh well, you don't want to use this app. Fine!
		-Mashakos.
	)
	ExitApp
	}
	driveLetter := SubStr(drivePath, 1, 1)
	FileAppend, `n, %iniFile%
	FileAppend, [PGP]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Path=%drivePath%`n, %iniFile%
	InputBox, UserInput, Pinnacle Game Profiler, What is the Profile name you want to use?
	if ErrorLevel
	{
	ExitApp
	}
	else
	{
	ProfileName=%UserInput%
	}
	FileAppend, `n, %iniFile%
	FileAppend, Profile=%ProfileName%`n, %iniFile%
	InputBox, UserInput, Pinnacle Game Profiler, What is the Config name you want to use?
	if ErrorLevel
	{
	ExitApp
	}
	else
	{
	ConfigName=%UserInput%
	}
	FileAppend, `n, %iniFile%
	FileAppend, Config=%ConfigName%`n, %iniFile%
	MsgBox, 0, Done,
				(
		You are Done!
		You can always manually edit your settings in the settings.ini file, found in the config folder.
		Please check out the readme file for instructions on how to use this app. Have fun!
		-Mashakos
	)
	ExitApp
	}
	else
	{
	MsgBox, 0, Done,
				(
		You are Done!
		You can always manually edit your settings in the settings.ini file, found in the config folder.
		Please check out the readme file for instructions on how to use this app. Have fun!
		-Mashakos
	)
	ExitApp
	}
}
else
{
	if 0 < 1
	{
	MsgBox Usage: PSXLauncher.exe <-epsxe / -epsxemouse / -pcsxr / -psxmame / -psxmameznc> "[config reg file]" "[Imagepath]\[Imagefile]"
	ExitApp
	}
	IniRead, configsPath, %iniFile%, Configs, Path
	IniRead, ePSXePath, %iniFile%, ePSXe, Path
	IniRead, pcsxrPath, %iniFile%, PCSXr, Path
	IniRead, psxmamePath, %iniFile%, psxMAME, Path
	IniRead, pgpPath, %iniFile%, PGP, Path
	IniRead, pgpProfile, %iniFile%, PGP, Profile
	IniRead, pgpConfig, %iniFile%, PGP, Config
	input1 = %1%
	input2 = %2%
	inputiso = %3%
	StringReplace, input1, input1, `-, , All
	paramMatch := InStr(input1, "epsxe")
	if (input1 == "epsxe")
	{
	SetWorkingDir %ePSXePath%
	If InStr(input2, ".reg") > 0
	{
	RunWait, regedit /s "%configsPath%\%input2%"
	Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-loadbin "%inputiso%"
	}
	else
	{
	RunWait, regedit /s "%configsPath%\default.reg"
	Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-loadbin "%input2%"
	}
	WinWaitActive, ePSXe, , 2
	WinWaitClose
	ExitApp
	}
	else
	if (input1 == "epsxemouse")
	{
	SetWorkingDir %ePSXePath%
	If InStr(input2, ".reg") > 0
	{
	RunWait, regedit /s "%configsPath%\%input2%"
	Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-mouse `-loadbin "%inputiso%"
	}
	else
	{
	RunWait, regedit /s "%configsPath%\default.reg"
	Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-mouse `-loadbin "%input2%"
	}
	Sleep, 5000
	Send {F5 down}
	Sleep, 50
	Send {F5 up}
	WinWaitActive, ePSXe, , 2
	WinWaitClose
	ExitApp
	}
	else
	if (input1 == "pcsxr")
	{
	SetWorkingDir %pcsxrPath%
	If InStr(input2, ".reg") > 0
	{
	RunWait, regedit /s "%configsPath%\%input2%"
	Run %pcsxrPath%\pcsxr.exe `-nogui `-cdfile "%inputiso%"
	}
	else
	{
	RunWait, regedit /s "%configsPath%\default.reg"
	Run %pcsxrPath%\pcsxr.exe `-nogui `-cdfile "%input2%"
	}
	WinWaitActive, pcsxr, , 2
	WinWaitClose
	ExitApp
	}
	else
	if (input1 == "psxmame")
	{
		SetWorkingDir %psxmamePath%
		If InStr(input2, ".reg") > 0
		{
			RunWait, regedit /s "%configsPath%\%input2%"
			Run %psxmamePath%\mame.exe "%inputiso%"
			XinputEmu_Init()
		}
		else
		{
			RunWait, regedit /s "%configsPath%\default.reg"
			Run %psxmamePath%\mame.exe "%input2%"
			XinputEmu_Init()
		}
		WinWaitActive, MAME:, , 2
		WinWaitClose
		ExitApp
	}
	else
	if (input1 == "psxmameznc")
	{
		SetWorkingDir %psxmamePath%
		If InStr(input2, ".reg") > 0
		{
			RunWait, regedit /s "%configsPath%\%input2%"
			Run %psxmamePath%\mame.exe "%inputiso%"
			PsxMame_Init()
		}
		else
		{
			RunWait, regedit /s "%configsPath%\default.reg"
			Run %psxmamePath%\mame.exe "%input2%"
			PsxMame_Init()
		}
		WinWaitActive, MAME:, , 2
		WinWaitClose
		Gui Destroy
		ExitApp
	}
}

XinputEmu_Init()
{
	SetTitleMatchMode, 1
	WinWaitActive, ahk_class MAME, , 10
	    SetFormat, float, 03  ; Omit decimal point from axis position percentages.
	    global FrameTick
	    global PoVTick
	    global JoystickNumber
        global JoystickPrefix
		global ButtonA
		global ButtonB
		global ButtonX
		global ButtonY
		global ButtonLB
		global ButtonLBR
		global ButtonSelect
		global ButtonStart
		global PoV

	    if ShouldAct()
	    {

	        SetTimer, WatchPOV, %PoVTick%
	        SendMode, INPUT
	        PoV0 = ""

	        GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	        GetKeyState, joy_name, %JoystickNumber%JoyName
	        GetKeyState, joy_info, %JoystickNumber%JoyInfo

	    }

	    {
	        XInput_Init()
	        ; SetTimer, WatchGuide, 100  ; Monitor the state of the guide button.
	    }

	    Loop
	    {



        IfWinNotExist, ahk_class MAME
        {
            XInput_Term()
            ExitApp
        }


	        if ShouldAct()
	        {

	        ;if Last_Tick > 5
	        {
	            GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	            GetKeyState, joy_name, %JoystickNumber%JoyName
	            GetKeyState, joy_info, %JoystickNumber%JoyInfo

	            Last_Tick = 0            
	        }


	        Hotkey, %JoystickPrefix%%ButtonA%, ButtonA
	        Hotkey, %JoystickPrefix%%ButtonB%, ButtonB
	        Hotkey, %JoystickPrefix%%ButtonX%, ButtonX
	        Hotkey, %JoystickPrefix%%ButtonY%, ButtonY
	        Hotkey, %JoystickPrefix%%ButtonLB%, ButtonLB
	        Hotkey, %JoystickPrefix%%ButtonLBR%, ButtonLBR
	        Hotkey, %JoystickPrefix%%ButtonSelect%, ButtonSelect
	        Hotkey, %JoystickPrefix%%ButtonStart%, ButtonStart

	        }


	        Sleep, 100
	    }
}

PsxMame_Init()
{
	global MameWidth
	global MameHeight
	global FrameTick
	global PoVTick
	MameCenter := Floor( (A_ScreenWidth/2) - (MameWidth/2) )

	SetTitleMatchMode, 1
	WinWaitActive, ahk_class MAME, , 10

	sleep, 1500
	Gui -Caption +ToolWindow
	Gui Color, 0
	Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% Center, HSHIDE

	WinSet, Style, -0xC40000, ahk_class MAME
	WinMove, ahk_class MAME,, %MameCenter%, 0
	WinMove, ahk_class MAME,, , , MameWidth, A_screenHeight

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
	ws_ID := WinExist("ahk_class MAME")
	DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,%MameCenter%,Int,0,Int,MameWidth,Int,A_screenHeight,UInt,0x416)
	WinActivate, ahk_class MAME

	    SetFormat, float, 03  ; Omit decimal point from axis position percentages.
	    global JoystickNumber
        global JoystickPrefix
		global ButtonA
		global ButtonB
		global ButtonX
		global ButtonY
		global ButtonLB
		global ButtonLBR
		global ButtonSelect
		global ButtonStart

	    if ShouldAct()
	    {
	        SetTimer, WatchPOV, %PoVTick%
	        SetTimer, WatchZTrig, 10
	        SendMode, INPUT
	        PoV0 = ""

	        GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	        GetKeyState, joy_name, %JoystickNumber%JoyName
	        GetKeyState, joy_info, %JoystickNumber%JoyInfo

	        Last_Tick := 0

	    }

	    {
	        XInput_Init()
	        ; SetTimer, WatchGuide, 100  ; Monitor the state of the guide button.
	    }


	    Loop
	    {

        IfWinNotExist, ahk_class MAME
        {
            XInput_Term()
            ExitApp
        }

	        ScreenCheck_Tick ++

	        if( ScreenCheck_Init == 0)
	        {
	            ScreenCheck_Tick = 2000
	            ScreenCheck_Init = 1
	        }
	        if( ScreenCheck_Tick >= 2000)
	        WinGet MMX, MinMax, ahk_class MAME
	        IfWinActive, ahk_class MAME
	        {
	            ScreenCheck_Tick = 0;
	        WinGetPos, WinX, WinY, Width, Height, ahk_class MAME
	            if( MMX != -1)
	            {
	                if(Width != MameWidth || Height != A_screenHeight || WinX != 0 || WinY != 0) 
	                {
	                    WinSet, Style, -0xC40000, ahk_class MAME
	                    WinMove, ahk_class MAME,, %MameCenter%, 0
	                    WinMove, ahk_class MAME,, , , MameWidth, A_screenHeight
	                    ws_ID := WinExist("ahk_class MAME")
	                    DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,%MameCenter%,Int,0,Int,MameWidth,Int,A_screenHeight,UInt,0x416)
	                    WinActivate, ahk_class MAME
	                }
	            }
	        }

	        if ShouldAct()
	        {

	        joynoloop = 0
	        Last_Tick += 1

	        ;if Last_Tick > 5
	        {
	            GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	            GetKeyState, joy_name, %JoystickNumber%JoyName
	            GetKeyState, joy_info, %JoystickNumber%JoyInfo

	            Last_Tick = 0            
	        }


	        Hotkey, %JoystickPrefix%%ButtonA%, ButtonA
	        Hotkey, %JoystickPrefix%%ButtonB%, ButtonB
	        Hotkey, %JoystickPrefix%%ButtonX%, ButtonX
	        Hotkey, %JoystickPrefix%%ButtonY%, ButtonY
	        Hotkey, %JoystickPrefix%%ButtonLB%, ButtonLB
	        Hotkey, %JoystickPrefix%%ButtonLBR%, ButtonLBR
	        Hotkey, %JoystickPrefix%%ButtonSelect%, ButtonSelect
	        Hotkey, %JoystickPrefix%%ButtonStart%, ButtonStart

	        JoyThresholdUpper := 50 + JoyThreshold
	        JoyThresholdLower := 50 - JoyThreshold
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


	        Sleep, 100
	    }

}

ShouldAct()
{
    if WinActive( "MAME:" )
    {
        return true
    }
    return false
}


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
			If A_LoopField && (PovT += 50)
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
        KeyZToHoldDown = R
        else
        if(joyz < 40)
        KeyZToHoldDown = R
        else
        KeyZToHoldDown = 
    if KeyZToHoldDown = %KeyZToHoldDownPrev%
        return
    SetKeyDelay -1
    if KeyZToHoldDownPrev
        Send, {%KeyZToHoldDownPrev% up}
    if KeyZToHoldDown
        Send, {%KeyZToHoldDown% down}
}
return


ButtonA:
if ShouldAct()
{
	global FrameTick
    Send, {A down}
    SetTimer, WaitForAButtonUp, %FrameTick%
}
return

WaitForAButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonA)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForAButtonUp, off
    Send, {A up}
}
return

ButtonB:
if ShouldAct()
{
	global FrameTick
    Send, {B down}
    SetTimer, WaitForBButtonUp, %FrameTick%
}
return

WaitForBButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonB)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForBButtonUp, off
    Send, {B up}
}
return

ButtonX:
if ShouldAct()
{
	global FrameTick
    Send, {X down}
    SetTimer, WaitForXButtonUp, %FrameTick%
}
return

WaitForXButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonX)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForXButtonUp, off
    Send, {X up}
}
return

ButtonY:
if ShouldAct()
{
	global FrameTick
    Send, {Y down}
    SetTimer, WaitForYButtonUp, %FrameTick%
}
return

WaitForYButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonY)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForYButtonUp, off
    Send, {Y up}
}
return

ButtonLB:
if ShouldAct()
{
	global FrameTick
    Send, {L down}
    SetTimer, WaitForLBButtonUp, %FrameTick%
}
return

WaitForLBButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonLB)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForLBButtonUp, off
    Send, {L up}
}
return

ButtonLBR:
if ShouldAct()
{
	global FrameTick
    Send, {L down}
    SetTimer, WaitForLBRButtonUp, %FrameTick%
}
return

WaitForLBRButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonLBR)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForLBRButtonUp, off
    Send, {L up}
}
return

ButtonSelect:
if ShouldAct()
{
	global FrameTick
    Send, {5 down}
    SetTimer, WaitForSelectButtonUp, %FrameTick%
}
return

WaitForSelectButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonSelect)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForSelectButtonUp, off
    Send, {5 up}
}
return

ButtonStart:
if ShouldAct()
{
	global FrameTick
    Send, {1 down}
    SetTimer, WaitForStartButtonUp, %FrameTick%
}
return

WaitForStartButtonUp:
if ShouldAct()
{
    if GetKeyState(JoystickPrefix . ButtonStart)
        return  ; The button is still, down, so keep waiting.
    ; Otherwise, the button has been released.
    SetTimer, WaitForStartButtonUp, off
    Send, {1 up}
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
