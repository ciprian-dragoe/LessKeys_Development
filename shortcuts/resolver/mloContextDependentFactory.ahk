global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH := 1
global MLO_ENTER_MODE_SET_AS_JOURNAL_NEW_TOPIC := 2
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3
global MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_DAY_REVIEW := 4
global MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD := 5
global MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD := 6
global MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_LET_GO := 11
global MLO_ENTER_MODE_SET_AS_LET_GO := 7
global MLO_ENTER_MODE_SET_AS_DO := 8
global MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_APPRECIATE := 20
global MLO_ENTER_MODE_SET_AS_APPRECIATE := 21
global MLO_ENTER_MODE_SET_AS_THANK_YOU := 22
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_AUTO_ADVANCE := 9
global MLO_ENTER_MODE_SET_AS_ADD_SPACES := 10
global MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER := 30
global NEW_TASK_GO_AFTER_TO := ""


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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES && A_CaretX)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_DAY_REVIEW)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("EVENIMENT<REVIEW_GOOD>:{SPACE}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("DIFERIT:{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DAY_REVIEW_GOOD)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}1{DOWN}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("APRECIEZ:{space}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_LET_GO)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("DAU{SPACE}DRUMUL{SPACE}INAINTE{SPACE}SOMN<LET_GO>:{SPACE}")    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_LET_GO)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}3{down}")
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_APPRECIATE)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("APRECIEZ{SPACE}INTERACTIUNE{SPACE}AZI<APPRECIATE>:{SPACE}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_APPRECIATE)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("POT{SPACE}SA{SPACE}MULTUMESC{SPACE}PRIN:{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_THANK_YOU
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_THANK_YOU)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("NEVOIE{SPACE}INGRIJIT:{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_APPRECIATE
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER)
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
    else if (inStr(currentTask, "<NEW_TASK_FOR_LET_GO>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_LET_GO
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("DAU{SPACE}DRUMUL{SPACE}INAINTE{SPACE}SOMN<LET_GO>:{SPACE}")
    }
    else if (inStr(currentTask, "<LET_GO>", true))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("DAU{SPACE}DRUMUL:{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DO
    }
    else if (inStr(currentTask, "<NEW_TASK_FOR_DAY_REVIEW>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_DAY_REVIEW
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("EVENIMENT<REVIEW_GOOD>:{SPACE}")
    }
    else if (inStr(currentTask, "<REVIEW_GOOD>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("APRECIEZ:{SPACE}")
    }
    else if (inStr(currentTask, "<NEW_TASK_FOR_APPRECIATE>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_APPRECIATE
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("APRECIEZ{SPACE}INTERACTIUNE{SPACE}AZI<APPRECIATE>:{SPACE}")
    }
    else if (inStr(currentTask, "<APPRECIATE>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_APPRECIATE
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("NEVOIE{SPACE}INGRIJIT:{SPACE}")
    }
    else if (inStr(currentTask, "<NEW_TASK_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER
        NEW_TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
}

mloNewContextDependentTask()
{
    if (MLO_ENTER_MODE > 0)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else
    {
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
}

mloNewContextDependentEscape()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_AUTO_ADVANCE && !DOUBLE_PRESS_KEY_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        SetTimer TimerStickyFailBack, off
        sleep 150 ; wait for the os to register the command, smaller time causes mlo process errors
        sendKeyCombinationIndependentActiveModifiers("{escape}{home}")
        SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        DOUBLE_PRESS_KEY_ACTIVE := 1
        setTimer TimerDoubleKeyPressInterval, 2500
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        send {blind}{escape}
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES)
    {
        send {blind}{escape}
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_APPRECIATE)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}2{down}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("NEVOIE{SPACE}INGRIJIT:{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_APPRECIATE
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_LET_GO)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}3{down}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("DAU{SPACE}DRUMUL:{space}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DO
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_FOR_DAY_REVIEW)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}1{DOWN}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("APRECIEZ:{space}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DAY_REVIEW_BAD    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER && !DOUBLE_PRESS_KEY_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{escape}{f5}" . NEW_TASK_GO_AFTER_TO)
        nextTaskToGoAfter := getCurrentTask()
        if (inStr(nextTaskToGoAfter, "<NEW_TASK_GO_AFTER", true))
        {
            NEW_TASK_GO_AFTER_TO := extractDestinationAfter(nextTaskToGoAfter) 
        }
        else
        {
            NEW_TASK_GO_AFTER_TO := ""
            MLO_ENTER_MODE := 0
        }
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        DOUBLE_PRESS_KEY_ACTIVE := 1
        setTimer TimerDoubleKeyPressInterval, 2500
    }
    else
    {
        MLO_ENTER_MODE := 0
        NEW_TASK_GO_AFTER_TO := ""
        send {blind}{escape}
    }
}

extractDestinationAfter(input)
{
    needle := "<NEW_TASK_GO_AFTER"
    position := InStr(input, "<NEW_TASK_GO_AFTER_")
    result := SubStr(input, position + StrLen(needle) + 1, 1)
    return result 
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
