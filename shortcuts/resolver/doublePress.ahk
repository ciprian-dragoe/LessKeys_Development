global DOUBLE_PRESS_KEY_ACTIVE := 0

TimerDoubleKeyPressInterval()
{
    setTimer TimerDoubleKeyPressInterval, OFF
    DOUBLE_PRESS_KEY_ACTIVE := 0
}