#include <Arduino.h>
#include <avr_madness.h>

#define AVERAGE_NUM 2

uint8_t inputs[3]={2,3,0};
uint8_t outputs[3]={0,1,2};

#ifdef AVERAGE_NUM
int16_t input_a[3][AVERAGE_NUM];
uint8_t input_c[3];
#endif


enum STATE{IDDLE, AA, LITHIUM};
STATE state=IDDLE;

int16_t readings[3];

int main(void){
	// adc_setup();
	
	init(); // Initializes timers, etc...
	setup();
	while(1)
		loop();
	return 0;
}

void setup(){
	
	delay(1000);
	for(uint8_t i=0;i<3;++i){
		pinMode(inputs[i], INPUT);
		
		readings[i]=0;
			
#ifdef AVERAGE_NUM
		input_c[i]=0;
		for(uint8_t e=0;e<AVERAGE_NUM;++e)input_a[i][e]=0;
#endif

		CLR_PORT(B,outputs[i]);
		SET_DDR(B,outputs[i]);
		delay(2);
		CLR_DDR(B,outputs[i]);
	}
}

#define VALUE_TO_STRING(x) #x
#define VALUE(x) VALUE_TO_STRING(x)
#define VAR_NAME_VALUE(var) #var "="  VALUE(var)


#define REFERENCE_VOLTAGE (3330.)//3330.
#define RESISTOR_RATIO_0 (0.66551)//0.66551
#define RESISTOR_RATIO_1 (0.66565)
#define RESISTOR_RATIO_2 (0.66791)

#define AA_CHARGED_VOLTAGE (1500.)
// #define AA_LITHIUM_BREAK_VOLTAGE (2000.)
#define LITHIUM_CHARGED_VOLTAGE (4150.)

#define CHARGED_VALUE(voltage_t_ratio) (int16_t)((voltage_t_ratio) * 1024 / REFERENCE_VOLTAGE)
#define ARRAY_COMMON(ratio) CHARGED_VALUE(AA_CHARGED_VOLTAGE*ratio),\
							CHARGED_VALUE(LITHIUM_CHARGED_VOLTAGE*ratio)

#define AA_CHARGED_VALUE 0
#define LITHIUM_CHARGED_VALUE 1

// #define HALF_VALUE (int16_t)((HALF_VOLTAGE*RESISTOR_RATIO) * 1024 / REFERENCE_VOLTAGE)
const int16_t charged_values[][2] = {
	{ARRAY_COMMON(RESISTOR_RATIO_0)},
	{ARRAY_COMMON(RESISTOR_RATIO_1)},
	{ARRAY_COMMON(RESISTOR_RATIO_2)}
};

// const int16_t half_value = HALF_VALUE;
// #define CHARGED_VALUE 847
#pragma message(CHARGED_VALUE(LITHIUM_CHARGED_VOLTAGE*RESISTOR_RATIO_0))

#define WITHIN(v, a, b) (v>a && v<b)
#define IS_AA(v,e) (WITHIN(v,100,charged_values[e][AA_CHARGED_VALUE]))
#define IS_LITHIUM(v,e) (WITHIN(v,400,charged_values[e][LITHIUM_CHARGED_VALUE]))

void update_state(){
	for(uint8_t i=0;i<3;++i){
		if( IS_LITHIUM(readings[i],i) ){state=LITHIUM;return;}
	}
	for(uint8_t i=0;i<3;++i){
		if( IS_AA(readings[i],i) ){state=AA;return;}
	}
	state=IDDLE;
}

void loop(){
	for(uint8_t i=0;i<3;++i){CLR_DDR(B,outputs[i]);} // Halt outputs
	delay(10);
	for(uint8_t i=0;i<3;++i){ // Do readings	
		int16_t a=0;
#ifdef AVERAGE_NUM
		// Take the current voltage sample
		input_a[i][input_c[i]++]=analogRead(inputs[i]);
		if(input_c[i] >= AVERAGE_NUM)input_c[i]=0;
		// Sum all the averages
		for(uint8_t e=0;e<AVERAGE_NUM;++e)a+=input_a[i][e];
		a/=AVERAGE_NUM;
#else
		a=analogRead(inputs[i]);
		// a=600;
#endif
		readings[i]=a;
	}
	update_state();
	
	for(uint8_t i=0;i<3;++i){
		switch (state){
		case LITHIUM:
			if(IS_LITHIUM(readings[i],i)){
				CLR_PORT(B,outputs[i]);
				SET_DDR(B,outputs[i]);
			}
			break;
		case AA:
			if(IS_AA(readings[i],i)){
				CLR_PORT(B,outputs[i]);
				SET_DDR(B,outputs[i]);
			}
			break;
		// case IDDLE:
		// 	CLR_PORT(B,outputs[i]);
		// 	// if(!i){
		// 	// 	CLR_PORT(B,outputs[i]);
		// 	// 	SET_DDR(B,outputs[i]);
		// 	// 	delay(200);
		// 	// }
		// 	CLR_DDR(B,outputs[i]);
		// 	break;
		// default:
		// 	if(!i){
		// 		CLR_PORT(B,outputs[i]);
		// 		SET_DDR(B,outputs[i]);
		// 		delay(100);
		// 	}
		// 	CLR_DDR(B,outputs[i]);
		// 	break;
		}
	}
	delay(1000);
}
