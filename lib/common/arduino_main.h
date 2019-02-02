#ifndef ARDUINO_MAIN
#define ARDUINO_MAIN

// DON'T TOUCH THIS ******************************* 
// this is the default main.cpp hidden in the arduino folder, 
// just for show, so you understand what the heck is happening

#include <avr/io.h>
#include <util/delay.h>

#include <Arduino.h>

// Declared weak in Arduino.h to allow user redefinitions.
int atexit(void (* /*func*/ )()) { return 0; }

// Weak empty variant initialization function.
// May be redefined by variant files.
void initVariant() __attribute__((weak));
void initVariant() { }

void setupUSB() __attribute__((weak));
void setupUSB() { }

int main(void)
{
	
	init();

	initVariant();

#if defined(USBCON)
	USBDevice.attach();
#endif
	
	setup();
    
	for (;;) {
		loop();
		if (serialEventRun) serialEventRun();
	}
        
	return 0;
}
// ********************************************************

#endif