global CONCEPTS_WINDOW_NAME := "Concepts"
global IS_SCREEN_ROTATED := 0

processConceptsEnhancements()
{
    If (inStr(lastActiveAppName, CONCEPTS_WINDOW_NAME, true))
    {
        if (!IS_SCREEN_ROTATED && A_ComputerName = ACTIVE_COMPUTER_X1_EXTREME)
        {
            IS_SCREEN_ROTATED := 1
            sendKeyCombinationIndependentActiveModifiers("^!{down}") ; change screen orientation 180 degrees
        }
    }
    else if (IS_SCREEN_ROTATED)
    {
        IS_SCREEN_ROTATED := 0
        sendKeyCombinationIndependentActiveModifiers("^!{up}") ; change screen orientation 0 degrees
    }
}

conceptsTemplate(templateNumber)
{
    send ^o
    WinWaitActive, ahk_class #32770, , 2
    sleep 100
    send +{tab}+{tab}
    sleep 100
    send %templateNumber%
    sleep 100
    send {enter}
    WinWaitActive, ahk_class ApplicationFrameWindow, , 2
    send ^+s
    WinWaitActive, ahk_class #32770, , 2
    send +{tab}+{tab}
    send %templateNumber%
    send {f2}
    sleep 50
    send {right}3{shift down}{home}{right 2}{shift up}^c{escape}
    sleep 200
    send {tab 2}
    sleep 200
    send ^v - %A_YYYY%.%A_MM%.%A_DD% [%A_Hour%]-[%A_Min%]
    send {enter}
}

OpenTemplate(templateNumber, tabNr = 2)
{
    send ^o
    if (tabNr = 2) {
        WinWaitActive, ahk_class #32770, , 2
    }
    if (tabNr = 1) {
        WinWaitActive, ahk_class %FREEPLANE_CLASS_NAME%, , 2
    }
    sleep 100
    send +{tab %tabNr%}
    sleep 100
    send %templateNumber%
    sleep 100
    send {enter}
}
