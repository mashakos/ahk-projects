; <COMPILER: v1.1.05.04>
#Persistent
#SingleInstance Force
DetectHiddenWindows, ON
iniFile=config\settings.ini
IfNotExist,%iniFile%
{
	MsgBox, 0, Setup, Not so fast! We need to set the app up first.`n -mashakos.
	FileAppend, /*----------Devices---------`n, %iniFile%
	Sleep, 50
	Run cmd /c config\EndPointController.exe>>%iniFile%, , Hide, PID1
	Sleep, 100
	FileAppend, --------------------------*/`n, %iniFile%
	Sleep, 100
	FileRead, iniDevices, %iniFile%
	InputBox, stdDev, Step 1,
		(
	Here are the audio outputs on your PC:
	%iniDevices%

	Standard output:
	Please enter the device number of your PC's standard output (the one that does not require Dolby Digital Live or DTS Connect).
	), , 480, 320
	if ErrorLevel
	{
		Filedelete,%iniFile%
		MsgBox, 0, Setup,
				(
		Oh well, you don't want to use this app. Fine!
		-mashakos.
		)
		ExitApp
	}
	InputBox, rteDev, Step 2,
		(
	Here are the audio outputs on your PC:
	%iniDevices%

	Real-time Encoding output:
	Please enter the device number of the output used for realt-time encoding on your PC (the one that does require Dolby Digital Live or DTS Connect).
	), , 480, 320
	if ErrorLevel
	{
		Filedelete,%iniFile%
		MsgBox, 0, Setup,
				(
		Oh well, you don't want to use this app. Fine!
		-mashakos.
		)
		ExitApp
	}
	FileAppend, `n, %iniFile%
	FileAppend, [Device]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Standard=%stdDev%`n, %iniFile%
	FileAppend, Digital=%rteDev%`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, [ForceSoundcard]`n, %iniFile%
	FileAppend, `n, %iniFile%
	MsgBox, 4, Step 3,
		(
	Does real-time encoding require an app to run in order for it to work on your PC?
	)
	IfMsgBox Yes
	{
		FileAppend, Enabled=1`n, %iniFile%
		MsgBox, 4, Step 4,
				(
		Do you have an Asus Xonar soundcard on your PC?
		)
		IfMsgBox Yes
		{
		FileAppend, AppSrc="C:\Program Files\ASUS Xonar D2X Audio\Customapp\AsusAudioCenter.exe"`n, %iniFile%
		MsgBox, 0, Done,
					(
		You are Done!
		You can always change the default location of the Asus Xonar Audio Center app in the settings.ini file, found in the config folder.
		Please check out the readme file for instructions on how to use this app. Have fun!
		-mashakos
		)
		ExitApp
		}
		else
		{
		Gui, Add, Text, x25 y30,
					(
		Since you aren't using an Asus Xonar soundcard,
		which app does your soundcard use as a control panel?
		)
		Gui, Add, Button,gBrowse x225 y75 w60 h20 , Browse
		Gui, Add, Edit, x25 y75 w190 h20 , Select app using the browse button.
		Gui, Show, xCenter yCenter h140 w320, Select soundcard control panel app
		Return
		Browse:
		FileSelectFile, SelectedFile, 3, , Select your soundcard's control panel app
		FileAppend, AppSrc=%SelectedFile%`n, %iniFile%
		Return
		}
	}
	else
	{
		FileAppend, Enabled=0`n, %iniFile%
		MsgBox, 0, Done,
				(
		You are Done!
		You can always manually edit your settings in the settings.ini file, found in the config folder.
		Please check out the readme file for instructions on how to use this app. Have fun!
		-mashakos
		)
		ExitApp
	}
}
else
{
	If 0 < 1
	{
		MsgBox, 0, No app/game specified for switching,
				(
		That's not how you use this app!
		Please check out the readme file for instructions.
		-mashakos
		)
		ExitApp
	}
	StringReplace, 1, 1, ",, All
	rawGameCheck = 0
	forceGameCheck = 0
	gameCheckerCnt = 0
	forceCheck = "-force"
	uplayCheck = "-uplay"
	nofrapsCheck = "-nofraps"
	gedosatoCheck = "-gedosato"
	IniRead, ddldevice, %iniFile%, Device, Digital
	IniRead, refdevice, %iniFile%, Device, Standard
	IniRead, GedosatoPath, %iniFile%, GeDoSaTo, Path
	IniRead, forceEnable, %iniFile%, ForceSoundcard, Enabled
	IniRead, feAppSrc, %iniFile%, ForceSoundcard, AppSrc
	if 0 > 2 and ( ( InStr(1,uplayCheck) > 0  and InStr(2,nofrapsCheck) > 0) or ( InStr(2,uplayCheck) > 0  and InStr(1,nofrapsCheck) > 0) )
	{
		Process, Exist, fraps.exe
		Process, Close, fraps.exe
		Process, Exist, fraps64.dat
		Process, Close, fraps64.dat
		rawfilestr = %3%
		if (RegExMatch(rawfilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(rawfilestr,".*?.((?:(exe|bat|lnk)+))", rawPath)
			fileParams := SubStr(rawfilestr,StrLen(rawPath) + 1)
		}
		else
			rawPath = %3%
		SplitPath, rawPath, fileName, filePath
		Run config\EndPointController.exe %ddldevice%, , Hide
		if(forceEnable == 1)
		{
			Run, %feAppSrc%, , Hide
			WinWait, Xonar
			Sleep 50
			WinClose
		}
		Run "%rawPath%" %fileParams%, %filePath%, , winpid
		Sleep 50
		SetTimer, processnoFrapsUplay, 1000
	}	
	else
	if 0 > 1 and InStr(1,gedosatoCheck) > 0
	{
		Process, Exist, GeDoSaToTool.exe
		if( ErrorLevel == 0 )
			Run, %GedosatoPath%, , min
		rawfilestr = %2%
		if (RegExMatch(rawfilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(rawfilestr,".*?.((?:(exe|bat|lnk)+))", rawPath)
			fileParams := SubStr(rawfilestr,StrLen(rawPath) + 1)
		}
		else
			rawPath = %2%
		SplitPath, rawPath, fileName, filePath
		Run config\EndPointController.exe %ddldevice%, , Hide
		if(forceEnable == 1)
		{
			Run, %feAppSrc%, , Hide
			WinWait, Xonar
			Sleep 50
			WinClose
		}
		Run "%rawPath%" %fileParams%, %filePath%, , winpid
		Sleep 50
		SetTimer, processcheckGedosato, 1000
	}
	else
	if 0 > 2 and InStr(2,forceCheck) > 0
	{
		forceGameFileName = %3%
		forcegamefilestr = %1%
		if (RegExMatch(forcegamefilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(forcegamefilestr,".*?.((?:(exe|bat|lnk)+))", forceGamePath)
			forceFileParams := SubStr(forcegamefilestr,StrLen(forceGamePath) + 1)
		}
		else
			forceGamePath = %1%
		SplitPath, forceGamePath, forceMidGameFileName, forceGameFilePath
		Run config\EndPointController.exe %ddldevice%, , Hide
		if(forceEnable == 1)
		{
			Run, %feAppSrc%, , Hide
			WinWait, Xonar
			Sleep 50
			WinClose
		}
		Run "%forceGamePath%" %forceFileParams%, %forceGameFilePath%, , forcegamepid
		SetTimer, processcheckForceGame, 1000
	}
	else
	if 0 > 1 and InStr(1,uplayCheck) > 0
	{
		rawfilestr = %2%
		if (RegExMatch(rawfilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(rawfilestr,".*?.((?:(exe|bat|lnk)+))", rawPath)
			fileParams := SubStr(rawfilestr,StrLen(rawPath) + 1)
		}
		else
			rawPath = %2%
		SplitPath, rawPath, fileName, filePath
		Run config\EndPointController.exe %ddldevice%, , Hide
		if(forceEnable == 1)
		{
			Run, %feAppSrc%, , Hide
			WinWait, Xonar
			Sleep 50
			WinClose
		}
		Run "%rawPath%" %fileParams%, %filePath%, , winpid
		Sleep 50
		SetTimer, processcheckUplay, 1000
	}	
	else
	if %2%
	{
		rawgamefilestr = %2%
		if (RegExMatch(rawgamefilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(rawgamefilestr,".*?.((?:(exe|bat|lnk)+))", rawGamePath)
			fileParams := SubStr(rawgamefilestr,StrLen(rawGamePath) + 1)
		}
		else
		rawGamePath = %2%
		SplitPath, rawGamePath, gameFileName, gameFilePath
		launchergamefilestr = %1%
		if (RegExMatch(launchergamefilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(launchergamefilestr,".*?.((?:(exe|bat|lnk)+))", launcherGamePath)
			launcherfileParams := SubStr(launchergamefilestr,StrLen(launcherGamePath) + 1)
		}
		else
		launcherGamePath = %1%
		SplitPath, launcherGamePath, launcherFileName, launcherFilePath
		Run config\EndPointController.exe %ddldevice%, , Hide
		if(forceEnable == 1)
		{
			Run, %feAppSrc%, , Hide
			WinWait, Xonar
			Sleep 50
			WinClose
		}
		Run "%launcherGamePath%" %launcherfileParams%, %launcherFilePath%, , launcherpid
		loop
		{
			sleep 500
			rawGameCheck++
			Process Exist, %launcherFileName%
			if ErrorLevel = 0
			{
				Run config\EndPointController.exe %refdevice%, , Hide
				ExitApp
			}
			else
			Process Exist, %gameFileName%
			if ErrorLevel = 0
			{
				if( rawGameCheck > 14)
				{
					Process Exist, %launcherFileName%
					if ErrorLevel = 0
					{
						Run config\EndPointController.exe %refdevice%, , Hide
						ExitApp
					}
				}
			}
			else
			{
				rawfilestr = %2%
				if (RegExMatch(rawfilestr, ".*?.((?:(exe|bat|lnk)+))"))
				{
					substartPos := RegExMatch(rawfilestr,".*?.((?:(exe|bat|lnk)+))", rawPath)
					fileParams := SubStr(rawfilestr,StrLen(rawPath) + 1)
				}
				else
					rawPath = %2%
				SplitPath, rawGamePath, gameFileName, gameFilePath
				SetTimer, processcheckLauncher, 1000
				break
			}
		}
	}
	else
	{
		rawfilestr = %1%
		if (RegExMatch(rawfilestr, ".*?.((?:(exe|bat|lnk)+))"))
		{
			substartPos := RegExMatch(rawfilestr,".*?.((?:(exe|bat|lnk)+))", rawPath)
			fileParams := SubStr(rawfilestr,StrLen(rawPath) + 1)
		}
		else
			rawPath = %1%
		SplitPath, rawPath, fileName, filePath
		Run config\EndPointController.exe %ddldevice%, , Hide
		if(forceEnable == 1)
		{
			Run, %feAppSrc%, , Hide
			WinWait, Xonar
			Sleep 50
			WinClose
		}
		Run "%rawPath%" %fileParams%, %filePath%, , winpid
		Sleep 50
		SetTimer, processcheck, 1000
	}
}
processcheck:
	gameCheckerCnt++
	if( gameCheckerCnt > 20)
		SetTimer, processcheck, 500
	Process, Exist, %fileName%
	if( ErrorLevel == 0 )
	{
		Run config\EndPointController.exe %refdevice%, , Hide
		SetTimer, processcheck, off
		ExitApp
	}
return
processcheckLauncher:
	gameCheckerCnt++
	if( gameCheckerCnt > 20)
		SetTimer, processcheck, 500
	Process, Exist, %gameFileName%
	if( ErrorLevel == 0 )
	{
		Run config\EndPointController.exe %refdevice%, , Hide
		SetTimer, processcheckLauncher, off
		ExitApp
	}
return
processcheckForceGame:
	gameCheckerCnt++
	if( gameCheckerCnt > 20)
		SetTimer, processcheck, 500
	forceGameCheck++
	Process, Exist, %forceGameFileName%
	if( ErrorLevel == 0 )
	{
		if( forceGameCheck > 30)
		if( ErrorLevel == 0 )
		{
		Run config\EndPointController.exe %refdevice%, , Hide
		SetTimer, processcheckForceGame, off
		ExitApp
		}
	}
return
processcheckGedosato:
	gameCheckerCnt++
	if( gameCheckerCnt > 20)
		SetTimer, processcheckGedosato, 500
	Process, Exist, %fileName%
	if( ErrorLevel == 0 )
	{
		Run config\EndPointController.exe %refdevice%, , Hide
		SetTimer, processcheckGedosato, off
		Process, Exist, GeDoSaToTool.exe
		Process, Close, GeDoSaToTool.exe		
		ExitApp
	}
return
processcheckUplay:
	gameCheckerCnt++
	if( gameCheckerCnt > 20)
		SetTimer, processcheckUplay, 500
	Process, Exist, %fileName%
	if( ErrorLevel == 0 )
	{
		Run config\EndPointController.exe %refdevice%, , Hide
		SetTimer, processcheckUplay, off
		WinWaitActive, ahk_class uplay_main
		WinClose, ahk_class uplay_main
		ExitApp
	}
return
processnoFrapsUplay:
	gameCheckerCnt++
	if( gameCheckerCnt > 20)
		SetTimer, processnoFrapsUplay, 500
	Process, Exist, %fileName%
	if( ErrorLevel == 0 )
	{
		Run config\EndPointController.exe %refdevice%, , Hide
		SetTimer, processnoFrapsUplay, off
		WinWaitActive, ahk_class uplay_main
		WinClose, ahk_class uplay_main
		Run, C:\Fraps\fraps.exe
		ExitApp
	}
return
