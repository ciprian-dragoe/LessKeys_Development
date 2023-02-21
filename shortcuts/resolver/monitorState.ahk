GUID_MONITOR_POWER_ON:="02731015-4510-4526-99e6-e5a17ebd1aea"
GUID_CONSOLE_DISPLAY_STATE:="6fe69556-704a-47a0-8f24-c28d936fda47"
global MONITOR_STATUS:=1
global newGUID:=""

varSetCapacity(newGUID,16,0)
if a_OSVersion in WIN_8,WIN_8.1,WIN_10
    dllCall("Rpcrt4\UuidFromString","Str",GUID_CONSOLE_DISPLAY_STATE,"UInt",&newGUID)
else
    dllCall("Rpcrt4\UuidFromString","Str",GUID_MONITOR_POWER_ON,"UInt",&newGUID)
rhandle:=dllCall("RegisterPowerSettingNotification","UInt",a_scriptHwnd,"Str",strGet(&newGUID),"Int",0)
onMessage(0x218,"WM_MONITOR_STATE")

WM_MONITOR_STATE(wParam,lParam){
    static PBT_POWERSETTINGCHANGE:=0x8013
    if(wParam=PBT_POWERSETTINGCHANGE){
        if(subStr(strGet(lParam),1,strLen(strGet(lParam))-1)=strGet(&newGUID)){
            MONITOR_STATUS:=numGet(lParam+0,20,"UInt")?1:0
        }
    }
    return
}
