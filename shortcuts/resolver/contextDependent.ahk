processModifierWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        modifiers := SubStr(combination, 1, StrLen(combination)-1)
        extraInstructions := ["{home}", "{F6}"]

        stopTimerFlashMinutesUp()
        MLO_TIMER_FLASH_ARE_YOU_WORKING := 0
        if (number = 1)
        {
            extraInstructions := ["{home}", "{F7}"]
        }
        else if (number = 2 && modifiers = "^")
        {
            MLO_TIMER_FLASH_ARE_YOU_WORKING := 180000
            extraInstructions := ["{end}", "{F7}"]
            setTimer timerFlashMinutesUp, %MLO_TIMER_FLASH_ARE_YOU_WORKING%
        }
        else if (number = 3 && modifiers = "^")
        {
            MLO_TIMER_FLASH_ARE_YOU_WORKING := 180000
            extraInstructions := ["{end}", "{F7}"]
            setTimer timerFlashMinutesUp, %MLO_TIMER_FLASH_ARE_YOU_WORKING%
        }
        else if (number = 4 && modifiers = "^")
        {
            MLO_TIMER_FLASH_ARE_YOU_WORKING := 180000
            extraInstructions := ["{end}", "{F7}"]
            setTimer timerFlashMinutesUp, %MLO_TIMER_FLASH_ARE_YOU_WORKING%
        }
        else if (number = 5)
        {
            extraInstructions := ["{F7}", "{home}"]
        }

        changeViewMlo(combination, extraInstructions)
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
    IfInString, lastActiveAppName, %FREEPLANE_NOTE_WINDOW_NAME%
    {
        CloseFreeplaneNotes()
        return
    } 
    IfInString, lastActiveAppName, %FREEPLANE_WINDOW_NAME%
    {
        ShowFreeplaneNotes(FREEPLANE_NOTE_WINDOW_NAME)
        return
    }
    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        ShowSimplemindNotes(SIMPLEMIND_NOTE_WINDOW_NAME)
        return
    }
    IfInString, lastActiveAppName, %SIMPLEMIND_NOTE_WINDOW_NAME%
    {
        CloseSimplemindNotes()
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
