addToAllVisibleTasks(key)
{
    taskNumber := SubStr(key, 2, StrLen(key))
    if (taskNumber > 4)
    {
        taskNumber := taskNumber - 4
    } 
    else
    {
        taskNumber := taskNumber + 2
    }
    send %taskNumber%
    sleep 150
    currentTask := getCurrentTask()
    lines := StrSplit(currentTask, "`n")
    if (lines.MaxIndex() = 2) ; because last line in empty string based on how split works 
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        lastSubtaskPosition := 0
        for key, val in lines
        {
            if (val && SubStr(val, 3, 1) != " ")
            {
                lastSubtaskPosition := key
            }
            
        }
        lastSubtaskPosition := lastSubtaskPosition - 1 ; because the parent is also considered in the split
        sendKeyCombinationIndependentActiveModifiers("{DOWN " . lastSubtaskPosition . "}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
}
