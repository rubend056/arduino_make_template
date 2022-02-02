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
	SET_DDR(B,0);
}

void loop(){
	
	TOG_PORT(B,0);
	
	// if(analogRead(2))SET_PORT(B,0);
	// else CLR_PORT(B,0);
	
	delay(1000);
}
