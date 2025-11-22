#Requires AutoHotkey v2.0


AppsKey & F9::Volume_Down

AppsKey & F10::Volume_Up

AppsKey & F11::
{
	AdjustScreenBrightness(-10)
	return
}

AppsKey & F12::
{
	AdjustScreenBrightness(10)
	return
}

!^F16::
{
Run "D:\ThrottleStop\ThrottleStop.exe"
}

; Maingear Vector Pro Fn 
SC178 & 2::
{
Run "D:\ThrottleStop\ThrottleStop.exe"
}

!^F17::
{
Run "D:\DS4Windows\DS4Windows.exe"
}

; Maingear Vector Pro Fn 
SC178 & 3::
{
Run "D:\DS4Windows\DS4Windows.exe"
}

!^F18::
{
Run "C:\Program Files (x86)\Media Downloader\media-downloader.exe"
}

!^F19::
{
Run "C:\Users\Ubertek-PC\AppData\Local\JDownloader 2.0\JDownloader2.exe"
}

!^F20::
{
Run "calc"
}

; Maingear Vector Pro Fn 
SC178 & 1::
{
Run "calc"
}

!^F22::
{
Send "!^+j"
}

; Maingear Vector Pro Fn 
SC178 & 4::
{
Send "!^+j"
}

!^F21::
{
Send "{Media_Prev}"
}

!^F23::
{
Send "{Media_Play_Pause}"
}

!^F24::
{
Send "{Media_Next}"
}


AdjustScreenBrightness(step) {
	static service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"
	monitors := ComObjGet(service).ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE")
	monMethods := ComObjGet(service).ExecQuery("SELECT * FROM wmiMonitorBrightNessMethods WHERE Active=TRUE")
	for i in monitors {
		curr := i.CurrentBrightness
		break
	}
	toSet := curr + step
	if (toSet < 10)
		toSet := 10
	if (toSet > 100)
		toSet := 100
	for i in monMethods {
		i.WmiSetBrightness(1, toSet)
		break
	}
	BrightnessOSD()
}
BrightnessOSD() {
	static PostMessagePtr := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "user32.dll", "Ptr"), "AStr", 1 ? "PostMessageW" : "PostMessageA", "Ptr")
	 ,WM_SHELLHOOK := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK", "UInt")
	static FindWindow := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "user32.dll", "Ptr"), "AStr", 1 ? "FindWindowW" : "FindWindowA", "Ptr")
	HWND := DllCall(FindWindow, "Str", "NativeHWNDHost", "Str", "", "Ptr")
	IF !(HWND) {
		try IF ((shellProvider := ComObject("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{00000000-0000-0000-C000-000000000046}"))) {
			try IF ((flyoutDisp := ComObjQuery(shellProvider, "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}", "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}"))) {
				DllCall(NumGet(NumGet(flyoutDisp+0, "UPtr")+3*A_PtrSize, "UPtr"), "Ptr", flyoutDisp, "Int", 0, "UInt", 0)
				 ,ObjRelease(flyoutDisp)
			}
			ObjRelease(shellProvider)
		}
		HWND := DllCall(FindWindow, "Str", "NativeHWNDHost", "Str", "", "Ptr")
	}
	DllCall(PostMessagePtr, "Ptr", HWND, "UInt", WM_SHELLHOOK, "Ptr", 0x37, "Ptr", 0)
}

;
;
;;Take call key
;^!s::
;{
;    Run "calc"
;}
;
;;Share screen key
;!^F22::
;{
;    ; PHPStorm - select similar
;    Send "!^+j"
;}
;
;;End call key
;!^F21::
;{
;    Send "{Media_Prev}"
;}
;
;;End cam key
;!^F23::
;{
;    Send "{Media_Play_Pause}"
;}
;
;;Mute mic key
;!^F24::
;{
;    Send "{Media_Next}"
;}