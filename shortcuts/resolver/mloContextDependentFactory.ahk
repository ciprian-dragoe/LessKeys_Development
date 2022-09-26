global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH := 1
global MLO_ENTER_MODE_SET_AS_JOURNAL_NEW_TOPIC := 2
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3
global MLO_ENTER_MODE_SET_AS_DAY_REVIEW_CONTEXT := 4
global MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD := 5
global MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD := 6
global MLO_ENTER_MODE_SET_AS_LET_GO := 7
global MLO_ENTER_MODE_SET_AS_DO := 8
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_AUTO_ADVANCE := 9
global MLO_ENTER_MODE_SET_ADD_SPACES := 10



mloContextDependentKeyFactory(originalAction)
{
    if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    {
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
    else if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    {
        mloNewContextDependentTask()
    } 
    else if (originalAction = "enter")
    {
        mloContextDependentEnter()
    }
    else if (originalAction = "escape")
    {
        mloNewContextDependentEscape()
    }
}

getCurrentTask()
{
    ; copy current task so that it can be parsed without loosing clipboard
    temp := Clipboard
    sendKeyCombinationIndependentActiveModifiers("^c")
    SetTimer TimerStickyFailBack, off
    sleep 150 ; wait for the os to register the command, smaller time causes mlo process errors
    currentTask := Clipboard
    Clipboard := temp
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
    return currentTask
}

mloContextDependentEnter()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JOURNAL_NEW_TOPIC)
    {
        mloAddJournalDelimiterSubTask()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_ADD_SPACES && A_CaretX)
    {
        sendKeyCombinationIndependentActiveModifiers("{space}{space}{enter}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_AUTO_ADVANCE)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DAY_REVIEW_CONTEXT)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("EVENIMENT:{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("APRECIEZ:{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("DIFERIT:{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_CONTEXT
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_LET_GO)
    {
        sendKeyCombinationIndependentActiveModifiers("{F5}")
        sendKeyCombinationIndependentActiveModifiers("{END}")    
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("DAU{SPACE}DRUMUL:{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DO
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DO)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("REGASESC:{space}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_LET_GO
    }
    else
    {
        send {blind}{enter}
    }
}

mloNewContextDependentSubTask(currentTask)
{
    if (inStr(currentTask, "<JOURNAL_NEW_TOPIC>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JOURNAL_NEW_TOPIC
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<NEW_TASK_WITH_AUTO_ADVANCE>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_AUTO_ADVANCE
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<DAY_REVIEW_GOOD>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("EVENIMENT:{space}")
    }
    else if (inStr(currentTask, "<NEW_TASK>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<DO>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DO
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("DAU{SPACE}DRUMUL:{SPACE}")
    } 
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
}

mloNewContextDependentTask()
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
}

newBrainStormTask(originalAction)
{
    sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
    sendKeyCombinationIndependentActiveModifiers(originalAction)
}

mloAddJournalDelimiterSubTask()
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    sendKeyCombinationIndependentActiveModifiers("========={space}{space}")
    newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH
}

mloNewContextDependentEscape()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_AUTO_ADVANCE && !DOUBLE_PRESS_KEY_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        SetTimer TimerStickyFailBack, off
        sleep 150 ; wait for the os to register the command, smaller time causes mlo process errors
        sendKeyCombinationIndependentActiveModifiers("{escape}")
        SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        DOUBLE_PRESS_KEY_ACTIVE := 1
        setTimer TimerDoubleKeyPressInterval, 2500
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_ADD_SPACES)
    {
        send {blind}{escape}
    }
    else
    {
        MLO_ENTER_MODE := 0
        send {blind}{escape}
    }
}