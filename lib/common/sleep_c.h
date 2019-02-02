#ifndef SLEEP_C
#define SLEEP_C

#include "b_opp.h"
#include <avr/sleep.h>

void _sleep(){
	sleep_enable();

	#ifdef sleep_bod_disable();
		sleep_bod_disable();
	#endif

	sleep_cpu();
}

#endif