global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH := 1
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3
global MLO_ENTER_MODE_SET_OPEN_NOTES := 4
global MLO_ENTER_MODE_SET_AS_ADD_SPACES := 10
global MLO_ENTER_MODE_SET_AS_THANK_YOU := 22

global MLO_ENTER_MODE_SET_JURNAL := 25
global MLO_ENTER_MODE_SET_DEZVOLT_JURNAL := 26
global INTREBARI_JURNAL := {}
INTREBARI_JURNAL.DISTRAGE := ["DAU DRUMUL:{SPACE}", "CRESC{SPACE}{SPACE}{SPACE}SA:{SPACE}"]
INTREBARI_JURNAL.VULNERABIL := ["MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}", "MI-E FRICA:{SPACE}", "CER AJUTOR:{SPACE}"]
INTREBARI_JURNAL.LIMITA := ["NEVOIE COMUNIC:{SPACE}", "MA INCARCA SA FIU PREZENT SITUATIE:{SPACE}"]
global INTREBARI_JURNAL_INDEX := 1
   
global MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER := 30
global MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER := 31
global TASK_GO_AFTER_TO := ""
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
    else if (inStr(currentTask, "<TOPIC_DELIMITER>", true))
    {
        mloAddJournalDelimiterSubTask()
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_OPEN_NOTES
    }
    else if (inStr(currentTask, "<NEW_TASK>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<JURNAL_", true))
    {
        PREVIOUS_TASK := extractDestinationAfter(currentTask, 1)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("<" . PREVIOUS_TASK . ">{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_JURNAL
    }
    else if (inStr(currentTask, "<NEW_TASK_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<COPY_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
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

mloContextDependentEnter()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("<" . PREVIOUS_TASK . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_OPEN_NOTES)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        openNotesAssociatedWithTask()
        MLO_ENTER_MODE := 0
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_DEZVOLT_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        writeNextQuestion()
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

mloNewContextDependentEscape()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        send {blind}{enter}{escape}
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_JURNAL || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_DEZVOLT_JURNAL)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToNextQuestion, off
            resetEscapeMode()
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerGoToNextQuestion, off
            setTimer TimerGoToNextQuestion, 600
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_DEZVOLT_JURNAL
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        send {blind}{escape}
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES)
    {
        send {blind}{escape}
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
    TASK_GO_AFTER_TO := ""
    INTREBARI_JURNAL_INDEX := 1
    PREVIOUS_TASK := ""
    send {blind}{escape}
}

extractDestinationAfter(input, indexPositionFromRigth = 0)
{
    positionStart := InStr(input, "<") + 1
    positionEnd := InStr(input, ">")
    result := SubStr(input, positionStart, positionEnd - positionStart)
    splits := StrSplit(result, "_")
    return splits[splits.Count() - indexPositionFromRigth]
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
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        nextTaskToGoAfter := getCurrentTask()
        mloNewContextDependentSubTask(nextTaskToGoAfter)
    }
}

writeNextQuestion()
{
    questions := INTREBARI_JURNAL[PREVIOUS_TASK]
    if (!questions)
    {
        showtooltip("INVALID JOURNAL TOPIC")
        return
    }
    if (INTREBARI_JURNAL_INDEX > questions.length())
    {
        INTREBARI_JURNAL_INDEX := 1
        setTimer TimerGoToNextQuestion, off
        setTimer TimerGoToNextQuestion, 600
        sendKeyCombinationIndependentActiveModifiers("{enter}")    
        return
    }
    sendKeyCombinationIndependentActiveModifiers(questions[INTREBARI_JURNAL_INDEX])
    INTREBARI_JURNAL_INDEX += 1
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
    }
    else
    {
        PREVIOUS_TASK := Clipboard
    }
    sendKeyCombinationIndependentActiveModifiers("{enter}{f5}")
}

TimerCopyMloTaskPhase3()
{
    setTimer TimerCopyMloTaskPhase3, off
    sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
    sleep 250
    goAfter := getCurrentTask(600)
    mloNewContextDependentSubTask(goAfter)
}

TimerGoToNextQuestion()
{
    setTimer TimerGoToNextQuestion, off
    sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO . "{down}{F5}")
    currentTask := getCurrentTask()
    if (inStr(currentTask, "<JURNAL_", true))
    {
        resetEscapeMode()
        return
    }
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    writeNextQuestion()
}

getCurrentTask(waitTimeAfterCopy = 150)
{
    ; copy current task so that it can be parsed without loosing clipboard
    SetTimer TimerStickyFailBack, off
    temp := Clipboard
    sendKeyCombinationIndependentActiveModifiers("^c")
    sleep %waitTimeAfterCopy% ; wait for the os to register the command, smaller time causes mlo process errors
    currentTask := Clipboard
    Clipboard := temp
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
    return currentTask
}
