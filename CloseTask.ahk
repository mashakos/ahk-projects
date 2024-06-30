;CloseTask("The Maxifier.exe")

CloseTask(TaskName) {
	pid := ProcessExist(TaskName)
	if (pid > 0)
	Process, Close, %pid%
}

ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
}