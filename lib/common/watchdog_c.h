#ifndef WATCHDOG
#define WATCHDOG

#include <avr/wdt.h>
#include "b_opp.h"

// After interrupt occours, interrupt is cleared, new watchdog begins
#define WDT_INTERRUPT_ON SET(WDTCSR, WDIE)
#define WDT_INTERRUPT_OFF CLR(WDTCSR, WDIE)

#endif