#Requires AutoHotkey v2.0

;Take call key
^!s::
{
    Run "calc"
}

;Share screen key
!^F22::
{
    ; PHPStorm - select similar
    Send "!^+j"
}

;End call key
!^F21::
{
    Send "{Media_Prev}"
}

;End cam key
!^F23::
{
    Send "{Media_Play_Pause}"
}

;Mute mic key
!^F24::
{
    Send "{Media_Next}"
}