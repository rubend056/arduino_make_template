#include "avr_madness.h"


// //*************************** To use Arduino main
// #include "arduino_main.h"
// // Bsic blink sketch with LED connected to PIND bit 5, or pin 5 in the arduino
// void setup(){
// 	SET_DDR(D,5); // Will set DDRD, bit 5 as output
// }
// void loop(){
// 	delay(1000);
// 	SET_PORT(D,5);
// 	delay(1000);
// 	CLR_PORT(D,5);
// }



//*************************** To use your own main
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
void setup(){
	SET_DDR(D,5); // Will set DDRD, bit 5 as output
}
void loop(){
	delay(1000);
	SET_PORT(D,5);
	delay(1000);
	CLR_PORT(D,5);
}