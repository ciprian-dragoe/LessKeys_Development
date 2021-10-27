;BlockInput, On

processHook(nCode, wParam, lParam)
{
    keyScanCode := NumGet(lParam+0) >> 32
    showtooltip("keyScanCode = " . keyScanCode . "    wParam = " . wParam)
    if (wParam = 256)
    {
        ;sendKeyDown(keyScanCode)
    }
    else if (wParam = 257)
    {
        ;sendKeyUp(keyScanCode)
    }
    return 0
}

hookStoreLocation := DllCall("SetWindowsHookEx", "int", 13, "uint", RegisterCallback("processHook"), "uint", 0, "uint", 0)
