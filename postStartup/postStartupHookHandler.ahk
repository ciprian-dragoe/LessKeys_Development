global TIMEOUT_CHECK_REMINDER := 1000 * 60 * 10 ; 10 minutes 
SetTimer TimerCheckReminder, %TIMEOUT_CHECK_REMINDER%
send {mbutton up}

DetectHiddenWindows, off

processCustomAppNameRules()
{
    processMloEnhancements()
    processConceptsEnhancements()
}