#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\lidWatcher.ahk



global LAPTOP_LID_STATE := "opened"
hookId := Start_LidWatcher()
SetTimer, TimerProcessLidCloseEnhancements, 20000 ; 20s - longer then the time required to finish the sleep enter process

LidStateChange(newstate) ; opened / closed
{
    LAPTOP_LID_STATE := newstate
}

TimerProcessLidCloseEnhancements()
{
    SetTimer, timerActivateSleepOnLidClose_step2, off
    SetTimer, timerActivateSleepOnLidClose_step3, off
    SetTimer, timerActivateSleepOnLidClose_step4, off
    SetTimer, timerActivateSleepOnLidClose_step5, off
    if (LAPTOP_LID_STATE = "closed")
    {
        writeNowLogFile("TimerProcessLidCloseEnhancements")
        SetTimer, timerActivateSleepOnLidClose_step2, 5000 ; 5s - because the computer might not enter sleep instantly when the lid is closed 
    }
}

timerActivateSleepOnLidClose_step2()
{
    SetTimer, timerActivateSleepOnLidClose_step2, off
    writeNowLogFile("timerActivateSleepOnLidClose_step2")
    if (LAPTOP_LID_STATE != "closed")
        return
    
    send {escape 2} ; cancel any other focus
    SetTimer, timerActivateSleepOnLidClose_step3, off
    SetTimer, timerActivateSleepOnLidClose_step3, 1000
}
    
timerActivateSleepOnLidClose_step3()
{
    SetTimer, timerActivateSleepOnLidClose_step3, off
    writeNowLogFile("timerActivateSleepOnLidClose_step3")
    if (LAPTOP_LID_STATE != "closed")
        return
    
    ; windows shortcut for power menu
    send #x
    SetTimer, timerActivateSleepOnLidClose_step4, 1000
}

timerActivateSleepOnLidClose_step4()
{
    SetTimer, timerActivateSleepOnLidClose_step4, off
    writeNowLogFile("timerActivateSleepOnLidClose_step4")
    if (LAPTOP_LID_STATE != "closed")
        return
    
    ; power menu shutdown & sleep
    send {up 2}{right}
    SetTimer, timerActivateSleepOnLidClose_step5, 1000
}

timerActivateSleepOnLidClose_step5()
{
    SetTimer, timerActivateSleepOnLidClose_step5, off
    writeNowLogFile("timerActivateSleepOnLidClose_step5")
    if (LAPTOP_LID_STATE != "closed")
        return
    
    ; enter sleep
    if (A_ComputerName = ACTIVE_COMPUTER_IRIS_T15)
    {
        send {down 2} ; hibernate
    }
    else
    {
        send {down} ; sleep
    }
    sleep 100
    send {enter}
}