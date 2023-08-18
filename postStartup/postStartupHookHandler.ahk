global TimeoutCheckReminder := 600000 ; 600000 ms = 10 minutes 
SetTimer TimerCheckReminder, %TimeoutCheckReminder% ; 10 minutes
send {mbutton up}

processCustomAppNameRules()
{
    processMloEnhancements()
    processConceptsEnhancements()
}   