global tobiCoordX := 0
global tobiCoordY := 0
global canGetTobiCoord := 1
global debug := 0
global MaxResolutionX := 2560
global MaxResolutionY := 1440

getTobiMouseCoord()
{
        RunWait, tobiiWrapper.exe, ,Hide UseErrorLevel
        divisor := 10000
        tobiCoordX := Mod(ErrorLevel, divisor)
        tobiCoordY := Floor(ErrorLevel/divisor)
}

a::
        if (canGetTobiCoord) {
                getTobiMouseCoord()
        }
        tobiCoordX -= 5
        tobiCoordX := Max(tobiCoordX, 1)
        canGetTobiCoord := 0
        MouseMove, tobiCoordX, tobiCoordY
return
a up::
        if (GetKeyState("s", "P") || GetKeyState("d", "P") || GetKeyState("s", "f")) {
		return
	}
	canGetTobiCoord := 1
return


s::
	if (canGetTobiCoord) {
		getTobiMouseCoord()
	}
	tobiCoordY += 5
	tobiCoordY := Min(tobiCoordY, MaxResolutionY)
	canGetTobiCoord := 0
	MouseMove, tobiCoordX, tobiCoordY
return
s up::
	if (GetKeyState("a", "P") || GetKeyState("d", "P") || GetKeyState("s", "f")) {
		return
	}
	canGetTobiCoord := 1
return


d::
	if (canGetTobiCoord) {
		getTobiMouseCoord()
	}
	tobiCoordY -= 5
	tobiCoordY := Max(tobiCoordY, 0)
	canGetTobiCoord := 0
	MouseMove, tobiCoordX, tobiCoordY
return
d up::
	if (GetKeyState("s", "P") || GetKeyState("d", "P") || GetKeyState("s", "f")) {
		return
	}
	canGetTobiCoord := 1
return


f::
	if (canGetTobiCoord) {
		getTobiMouseCoord()
	}
	tobiCoordX += 5
	tobiCoordX := Min(tobiCoordX, MaxResolutionX)
	canGetTobiCoord := 0
	MouseMove, tobiCoordX, tobiCoordY
return
f up::
	if (GetKeyState("s", "P") || GetKeyState("d", "P") || GetKeyState("s", "f")) {
		return
	}
	canGetTobiCoord := 1
return


F1::
	showToolTip("RELOADING")
	reload
return


F2::
	if (debug) {
		debug := 0
		showToolTip("DEBUG -> 0")
	} else {
		debug := 1
		showToolTip("DEBUG -> 1")
	}
return


f12::
	showToolTip("EXIT")
	ExitApp
return


showToolTip(message)
{
	tooltip %message%
	sleep 800
	tooltip
}	