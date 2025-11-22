#Requires AutoHotkey v2.0
#SingleInstance
Persistent


Loop
{

notifyIconOverflowWindowHandle := DllCall("FindWindow","Str","NotifyIconOverflowWindow","Ptr",0)
overflowNotificationAreaHandle := DllCall("FindWindowEx","UInt",notifyIconOverflowWindowHandle, "UInt", 0, "str", "ToolbarWindow32","str", "Overflow Notification Area")

if overflowNotificationAreaHandle
{

DllCall("SetWindowPos","UInt",notifyIconOverflowWindowHandle ,"UInt",1,"Int",0,"Int",0,"Int",400,"Int",300,"UInt",0x0013)
}
Sleep 200

}