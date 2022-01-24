;BlockInput, On

show(value, time = 600)
{
    tooltip, |%value%|
    sleep %time%
    tooltip
}

processHook(nCode, wParam, lParam)
{
    keyScanCode := NumGet(lParam+0) >> 32

	toExecute := 1
	count := 30
	if (toExecute = 1)
	{
		starttime := A_TickCount
		initial := 24
		Loop, %count%
		{
			initial := initial * initial
		}
		elapsedtime := A_TickCount - starttime
		;show("keyScanCode = " . keyScanCode . "    wParam = " . wParam . "    time = " . elapsedtime)
    }

	if (wParam = 256)
    {
        ;sendKeyDown(keyScanCode)
    }
    else if (wParam = 257)
    {
        ;sendKeyUp(keyScanCode)
    }
    return 1 ; opreste sa trimita mai departe
}

hookStoreLocation := DllCall("SetWindowsHookEx", "int", 13, "uint", RegisterCallback("processHook"), "uint", 0, "uint", 0)
