#include <Arduino.h>
#include <avr_madness.h>


int main(void){
	init(); // Initializes timers, etc...
	setup();
	while(1)
		loop();
	return 0;
}

void setup(){
	SET_DDR(D,5);
}

void loop(){
	TOG_PORT(D,5);
	delay(1000);
}
