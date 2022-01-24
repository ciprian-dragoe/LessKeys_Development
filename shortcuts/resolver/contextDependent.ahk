
processModifierWithNumber(combination, index)
{
    number := SubStr(combination, 0, 1)
    modifiers := SubStr(combination, 1, StrLen(combination)-1)

    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        return changeViewMloFactory(number, modifiers)
    }

    send {blind}{%number%}
}

processCtrlE()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        MLO_ENTER_MODE_BRAINSTORM := 0
        return sendKeyCombinationIndependentActiveModifiers("!w")
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

processEnter()
{
    if (MLO_ENTER_MODE_NEW_CHILD)
    {
        return confirmAndCreateAnotherTask()
    }

    if (MLO_ENTER_MODE_BRAINSTORM)
    {
        return newBrainStormTask()
    }

    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        return simplemindClearIdeas()
    }

    send {blind}{enter}
}

deactivateAlternativeMloMode(key)
{
    if (MLO_ENTER_MODE_NEW_CHILD)
    {
        MLO_ENTER_MODE_NEW_CHILD := 0
    }

    send {blind}{%key%}
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
        MLO_ENTER_MODE_BRAINSTORM := 0
        return sendKeyCombinationIndependentActiveModifiers("!e")
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

processFunctionKey(key)
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        return goToTaskAndWriteNotes(key)
    }

    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        return setSimplemindFocusTopic(key)
    }

    send {blind}{%key%}
}

processNavigation(key)
{
    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        return navigateAndCenter(key)
    }

    send {blind}{%key%}
}

processCtrlQ()
{
    IfInString, lastActiveAppName, %SIMPLEMIND_WINDOW_NAME%
    {
        return centerBrainstorm()
    }

    send ^q
}

processCtrlEnter()
{
    if (MLO_ENTER_MODE_BRAINSTORM)
    {
        return newBrainStormTask()
    }

    send ^{enter}
}

processF2()
{
    if (MLO_ENTER_MODE_BRAINSTORM)
    {
        MLO_ENTER_MODE_BRAINSTORM := 0
    }

    send {F2}
}

processCtrlShiftE()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        return setEnterBrainstormMode("!w")
    }

    send {blind}e
}

processCtrlShiftR()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        return setEnterBrainstormMode("!e")
    }

    send {blind}r
}
