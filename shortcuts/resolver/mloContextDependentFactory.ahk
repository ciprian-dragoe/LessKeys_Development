global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3
global MLO_ENTER_MODE_SET_AS_OPEN_NOTES := 4
global MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW := 5
global MLO_ENTER_MODE_SET_AS_DIALOG := 8
global MLO_ENTER_MODE_SET_AS_ADD_SPACES := 10
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ := 11
global MLO_ENTER_MODE_SET_AS_PARTE_INCARCA := 12
global MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA := 13
global MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO := 14
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE := 15
global MLO_ENTER_MODE_SET_AS_JURNAL_DUAL := 16
global MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER := 30
global MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER := 31
global MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER := 40

global MLO_ENTER_MODE_SET_JURNAL := 25
global MLO_ENTER_MODE_SET_DEZVOLT_JURNAL := 26
global INTREBARI_JURNAL := {}
INTREBARI_JURNAL.INTENTIE := ["LIMITA MENTIN: "]
INTREBARI_JURNAL.CERǀAJUTOR := ["POT SA FAC CU CEEA CE AM:{SPACE}", "DISTRAGE SA FAC ASTA:{SPACE}"]
INTREBARI_JURNAL.DAUǀDRUMUL := ["DIRECTIE CRESC:{SPACE}"]
INTREBARI_JURNAL.APRECIEZ := ["APRECIEZ IN ACEST MOMENT:{SPACE}", "MA INCARCA SA FIU PREZENT"]
INTREBARI_JURNAL.FRICA := ["SEMNIFICATIE SUFERINTA:{SPACE}", "SPRIJIN CU CEEA CE AM:{SPACE}"]

   

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
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES)
    {
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{end}{space}{space}{enter}")
        }
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<GO_TO_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        if (MLO_ENTER_MODE != 0)
        {
            sleep 1200
        }
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sleep 100
        nextTask := getCurrentTask()
        if (nextTask = currentTask)
        {
            showtooltip("match")
            sleep 1000
        }
        mloNewContextDependentSubTask(nextTask)
    }
    else if (inStr(currentTask, "<CER_AJUTOR_", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<TOPIC_DELIMITER>", true))
    {
        mloAddJournalDelimiterSubTask()
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_OPEN_NOTES
    }
    else if (inStr(currentTask, "<NEW_TASK_DO_AFTER_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        BUFFER := extractDestinationAfter(currentTask)
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
        
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        INTREBARI_JURNAL_INDEX := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_FIRST_LEVEL)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>{SPACE}CONFUZA^+{LEFT}")
        INTREBARI_JURNAL_INDEX := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_INCARCA
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        newPart(currentTask)
    }
    else if (inStr(currentTask, "<ESCAPE>", true))
    {
        resetMloEnterMode()
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        newBucla(MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    }
    else if (inStr(currentTask, "<NEW_TASK>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<JURNAL_", true))
    {
        positionStart := InStr(currentTask, "<") + 1
        positionEnd := InStr(currentTask, ">")
        result := SubStr(currentTask, positionStart, positionEnd - positionStart)
        splits := StrSplit(result, "_")
        if (splits.Count() = 4)
        {
            MLO_JOURNAL := extractDestinationAfter(currentTask, 2)
            PREVIOUS_TASK := extractDestinationAfter(currentTask, 1)
            TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)    
        }
        else
        {
            MLO_JOURNAL := extractDestinationAfter(currentTask, 1)
            PREVIOUS_TASK := extractDestinationAfter(currentTask)
            TASK_GO_AFTER_TO := "{DOWN}"
        }
        
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
    else if (inStr(currentTask, "<JURNAL_DUAL>", true))
    {
        newBucla(MLO_ENTER_MODE_SET_AS_JURNAL_DUAL)
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
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        INTREBARI_JURNAL_INDEX := SubStr(currentTask, 1, 1) + 1
        PREVIOUS_TASK := INTREBARI_JURNAL_INDEX
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS)
        sendKeyCombinationIndependentActiveModifiers("{HOME}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sleep 100
        Loop %INTREBARI_JURNAL_INDEX%
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
        }
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 50
        sendKeyCombinationIndependentActiveModifiers(INTREBARI_JURNAL_INDEX . "_BUCLA>" . "{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE
    }
    else if (inStr(currentTask, "<S>", true))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        newPart(currentTask)
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        newBucla(MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
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
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL)
    {
        mloNewJournalTask()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        mloNewJournalTask()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        mloNewJournalTask("{END}{UP}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_INCARCA)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{DOWN}{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>{SPACE}RESURSA^+{LEFT}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA
        INTREBARI_JURNAL_INDEX := 1
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA)
    {
        createConsuma()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
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
            resetMloEnterMode()
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

mloNewJournalTask(newTemplateKeys = "")
{
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
    INTREBARI_JURNAL_INDEX := INTREBARI_JURNAL_INDEX + 1
    sendKeyCombinationIndependentActiveModifiers("{F5}")
    sleep 100
    if (newTemplateKeys)
    {
        sendKeyCombinationIndependentActiveModifiers(newTemplateKeys)
    }
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
    sleep 50
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sendKeyCombinationIndependentActiveModifiers("{F2}")
    sleep 50
    sendKeyCombinationIndependentActiveModifiers(INTREBARI_JURNAL_INDEX . "_BUCLA>{SPACE}")
}

createConsuma()
{
    sendKeyCombinationIndependentActiveModifiers("{ENTER}")
    INTREBARI_JURNAL_INDEX := Mod(INTREBARI_JURNAL_INDEX + 1, 2)
    sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX)
    sendKeyCombinationIndependentActiveModifiers("{F5}")
    sleep 100
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
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
            sendKeyCombinationIndependentActiveModifiers("{ESCAPE}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
            resetMloEnterMode(0)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToNextQuestion, off
            sendKeyCombinationIndependentActiveModifiers("{ESCAPE}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
            sleep 300
            resetMloEnterMode(0)
            currentTask := getCurrentTask()
            mloNewContextDependentSubTask(currentTask)
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            setTimer TimerDoubleKeyPressInterval, off
            sendKeyCombinationIndependentActiveModifiers("{escape}")
            INTREBARI_JURNAL_INDEX := Mod(INTREBARI_JURNAL_INDEX + 1, 2)
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX . "{DOWN}")
            DOUBLE_PRESS_KEY_ACTIVE := 0
            resetMloEnterMode()
            return
        }
        setTimer TimerDoubleKeyPressInterval, 600
        DOUBLE_PRESS_KEY_ACTIVE := 1
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}^+.")
        sleep 100
        INTREBARI_JURNAL_INDEX := Mod(INTREBARI_JURNAL_INDEX + 1, 2)
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX)
        
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        sendKeyCombinationIndependentActiveModifiers("^a")
        currentTask := getCurrentTask()
        if (SubStr(currentTask,0,1) = " ")
        {
            sendKeyCombinationIndependentActiveModifiers("{BackSpace}{BackSpace}{BackSpace}9 ....................................................................................................................................................{enter}")
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
            sleep 100
            sendKeyCombinationIndependentActiveModifiers("{F2}{down}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers("^a")
            sleep 250
            sendKeyCombinationIndependentActiveModifiers("9 ....................................................................................................................................................{enter}")
        }
        sleep 500
        sendKeyCombinationIndependentActiveModifiers("1")
        sleep 1000
        mloNewContextDependentSubTask("1_BUCLA>")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        sendKeyCombinationIndependentActiveModifiers("^a")
        currentTask := getCurrentTask()
        if (SubStr(currentTask,0,1) = " ")
        {
            sendKeyCombinationIndependentActiveModifiers("{BackSpace}{BackSpace}{BackSpace}l{enter}")
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
            sleep 100
            sendKeyCombinationIndependentActiveModifiers("{F2}{down}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers("^a")
            sleep 250
            sendKeyCombinationIndependentActiveModifiers("{BackSpace}{BackSpace}{BackSpace}l{enter}")
        }
        if (PREVIOUS_TASK != INTREBARI_JURNAL_INDEX)
        {
            sleep 500
            sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
            sleep 1000
            mloNewContextDependentSubTask("" . PREVIOUS_TASK . "_BUCLA>")
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{HOME}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        number := SubStr(TASK_GO_AFTER_TO, 0, 1)
        modifiers := SubStr(TASK_GO_AFTER_TO, 1, StrLen(combination)-1)
        resetMloEnterMode()
        changeViewMloFactory(number, modifiers)
        if (BUFFER)
        {
            sleep 800
            sendKeyCombinationIndependentActiveModifiers(BUFFER)
            sleep 200
            currentTask := getCurrentTask()
            mloNewContextDependentSubTask(currentTask)
        }        
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_INCARCA)
    {
        resetMloEnterMode()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA)
    {
        createConsuma()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ADD_SPACES)
    {
        send {blind}{escape}
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        resetMloEnterMode()   
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToMloTask, off
            resetMloEnterMode()
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
            resetMloEnterMode()
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
        resetMloEnterMode()
    }
}

resetMloEnterMode(alsoPressEscape = 1)
{
    MLO_ENTER_MODE := 0
    TASK_GO_AFTER_TO := ""
    INTREBARI_JURNAL_INDEX := 1
    PREVIOUS_TASK := ""
    if (alsoPressEscape)
    {
        send {blind}{escape}
    }
}

newBrainStormTask(originalAction)
{
    sendKeyCombinationIndependentActiveModifiers("{enter}{F5}{LEFT}")
    sendKeyCombinationIndependentActiveModifiers(originalAction)
}

extractDestinationAfter(input, indexPositionFromRigth = 0)
{
    positionStart := InStr(input, "<") + 1
    positionEnd := InStr(input, ">")
    result := SubStr(input, positionStart, positionEnd - positionStart)
    splits := StrSplit(result, "_")
    return splits[splits.Count() - indexPositionFromRigth]
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
        setTimer TimerGoToNextQuestion, 800
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
    currentTask := getCurrentTask(300) 
    if (!inStr(currentTask, "<" . MLO_JOURNAL . ">", true))
    {
        if (TASK_GO_AFTER_TO = "{DOWN}")
        {
            mloNewContextDependentSubTask(currentTask)
        }
        else
        {
            sleep 1000
            sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
            sleep 150
            currentTask := getCurrentTask()
            resetMloEnterMode(0)
            mloNewContextDependentSubTask(currentTask)
        }
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

newBucla(enterMode)
{
    INTREBARI_JURNAL_INDEX := 1
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sendKeyCombinationIndependentActiveModifiers("{F2}")
    sleep 50
    sendKeyCombinationIndependentActiveModifiers(INTREBARI_JURNAL_INDEX . "_BUCLA>" . "{SPACE}")
    MLO_ENTER_MODE := enterMode
}

newPart(currentTask)
{
    TASK_GO_AFTER_TO := SubStr(currentTask, 1, 1)
    INTREBARI_JURNAL_INDEX := SubStr(currentTask, 2, 1)
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
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