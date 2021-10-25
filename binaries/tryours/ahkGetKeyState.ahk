global result := ""
global keys := ["space", "ctrl", "lctrl"]

show(value, duration = 500)
{
	tooltip % value
	setTimer timerHideTooltip, %duration%
}

pressedKeys()
{
	result := ""
	for key, value in keys
	{
		result := result . "`n" . value . " = " . getkeyState(value, "P")
	}
	show(result)
}


exit()
{
	show("exit")
    exitApp
}


setTimer timerPressedKeys, 500

timerPressedKeys:
	pressedKeys()
return

timerHideTooltip:
	tooltip % result
return


f1::
	exit()
return

f2::
	show("reload")
	reload
return