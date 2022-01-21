global SIMPLEMIND_WINDOW_NAME := "SimpleMind"
global SIMPLEMIND_CLASSNN_NOTES := "TRichEditEx"


setSimplemindFocusTopic(topicName)
{
    SetTimer TimerStickyFailBack, off

    ControlGetFocus, activeWindowNow, A
    activeWindowNow := activeWindowNow . "_"  ; transform into a string so that comparison can work
    IfInString, activeWindowNow, %SIMPLEMIND_CLASSNN_NOTES%
    {
        sendKeyCombinationIndependentActiveModifiers("+{tab 2}") ; focus mindmap area
        sleep 100
    }
    sendKeyCombinationIndependentActiveModifiers("^f") ; search for matching tasks
    sleep 100
    sendKeyCombinationIndependentActiveModifiers(topicName)
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sleep 100
    send {blind}y ; center topic
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("{tab 2}")
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
}
