processModifierWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        modifiers := SubStr(combination, 1, StrLen(combination)-1)
        extraInstructions := ["{home}", "{F6}"]

        stopTimerFlashMinutesUp()
        MLO_TIMER_FLASH_ARE_YOU_WORKING := 0
        if (number = 9 && modifiers = "^")
        {
            MLO_TIMER_FLASH_ARE_YOU_WORKING := 3000000
            setTimer timerFlashMinutesUp, %MLO_TIMER_FLASH_ARE_YOU_WORKING%
        }
        else if (number = 0)
        {
            extraInstructions := []
        }
        else if (number = 8 && modifiers = "^")
        {
            extraInstructions := ["{F6}", "{home}", "{right}"]
        }

        changeViewMlo(combination, extraInstructions)
        return
    }

    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        setSimplemindFocusTopic("@" . number)
        return
    }

    send {blind}{%number%}
}

processCtrlE()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        WinGetClass, lastActiveClassName, A
        IfInString, lastActiveClassName, %MLO_CLASS_NAME%
        {
            sendKeyCombinationIndependentActiveModifiers("!w")
            return
        }
    }
    send {blind}e
}

processCtrlShiftF()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        WinGetClass, lastActiveClassName, A
        IfInString, lastActiveClassName, %MLO_CLASS_NAME%
        {
            mloCloseFind()
            return
        }
    }

    send {blind}f
}

processCtrlF()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        WinGetClass, lastActiveClassName, A
        IfInString, lastActiveClassName, %MLO_CLASS_NAME%
        {
            mloShowFind()
            return
        }
    }
    
    send {blind}f
}

processCtrlR()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        WinGetClass, lastActiveClassName, A
        IfInString, lastActiveClassName, %MLO_CLASS_NAME%
        {
            sendKeyCombinationIndependentActiveModifiers("!e")
            return
        }
    }
    
    send {blind}r
}

processCtrlW()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        WinGetClass, lastActiveClassName, A
        IfInString, lastActiveClassName, %MLO_CLASS_NAME%
        {
            hideShowMLOnotes()
            return
        }
    }

    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        ControlGetFocus, activeWindowNow, A
        activeWindowNow := activeWindowNow . "_"  ; transform into a string so that comparison can work
        IfInString, activeWindowNow, %SIMPLEMIND_CLASSNN_NOTES%
        {
            sendKeyCombinationIndependentActiveModifiers("+{tab 2}")
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{tab 2}")
        }
        return
    }

    send {blind}w
}

processCtrlUp()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        moveNoteWindowAndSetCursorEnd("up")
        return
    }

    send {blind}{up}
}

processCtrlDown()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        moveNoteWindowAndSetCursorEnd("down")
        return
    }

    send {blind}{down}
}

processShiftF1()
{
    IfInString, lastActiveAppName, %CONCEPTS_WINDOW_NAME%
    {
        conceptsTemplate(1)
        return
    }
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        synthesisTemplateMLO()
        return
    }
    IfInString, lastActiveAppName, %FREEPLANE_WINDOW_NAME%
    {
        freeplaneTemplate(1)
        return
    }

    send {blind}{F1}
}

processShiftF2()
{
    IfInString, lastActiveAppName, %CONCEPTS_WINDOW_NAME%
    {
        conceptsTemplate(2)
        return
    }
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        journalTemplateMLO()
        return
    }
    IfInString, lastActiveAppName, %FREEPLANE_WINDOW_NAME%
    {
        freeplaneTemplate(2)
        return
    }

    send {blind}{F2}
}
