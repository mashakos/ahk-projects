#Requires AutoHotkey v2.0

!^F16::
{
Run "D:\ThrottleStop\ThrottleStop.exe"
}

!^F17::
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

!^F22::
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