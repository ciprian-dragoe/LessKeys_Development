﻿global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH := 1
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
global MLO_SKIP_NEXT_ENTER_MODE_ACTION := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER := 30
global MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER := 31
global NEW_TASK_GO_AFTER_TO := ""
global PREVIOUS_TASK := ""
global MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER := 40


mloContextDependentKeyFactory(originalAction)
{
    if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    {
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
    else if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    {
        currentTask := getCurrentTask()
        mloNewContextDependentTask(currentTask)
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
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        if (MLO_SKIP_NEXT_ENTER_MODE_ACTION)
        {
            MLO_SKIP_NEXT_ENTER_MODE_ACTION := 0
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        }
        else
        {
            newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES && A_CaretX)
    {
        sendKeyCombinationIndependentActiveModifiers("{end}{space}{space}{enter}{F5}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
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
        sendKeyCombinationIndependentActiveModifiers("{escape}{end}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sendKeyCombinationIndependentActiveModifiers("NU{SPACE}MA{SPACE}MAI{SPACE}REGASESC:{space}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DO
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DO)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
        sendKeyCombinationIndependentActiveModifiers("MA{SPACE}SIMT{SPACE}IMPACAT{SPACE}SA:{space}")
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerCopyMloTaskPhase1, off
            setTimer TimerCopyMloTaskPhase2, off
            setTimer TimerCopyMloTaskPhase3, off
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerDoubleKeyPressInterval, off
            resetEscapeMode()
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerCopyMloTaskClear, 10000
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 1000
            TimerCopyMloTaskPhase1()
        }
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
        mloAddJournalDelimiterSubTask()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES)
    {
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{end}{space}{space}{enter}")
        }
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
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
        sendKeyCombinationIndependentActiveModifiers("NU{SPACE}MA{SPACE}MAI{SPACE}REGASESC:{space}")    
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
    else if (inStr(currentTask, "<COPY_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER
        NEW_TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<ESCAPE_AS_ENTER>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
}

mloNewContextDependentTask(currentTask = "")
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES)
    {
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{end}{space}{space}{enter}")
        }
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (inStr(currentTask, "<NEW_EXPLORE_TOPIC>", true))
    {
        sendKeyCombinationIndependentActiveModifiers("^d")
        sendKeyCombinationIndependentActiveModifiers("{down}")
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sendKeyCombinationIndependentActiveModifiers("1{space}{space}{space}[*]{left 5}")
        MLO_SKIP_NEXT_ENTER_MODE_ACTION := 1
    }
    else if (MLO_ENTER_MODE > 0)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        send {blind}{enter}{escape}
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        resetEscapeMode()    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToMloTask, off
            resetEscapeMode()
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerGoToMloTask, off
            setTimer TimerGoToMloTask, 600
            sendKeyCombinationIndependentActiveModifiers("{enter}{f5}{escape}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerCopyMloTaskPhase1, off
            setTimer TimerCopyMloTaskPhase2, off
            setTimer TimerCopyMloTaskPhase3, off
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerDoubleKeyPressInterval, off
            resetEscapeMode()
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            Clipboard := "DO NOT COPY PREVIOUS TASK"
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 700
            setTimer TimerCopyMloTaskPhase2, off
            setTimer TimerCopyMloTaskPhase2, 200
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerCopyMloTaskClear, 10000
        }
    }
    else
    {
        resetEscapeMode()
    }
}

resetEscapeMode()
{
    MLO_ENTER_MODE := 0
    NEW_TASK_GO_AFTER_TO := ""
    PREVIOUS_TASK := ""
    MLO_SKIP_NEXT_ENTER_MODE_ACTION := 0
    send {blind}{escape}
}

extractDestinationAfter(input)
{
    needle := "<NEW_TASK_GO_AFTER"
    positionStart := InStr(input, "<") + 1
    positionEnd := InStr(input, ">")
    result := SubStr(input, positionStart, positionEnd - positionStart)
    splits := StrSplit(result, "_")
    return splits[splits.Count()]
}

newBrainStormTask(originalAction)
{
    sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
    sendKeyCombinationIndependentActiveModifiers(originalAction)
}

mloAddJournalDelimiterSubTask()
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    sendKeyCombinationIndependentActiveModifiers("======{space}{space}======{space}{space}{left 9}")
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH
}

TimerCopyMloTaskClear()
{
    setTimer TimerCopyMloTaskClear, off
    PREVIOUS_TASK := ""
}

TimerGoToMloTask()
{
    setTimer TimerGoToMloTask, off
    if (DOUBLE_PRESS_KEY_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers(NEW_TASK_GO_AFTER_TO)
        nextTaskToGoAfter := getCurrentTask()
        mloNewContextDependentSubTask(nextTaskToGoAfter)
    }
}

TimerCopyMloTaskPhase1()
{
    setTimer TimerCopyMloTaskPhase1, off
    setTimer TimerCopyMloTaskPhase2, 250
    sendKeyCombinationIndependentActiveModifiers("{right}{space}^a^c")
}

TimerCopyMloTaskPhase2()
{
    setTimer TimerCopyMloTaskPhase2, off
    setTimer TimerCopyMloTaskPhase3, 200
    if (Clipboard = "New Task " || Clipboard = " ")
    {
        send %PREVIOUS_TASK%
        setTimer TimerCopyMloTaskPhase3, 500 
    }
    else
    {
        PREVIOUS_TASK := Clipboard
        setTimer TimerCopyMloTaskPhase3, 200
    }
    sendKeyCombinationIndependentActiveModifiers("{enter}{f5}")
}

TimerCopyMloTaskPhase3()
{
    setTimer TimerCopyMloTaskPhase3, off
    sendKeyCombinationIndependentActiveModifiers(NEW_TASK_GO_AFTER_TO)
    sleep 250
    nextTaskToGoAfter := getCurrentTask()
    mloNewContextDependentSubTask(nextTaskToGoAfter)
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
