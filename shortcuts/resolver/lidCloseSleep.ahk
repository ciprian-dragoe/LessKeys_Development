#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\lidWatcher.ahk



global LAPTOP_LID_STATE := "opened"
global HAS_LAPTOP_STARTED_ENTERING_SLEEP := 0

hookId := Start_LidWatcher()
LidStateChange(newstate) ; opened / closed
{
    LAPTOP_LID_STATE := newstate
}

proceLidCloseEnhancements()
{
    if (LAPTOP_LID_STATE = "closed")
    {
        if (!HAS_LAPTOP_STARTED_ENTERING_SLEEP)
        {
            SetTimer, timerActivateSleepOnLidClose_step1, off
            SetTimer, timerActivateSleepOnLidClose_step2, off
            SetTimer, timerActivateSleepOnLidClose_step3, off
            SetTimer, timerActivateSleepOnLidClose_step4, off
            SetTimer, timerActivateSleepOnLidClose_step5, off
            SetTimer, timerActivateSleepOnLidClose_step1, 5000
            HAS_LAPTOP_STARTED_ENTERING_SLEEP := 1
        }
    }
    else
    {
        HAS_LAPTOP_STARTED_ENTERING_SLEEP := 0
    }
}

timerActivateSleepOnLidClose_step1()
{
    SetTimer, timerActivateSleepOnLidClose_step1, off
    if (LAPTOP_LID_STATE != "closed")
        return
    send #d ; show desktop
    SetTimer, timerActivateSleepOnLidClose_step2, off
    SetTimer, timerActivateSleepOnLidClose_step2, 1000
}

timerActivateSleepOnLidClose_step2()
{
    SetTimer, timerActivateSleepOnLidClose_step2, off
    if (LAPTOP_LID_STATE != "closed")
        return
    
    send {escape} ; cancel any other focus
    SetTimer, timerActivateSleepOnLidClose_step3, off
    SetTimer, timerActivateSleepOnLidClose_step3, 1000
}
    
timerActivateSleepOnLidClose_step3()
{
    SetTimer, timerActivateSleepOnLidClose_step3, off
    if (LAPTOP_LID_STATE != "closed")
        return
    
    ; windows shortcut for power menu
    send #x
    SetTimer, timerActivateSleepOnLidClose_step4, 1000
}

timerActivateSleepOnLidClose_step4()
{
    SetTimer, timerActivateSleepOnLidClose_step4, off
    if (LAPTOP_LID_STATE != "closed")
        return
    
    ; power menu shutdown & sleep
    sendInput u
    SetTimer, timerActivateSleepOnLidClose_step5, 1000
}

timerActivateSleepOnLidClose_step5()
{
    SetTimer, timerActivateSleepOnLidClose_step5, off
    if (LAPTOP_LID_STATE != "closed")
        return
    
    ; enter sleep
    send {raw}s
}