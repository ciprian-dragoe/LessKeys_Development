global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH := 1
global MLO_ENTER_MODE_SET_AS_JORNAL_NEW_TOPIC := 2
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3



mloAddJournalDelimiterSubTask()
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    sendKeyCombinationIndependentActiveModifiers("========={space}{space}")
    newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH
}

mloContextDependentKeyFactory(originalAction)
{
     ; copy current task so that it can be parsed without loosing clipboard
    temp := Clipboard
    sendKeyCombinationIndependentActiveModifiers("^c")
    SetTimer TimerStickyFailBack, off
    sleep 150 ; wait for the os to register the command, smaller time causes mlo process errors
    currentTask := Clipboard
    Clipboard := temp
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
    
    if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    {
        mloNewContextDependentSubTask(currentTask)
    }
    else if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    {
        mloNewContextDependentTask(currentTask)
    } 
    else if (originalAction = "enter")
    {
        mloNewContextDependentEnter(currentTask)
    }
}

mloNewContextDependentEnter(currentTask)
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JORNAL_NEW_TOPIC)
    {
        mloAddJournalDelimiterSubTask()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else
    {
        send {blind}{enter}
    }
}

mloNewContextDependentSubTask(currentTask)
{
    if (inStr(currentTask, " BUCLA", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JORNAL_NEW_TOPIC
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    } 
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JORNAL_NEW_TOPIC)
    {
        mloAddJournalDelimiterSubTask()
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

mloNewContextDependentTask(currentTask)
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
}

newBrainStormTask(originalAction)
{
    sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
    sendKeyCombinationIndependentActiveModifiers(originalAction)
}
