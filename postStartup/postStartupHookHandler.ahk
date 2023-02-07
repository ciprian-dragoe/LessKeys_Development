global TimeoutCheckReminder := 600000 ; 600000 ms = 10 minutes 
SetTimer TimerCheckReminder, %TimeoutCheckReminder% ; 10 minutes

processCustomAppNameRules()
{
    processMloEnhancements()
    processConceptsEnhancements()
    proceLidCloseEnhancements()
}