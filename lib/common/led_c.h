#ifndef LED_C
#define LED_C

#include <avr_pins.h>

#ifndef LED
	#if defined(__AVR_ATmega2560__)
	#pragma message ( "Using pin 41 for led" )
	#define LED 41
	#else
	#pragma message ( "Using pin 5 for led" )
	#define LED 5
	#endif
#endif

inline void led_begin(){
	pinMode(LED,OUTPUT);
	// SET_DDR(D, LED);
}
inline void led_on(){SET_PORT(D, LED);}
inline void led_off(){CLR_PORT(D, LED);}
void blink(uint16_t d, uint8_t led=LED){
	digitalWrite(LED,1);
	// SET_PORT(D, led);
	delay(2);
	// CLR_PORT(D, led);
	digitalWrite(LED,0);
}
void blink(uint16_t d, uint16_t e, uint8_t c, uint8_t led=LED){
	while(c--){
		blink(d,led);
		delay(e);
	}
}

#define ERROR_RADIO_FAILED 3
#define ERROR_ETHERNET_FAILED 4

#define LED_BURST_NUM 2
void blink_error(uint8_t mode){
	// while(1){
		// uint8_t n = mode;
		// while (n > LED_BURST_NUM){
		// 	blink(2,150,LED_BURST_NUM);n-=LED_BURST_NUM;
		// 	delay(500);
		// }
		blink(2,150,mode);
		delay(2000);
	// }
}

#endif