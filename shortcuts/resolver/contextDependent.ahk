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
        return mloContextDependentKeyFactory(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
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
    if (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        return mloContextDependentKeyFactory("enter")    
    }
    
    if (inStr(lastActiveAppName, SIMPLEMIND_WINDOW_NAME, true))
    {
        return simplemindClearIdeas()
    }

    send {blind}{enter}
}

processAltShiftDirection(combination, index)
{
    if (IS_DAY_SORTING_VIEW_ACTIVE)
    {
        IS_SET_MLO_ORDER_ACTIVE := 1
    }
    key := subStr(combination, 3)
    send {blind}{%key%}
}

processCtrlF()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        MLO_ENTER_MODE := 0
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
    if (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        return mloContextDependentKeyFactory(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }

    send {blind}r
}

processCtrlW()
{
    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        MLO_ENTER_MODE := 0
        hideShowMLOnotes()
        return 
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
        return goToTask(key)
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
    send ^{enter}
}

processF2()
{
    send {F2}
}

processEscape()
{
    if (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        return mloContextDependentKeyFactory("escape")    
    }
    send {blind}{escape}
}

processCtrlShiftE()
{
    send {blind}e
}

processCtrlShiftR()
{
    send {blind}r
}
