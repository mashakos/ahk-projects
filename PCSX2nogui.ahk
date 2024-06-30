; <COMPILER: v1.1.22.00>
#NoEnv
#NoTrayIcon
SetTitleMatchMode, 2

input1 = %1%
input2 = %2%
input3 = %3%

if( InStr(input2,"--") > 0)
{
Run %1% "%input3%" %input2%  --nogui --fullscreen
}
else
{
Run %1% "%input2%"  --nogui --fullscreen
if %3%
Run %3%
}
Process, Exist, pcsx2x.exe
if ErrorLevel != 0
{
	proc_id = pcsx2x.exe
}
Else
{
	proc_id = pcsx2.exe
}
WinWaitActive, GSdx, , 2
WinWaitClose
Process, Close, %proc_id%