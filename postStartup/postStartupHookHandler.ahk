#include %A_ScriptDir%\..\environmentDependent\_development\postStartup\lidWatcher.ahk



global TimeoutCheckReminder := 600000 ; 600000 ms = 10 minutes 
SetTimer TimerCheckReminder, %TimeoutCheckReminder% ; 10 minutes

global LAPTOP_LID_STATE := "opened"
hookId := Start_LidWatcher()  ;Start waiting for the lid to be opened or closed
LidStateChange(newstate) ; opened / closed
{
    LAPTOP_LID_STATE := newstate
    if (newstate = "closed")
    {
        SetTimer, timerActivateSleepOnLidClose, 5000
    }
    else
    {
        SetTimer, timerActivateSleepOnLidClose, off
    }
}

timerActivateSleepOnLidClose()
{
    SetTimer, timerActivateSleepOnLidClose, off
    if (LAPTOP_LID_STATE != "closed")
        return
    send #d ; show desktop
    sleep 1000
    if (LAPTOP_LID_STATE != "closed")
        return
    send {escape} ; cancel any other focus
    sleep 1000
    if (LAPTOP_LID_STATE != "closed")
        return
    send #x ; windows shortcut for power menu
    if (LAPTOP_LID_STATE != "closed")
        return
    sleep 1000
    if (LAPTOP_LID_STATE != "closed")
        return
    send u ; power menu shutdown & sleep
    sleep 1000
    if (LAPTOP_LID_STATE != "closed")
        return
    send s ; sleep shortcut
}

processCustomAppNameRules()
{
    processMloEnhancements()
    processConceptsEnhancements()
}