#ifndef AVR_MADNESS
#define AVR_MADNESS

// #include <stdlib.h>
// #include <stdbool.h>
// #include <string.h>
// #include <math.h>

#include <avr/pgmspace.h>
#include <avr/io.h>
#include <util/delay.h>

#ifndef _BV
#define _BV(x) (1<<x)
#endif

#include "b_opp.h"
#include "avr_pins.h"
// #include "eeprom_c.h"
//#include "interrupt_c.h"
#include "sleep_c.h"
#include "watchdog_c.h"
//#include "dynamic_array.h"

#endif
