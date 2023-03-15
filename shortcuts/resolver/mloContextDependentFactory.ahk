#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEscape.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEnter.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewTask.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewSubTask.ahk

global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 3
global MLO_ENTER_MODE_SET_AS_OPEN_NOTES := 4
global MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW := 5
global MLO_ENTER_MODE_SET_AS_DIALOG := 8
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

continueJournalTask(selectDifferentTemplateKeys = "")
{
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
    INTREBARI_JURNAL_INDEX := INTREBARI_JURNAL_INDEX + 1
    sendKeyCombinationIndependentActiveModifiers("{F5}")
    sleep 100
    if (selectDifferentTemplateKeys)
    {
        sendKeyCombinationIndependentActiveModifiers(selectDifferentTemplateKeys)
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

startJournalTask(enterMode)
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


getFocusArea(input)
{
    positionSpace := InStr(input, " ")
    if (positionSpace = 0) {
        return 0
    }
    
    focusArea := SubStr(input, 1, positionSpace)
    allowedFocusAreas := ["11", "111", "12", "121", "13", "131", "22", "221", "23", "231", "24", "241", "33", "331", "34", "341", "35", "351", "44", "441", "45", "451", "46", "461", "55", "551", "56", "561", "57", "571", "66", "661", "67", "671", "77"]
    for key, allowedArea in allowedFocusAreas
    {
        if (focusArea = allowedArea) {
            return allowedArea
        }
    } 
}