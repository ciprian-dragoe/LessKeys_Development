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
    send e
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

    send f
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
    
    send f
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
    
    send r
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

    send {up}
}

processCtrlDown()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        moveNoteWindowAndSetCursorEnd("down")
        return
    }

    send {down}
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

    send {F1}
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

    send {F2}
}

processModifierWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        modifiers := SubStr(combination, 1, StrLen(combination)-1)
        extraInstructions := ["{home}"]
        if (number = 1)
        {
            extraInstructions := ["{F7}"] ; unfold tasks
        }
        if (number = 3 || number = 7 || number = 8 || number = 9)
        {
            extraInstructions := ["{home}{F6}"] ; fold tasks
        }
        if (number = 4)
        {
            extraInstructions := ["{home}{ctrl down}{shift down}{F9}{ctrl up}{shift up}"]
        }
        if (number = 0)
        {
            extraInstructions := []
        }

        changeViewMlo(combination, extraInstructions)
        return
    }

    send {blind}{%number%}
}

processCtrlShiftWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        extraInstructions := ["{home}"]
        if (number = 0)
        {
            extraInstructions := []
        }

        changeViewMlo(number, extraInstructions)
        return
    }

    send {%number%}
}

processCtrlAltWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        extraInstructions := ["{home}"]
        if (number = 1)
        {
            extraInstructions := ["{F7}"]
        }
        if (number = 3 || number = 7 || number = 8 || number = 9)
        {
            extraInstructions := ["{home}{F6}"]
        }
        if (number = 4)
        {
            extraInstructions := ["{home}{ctrl down}{shift down}{F9}{ctrl up}{shift up}"]
        }
        if (number = 0)
        {
            extraInstructions := []
        }

        changeViewMlo(number, extraInstructions)
        return
    }

    send {%number%}
}

processShiftAltWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        extraInstructions := ["{home}"]
        if (number = 1)
        {
            extraInstructions := ["{F7}"]
        }
        if (number = 3 || number = 7 || number = 8 || number = 9)
        {
            extraInstructions := ["{home}{F6}"]
        }
        if (number = 4)
        {
            extraInstructions := ["{home}{ctrl down}{shift down}{F9}{ctrl up}{shift up}"]
        }
        if (number = 0)
        {
            extraInstructions := []
        }

        changeViewMlo(number, extraInstructions)
        return
    }

    send {%number%}
}
