#Persistent
SetDefaultMouseSpeed, 0 


global mouseLeft := "j"
global mouseDown := "k"
global mouseUp := "l"
global mouseRight := ";"

Hotkey, %mouseLeft%, nothing
Hotkey, %mouseDown%, nothing
Hotkey, %mouseUp%, nothing
Hotkey, %mouseRight%, nothing


global resetX := false
global resetY := false





global x
global y
global TimeoutUpdateMousePosition := 10
global resetOnSameKeyPressXaxis := 0
global resetOnSameKeyPressYaxis := 0
global thresholdResetOnSameKeyPress := 0
global TimeoutEnableMoveAgain := 150
global lastKeyPressedXaxis := ""
global lastKeyPressedYaxis := ""
global counterThreshold := 60
global counterIncreaseX := 0
global counterIncreaseY := 0
global allowMoveDown := true
global allowMoveUp := true
global allowMoveLeft := true
global allowMoveRight := true
global counterResetAmount := 20
global maxAccelerationX := 30
global minAccelerationX := 1
global maxAccelerationY := 25
global minAccelerationY := 1
global differenceX := 0
global differenceY := 0
global maxX := 2560
global maxY := 1440
global stopOnLeftDirectionLift := false
global stopOnRightDirectionLift := false
global stopOnUpDirectionLift := false
global stopOnDownDirectionLift := false
global stopOnMaxAcceeration := false
global canGetTobiiCoord := true

CoordMode, Mouse, Screen


*space::
    if (canGetTobiiCoord) {
        getTobiMouseCoord()
        canGetTobiiCoord := false
    }
    SetTimer, UpdateMousePosition, %TimeoutUpdateMousePosition%
return
*space up::
    SetTimer, UpdateMousePosition, OFF
    differenceY := 0
    differenceX := 0
    canGetTobiiCoord := true
return


f1::
    show("RELOADING")
    reload
return


f12::
    show("EXIT")
    reload
return


show(value, time = 500) {
    toolTip % value
    sleep %time%
    tooltip
}


debugMouseCoord:
    show(x . "|" . y)
return


UpdateMousePosition:
    setDirectionVariablesXaxis()
    setDirectionVariablesYaxis()

    y := y + differenceY
    if (y < 0) {
        y := 0
    } else if (y > maxY) {
        y := maxY
    }
    x := x + differenceX
    if (x < 0) {
        x := 0
    } else if (x > maxX) {
        x := maxX
    }
    DllCall("SetCursorPos", "int", x, "int", y)
return


setDirectionVariablesXaxis() {
    if (GetKeyState(mouseRight)) {
        if (lastKeyPressedXaxis = mouseRight) {
            counterIncreaseX += TimeoutUpdateMousePosition
        } else {
            counterIncreaseX := 0
            if (resetOnSameKeyPressXaxis > thresholdResetOnSameKeyPress && differenceX > 0) {
                differenceX := 0
                resetOnSameKeyPressXaxis := 0
                allowMoveRight := false
                SetTimer, EnableMoveRight, %TimeoutEnableMoveAgain%
            } else if (allowMoveRight) {
                differenceX := minAccelerationX
            }
        }
        if (counterIncreaseX > counterThreshold) {
            if (differenceX < maxAccelerationX) {
                    differenceX++
                                counterIncreaseX -= counterResetAmount
                        } else {
                                stopOnRightDirectionLift := true
                        }
                }

                lastKeyPressedXaxis := mouseRight
                return
        }

        if (GetKeyState(mouseLeft)) {
                if (lastKeyPressedXaxis = mouseLeft) {
                        counterIncreaseX += TimeoutUpdateMousePosition
                } else {
                        counterIncreaseX := 0
                        if (resetOnSameKeyPressXaxis > thresholdResetOnSameKeyPress && differenceX < 0) {
                                differenceX := 0
                                resetOnSameKeyPressXaxis := 0
                                allowMoveLeft := false
                                SetTimer, EnableMoveLeft, %TimeoutEnableMoveAgain%
                        } else if (allowMoveLeft) {
                                differenceX := -minAccelerationX
                        }
                }
                if (counterIncreaseX > counterThreshold) {
                        if (differenceX > -maxAccelerationX) {
                                differenceX--
                                counterIncreaseX -= counterResetAmount
                        } else {
                                stopOnLeftDirectionLift := true
            }
        }

        lastKeyPressedXaxis := mouseLeft
        return
    }

    lastKeyPressedXaxis := ""
    resetOnSameKeyPressXaxis += 1
    if (stopOnMaxAcceeration && stopOnLeftDirectionLift || stopOnRightDirectionLift) {
        differenceX := 0
        stopOnLeftDirectionLift := false
        stopOnRightDirectionLift := false
    }
}

setDirectionVariablesYaxis() {
    if (GetKeyState(mouseDown)) {
        if (lastKeyPressedYaxis = mouseDown) {
            counterIncreaseY += TimeoutUpdateMousePosition
        } else {
            counterIncreaseY := 0
            if (resetOnSameKeyPressYaxis > thresholdResetOnSameKeyPress && differenceY > 0) {
                differenceY := 0
                resetOnSameKeyPressYaxis := 0
                allowMoveDown := false
                SetTimer, EnableMoveDown, %TimeoutEnableMoveAgain%
            } else if (allowMoveDown) {
                differenceY := minAccelerationY
            }
        }
        if (counterIncreaseY > counterThreshold) {
            if (differenceY < maxAccelerationY) {
                differenceY++
                counterIncreaseY -= counterResetAmount
            } else {
                stopOnDownDirectionLift := true
            }
        }

		lastKeyPressedYaxis := mouseDown
		return
	}
	
	if (GetKeyState(mouseUp)) {
		if (lastKeyPressedYaxis = mouseUp) {
			counterIncreaseY += TimeoutUpdateMousePosition
		} else {
			counterIncreaseY := 0
			if (resetOnSameKeyPressYaxis > thresholdResetOnSameKeyPress && differenceY < 0) {
				differenceY := 0
				resetOnSameKeyPressYaxis := 0
				allowMoveUp := false
				SetTimer, EnableMoveUp, %TimeoutEnableMoveAgain%
			} else if (allowMoveUp) {
				differenceY := -minAccelerationY
			}
		}
		if (counterIncreaseY > counterThreshold) {
			if (differenceY > -maxAccelerationY) {
				differenceY--
				counterIncreaseY -= counterResetAmount
			} else {
				stopOnUpDirectionLift := true
			}
		}
		
		lastKeyPressedYaxis := mouseUp
		return
	}
	
	lastKeyPressedYaxis := ""
	resetOnSameKeyPressYaxis += 1
	if (stopOnMaxAcceeration && stopOnUpDirectionLift || stopOnDownDirectionLift) {
		differenceY := 0
		stopOnUpDirectionLift := false
		stopOnDownDirectionLift := false
	}
}


getTobiMouseCoord()
{
	RunWait, tobiiWrapper.exe, ,Hide UseErrorLevel
	divisor := 10000
	x := Mod(ErrorLevel, divisor)
	y := Floor(ErrorLevel/divisor)
}


EnableMoveUp:
	SetTimer, EnableMoveUp, OFF
	allowMoveUp := true
return

EnableMoveDown:
	SetTimer, EnableMoveDown, OFF
	allowMoveDown := true
return

EnableMoveRight:
	SetTimer, EnableMoveRight, OFF
	allowMoveRight := true
return

EnableMoveLeft:
	SetTimer, EnableMoveLeft, OFF
	allowMoveLeft := true
return


nothing:
return