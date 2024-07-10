#Requires AutoHotkey v2.0
#SingleInstance
Persistent

global avMousePosX, avMousePosY, NotifWidth, NotifHeight

Send "#b{Space}"
Sleep 200

notifyIconOverflowWindowHandle := DllCall("FindWindow","Str","NotifyIconOverflowWindow","Ptr",0)
overflowNotificationAreaHandle := DllCall("FindWindowEx","UInt",notifyIconOverflowWindowHandle, "UInt", 0, "str", "ToolbarWindow32","str", "Overflow Notification Area")

if overflowNotificationAreaHandle
{
CoordMode "Mouse", "Screen"
MouseGetPos &avMousePosX, &avMousePosY
WinGetPos , , &NotifWidth, &NotifHeight, "ahk_id " . notifyIconOverflowWindowHandle

DllCall("SetWindowPos","UInt",notifyIconOverflowWindowHandle ,"UInt",1,"Int",avMousePosX,"Int",avMousePosY,"Int",400,"Int",300,"UInt",0x0001)
Sleep 200
}
