global previousState := ""
global previousState := ""
global result := ""
global duration = 500

show(value, duration = 500)
{
	tooltip % value
	;duration := duration - 20
	;sleep %duration%
	;tooltip
	;setTimer timerHideTooltip, %duration%
}

Bin(x, totalBytes = 32){
	result := ""
	while x
	{
		r:=1&x r,x>>=1
	}
	result := result . r

	leadingZeroAmount := totalBytes - strlen(result)
	Loop %leadingZeroAmount%
	{
		result := "0" . result
	}
	
	return result
}



pressedKeys()
{
	currentState := ""
	VarSetCapacity(RECT, 256, 0)
	DllCall("GetKeyboardState", "Ptr",&RECT)
	loop, 64
	{
		
			currentState := currentState . Bin(NumGet(&RECT, (A_Index - 1) * 4, "Int")) . "     "
			if (!Mod(A_Index, 6)) {
				currentState := currentState . "`n"
			}
		
	}
	
	show(currentState, duration)
}


setTimer timerPressedKeys, %duration%









timerPressedKeys:
	pressedKeys()
return





timerHideTooltip:
	tooltip
return



f1::
	tooltip reload
	sleep 500
	tooltip
	reload
return



f2::
    show("exit")
    exitApp
return

