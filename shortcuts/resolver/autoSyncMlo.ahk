global SYNC_MLO := 0
global INTERNET_ACCESS := 1

timerCancelTooltip()
{
    tooltip
}

timerCheckReminder()
{
    timerSyncMloStep1_launchPing()
    SetTimer TimerCheckAfterSyncReminders, 8000    
}

timerCheckAfterSyncReminders()
{
    SetTimer TimerCheckAfterSyncReminders, OFF
    DetectHiddenWindows Off
    if (WinExist("MyLifeOrganized - Reminders"))
    {
        DetectHiddenWindows On
        tooltip, `n`n`n`n`n========= CHECK REMINDERS =========`n`n`n`n`n
        SetTimer TimerCancelTooltip, OFF
        SetTimer TimerCancelTooltip, 1000
    }
}

timerSyncMloStep1_launchPing()
{
    Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep2_readPing, 4000
}

timerSyncMloStep2_readPing()
{
    SYNC_MLO := 0
    SetTimer TimerSyncMloStep2_readPing, OFF

    fileread , StrTemp, %A_Temp%\ping.log
    StrTemp := trim(StrTemp)
    stringsplit , TempArr, StrTemp, =
    ifinstring, TempArr%TempArr0%, ms
    {
        IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
        {
            return
        }
        
        INTERNET_ACCESS := 1
        ControlSend, , %MLO_KEYBOARD_SHORTCUT_SYNC_MLO_CALENDAR%, ahk_class %MLO_CLASS_NAME%
        
        SetTimer TimerSyncMloStep3_syncCalendar, OFF
        SetTimer TimerSyncMloStep3_syncCalendar, 14000
    }
    else
    {
        INTERNET_ACCESS := 0
        ControlSend, , ^s, ahk_class %MLO_CLASS_NAME%
    }
}

timerSyncMloStep3_syncCalendar()
{
    SetTimer TimerSyncMloStep3_syncCalendar, OFF
    if (!inStr(lastActiveAppName, ".ml - MyLifeOrganized", true))
    {
        ControlSend, , %MLO_KEYBOARD_SHORTCUT_SYNC_MLO_TASKS%, ahk_class %MLO_CLASS_NAME%
        ;SetTimer TimerSyncMloStep4_clickOkNoInternet, OFF
        ;SetTimer TimerSyncMloStep4_clickOkNoInternet, 6000 ; todo: should delete if not working with other apps
    }
}

timerSyncMloStep4_clickOkNoInternet()
{
    SetTimer TimerSyncMloStep4_clickOkNoInternet, OFF
    isErrorPresentNoInternet := WinExist("ahk_class #32770")
    if (isErrorPresentNoInternet)
    {
        ;ControlSend, , {enter}, A
        ;showtooltip("de ce nu merge :(")
    }
}

resetTimerSyncMlo()
{
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep3_syncCalendar, OFF
}
