global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH := 1
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3
global MLO_ENTER_MODE_SET_AS_OPEN_NOTES := 4
global MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW := 5
global MLO_ENTER_MODE_SET_AS_PARTE := 6
global MLO_ENTER_MODE_SET_AS_PARTE_FINISH := 7
global MLO_ENTER_MODE_SET_AS_DIALOG := 8
global MLO_ENTER_MODE_SET_AS_ADD_SPACES := 10
global MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER := 30
global MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER := 31
global MLO_ENTER_MODE_SET_AS_ESCAPE := 40

global MLO_ENTER_MODE_SET_JURNAL := 25
global MLO_ENTER_MODE_SET_DEZVOLT_JURNAL := 26
global INTREBARI_JURNAL := {}
INTREBARI_JURNAL.SITUATIEǀRAMASǀPRINSǀGANDURI := ["SEMNIFICATIE GANDURI ACEA SITUATIE:{SPACE}", "ACCEPT NE E IN CONTROLUL MEU:{SPACE}", "DIRECTIE REGASESC IN ASTFEL DE MOMENTE:{SPACE}", "MA INCARCA SA FIU ALINIAT ASTFEL DE MOMENTE:"]
INTREBARI_JURNAL.DAUǀDRUMUL := ["NU MA MAI REGASESC:{SPACE}", "DIRECTIE IN CARE MA REGASESC:{SPACE}"]
INTREBARI_JURNAL.NEVOIEǀACUMULAT := ["INGRIJESC CU CEEA CE AM:{space}"]
INTREBARI_JURNAL.LIMITA := ["EFECT TERMEN LUNG CONTINUI IGNOR LIMITA:{SPACE}", "MA REGASESC SA ACTIONEZ:{SPACE}"]
   

global INTREBARI_JURNAL_INDEX := 1
global MLO_JOURNAL := ""
global TASK_GO_AFTER_TO := ""
global PREVIOUS_TASK := ""
global BUFFER := ""

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
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<TOPIC_DELIMITER>", true))
    {
        mloAddJournalDelimiterSubTask()
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_OPEN_NOTES
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        TASK_GO_AFTER_TO := 1
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("<DIALOG_0>{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE
    }
    else if (inStr(currentTask, "<NEW_TASK_DO_AFTER_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        BUFFER := extractDestinationAfter(currentTask)
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW
    }
    else if (inStr(currentTask, "<DIALOG_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
    }
    else if (inStr(currentTask, "<ESCAPE>", true))
    {
        resetEscapeMode()
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
        MLO_JOURNAL := extractDestinationAfter(currentTask, 2)
        PREVIOUS_TASK := extractDestinationAfter(currentTask, 1)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")    
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
        debug("*** mloNewContextDependentTask: " . currentTask)
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
    else if (inStr(currentTask, "<DIALOG_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
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
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_DEZVOLT_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        writeNextQuestion()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_OPEN_NOTES)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        openNotesAssociatedWithTask()
        MLO_ENTER_MODE := 0
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES && A_CaretX)
    {
        sendKeyCombinationIndependentActiveModifiers("{end}{space}{space}{enter}{F5}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)    
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("<DIALOG_1>{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_FINISH
        TASK_GO_AFTER_TO := 0
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_FINISH)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)    
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO . "{DOWN}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
        TASK_GO_AFTER_TO := 0
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW)
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
        MLO_ENTER_MODE := 0
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
;        if (DOUBLE_PRESS_KEY_ACTIVE)
;        {
;            DOUBLE_PRESS_KEY_ACTIVE := 0
;            setTimer TimerDoubleKeyPressInterval, off
;            setTimer TimerGoToNextDialoguePhase, off
;            resetEscapeMode()
;        }
;        else
;        {
;            DOUBLE_PRESS_KEY_ACTIVE := 1
;            setTimer TimerDoubleKeyPressInterval, off
;            setTimer TimerDoubleKeyPressInterval, 800
;            setTimer TimerGoToNextDialoguePhase, off
;            setTimer TimerGoToNextDialoguePhase, 200
;            sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
;        }
            sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
            sleep 100
            TASK_GO_AFTER_TO := Mod(TASK_GO_AFTER_TO + 1, 2)
            sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
            sendKeyCombinationIndependentActiveModifiers("{DOWN}")
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH)
    {
        send {blind}{escape}
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        number := SubStr(TASK_GO_AFTER_TO, 0, 1)
        modifiers := SubStr(TASK_GO_AFTER_TO, 1, StrLen(combination)-1)
        resetEscapeMode()
        changeViewMloFactory(number, modifiers)
        if (BUFFER)
        {
            sleep 200
            sendKeyCombinationIndependentActiveModifiers(BUFFER)
            sleep 200
            currentTask := getCurrentTask()
            mloNewContextDependentSubTask(currentTask)
        }        
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
            setTimer TimerCopyMloTaskPhase2, 250
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
    questions := INTREBARI_JURNAL[MLO_JOURNAL]
    if (!questions)
    {
        showtooltip("INVALID JOURNAL TOPIC", 1000)
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
    setTimer TimerCopyMloTaskPhase3, 250
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
    sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK . "{down}{F5}")
    currentTask := getCurrentTask(500)
    if (!inStr(currentTask, "<" . MLO_JOURNAL . ">", true))
    {
        resetEscapeMode()
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sleep 150
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
        return
    }
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    writeNextQuestion()
}

timerGoToNextDialoguePhase()
{
    SetTimer TimerGoToNextDialoguePhase, off
    TASK_GO_AFTER_TO := Mod(TASK_GO_AFTER_TO + 1, 2)
    sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
}

getCurrentTask(waitTimeAfterCopy = 200)
{
    ; copy current task so that it can be parsed without loosing clipboard
    SetTimer TimerStickyFailBack, off
    temp := Clipboard
    sendKeyCombinationIndependentActiveModifiers("^c")
    sleep %waitTimeAfterCopy% ; wait for the os to register the command, smaller time causes mlo process errors
    currentTask := Clipboard
    debug("=== getCurrentTask: " . currentTask)
    Clipboard := temp
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
    return currentTask
}
