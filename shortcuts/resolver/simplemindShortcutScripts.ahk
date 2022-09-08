global SIMPLEMIND_WINDOW_NAME := "SimpleMind Pro"
global SIMPLEMIND_CLASSNN_NOTES := "TRichEditEx"
global SIMPLEMIND_CLASSNN_MIND_MAP_EDITOR := "TStorageMindMapEditor"
global SIMPLEMIND_COUNTER_BRAINSTORM_IDEAS := 0
global SIMPLEMIND_COUNTER_BRAINSTORM_MAX_IDEAS := 9


setSimplemindFocusTopic(key, focusCount := 9)
{
    SetTimer TimerStickyFailBack, off

    IfNotInString, activeWindowNow, %SIMPLEMIND_CLASSNN_MIND_MAP_EDITOR%
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}")
    }
    sendKeyCombinationIndependentActiveModifiers("^f") ; search for matching tasks
    sleep 100
    taskNumber := SubStr(key, 2, StrLen(key)) - 4
    if (taskNumber < 1)
    {
        taskNumber := SubStr(key, 2, StrLen(key)) + 2
    }
    sendKeyCombinationIndependentActiveModifiers("@" . taskNumber)
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("^!l") ; autofocus selected branch
    loop %focusCount%
    {
        sendKeyCombinationIndependentActiveModifiers("^y")
        sleep 100
    }
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
}

navigateAndCenter(key)
{
    send {%key%}
    sendKeyCombinationIndependentActiveModifiers("^y")
}

centerBrainstorm()
{
    SetTimer TimerStickyFailBack, off

    ;setSimplemindOverlay(1)
    sendKeyCombinationIndependentActiveModifiers("^!u") ; unfocus selected topic
    sendKeyCombinationIndependentActiveModifiers("^q") ; brainstorm
    sleep 100
    ControlGetFocus, activeWindowNow, A
    activeWindowNow := activeWindowNow . "_"  ; transform into a string so that comparison can work
    IfInString, activeWindowNow, %SIMPLEMIND_CLASSNN_MIND_MAP_EDITOR%
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}{tab}")
    }

    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
}

simplemindClearIdeas()
{
    SetTimer TimerStickyFailBack, off
    send {enter}

    ControlGetFocus, activeWindowNow, A
    activeWindowNow := activeWindowNow . "_"  ; transform into a string so that comparison can work
    IfInString, activeWindowNow, %SIMPLEMIND_CLASSNN_NOTES%
    {
        SIMPLEMIND_COUNTER_BRAINSTORM_IDEAS := SIMPLEMIND_COUNTER_BRAINSTORM_IDEAS + 1
        if (SIMPLEMIND_COUNTER_BRAINSTORM_IDEAS > SIMPLEMIND_COUNTER_BRAINSTORM_MAX_IDEAS)
        {
            SIMPLEMIND_COUNTER_BRAINSTORM_IDEAS := 1
            send {escape}
            sleep 100
            setSimplemindFocusTopic("F5", 0) ; focus main branch
            send ^c^a{delete}{enter}^v^q ; clear all tasks except root node
            ;setSimplemindOverlay(1)
        }
    }

    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
}

setSimplemindOverlay(enabled)
{
    if (enabled)
    {
        topWidth := 450
        topHeight := 30
        topX := A_ScreenWidth - topWidth
        topY := 0

        Gui, top:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, top:show, w%topWidth% h%topHeight% x%topX% y%topY%
        WinActivate %SIMPLEMIND_WINDOW_NAME%, , 2
    }
    else
    {
        Gui, top:destroy
    }
}
