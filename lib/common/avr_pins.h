#ifndef AVR_PINS
#define AVR_PINS



#include "b_opp.h"

// *****************SHORT EXPLANATION OF DDR, PORT, and PIN registers***************
// DDR stands for Data Direction Register, if 1 the pin is output, if 0, pin is input
// PORT is basically a register weather the pin is connected to ground or positive
// PIN is basically a register weather the pin is currently high or low, 
//   currently unsure if the DDR needs to be low for this to work, 
//   my guess it doens't and you can read it regardless

// Set the data direction register
#define SET_DDR(l,s) SET(DDR##l, s)
// Set the PORT, wether it's 5V or Ground(output), enable pullup or not(input)
#define SET_PORT(l,s) SET(PORT##l, s)
// Clear the data direction register
#define CLR_DDR(l,s) CLR(DDR##l, s)
// Clear the PORT, wether it's 5V or Ground(output), enable pullup or not(input)
#define CLR_PORT(l,s) CLR(PORT##l, s)

// EITHER SET OR CLR
// Set the data direction register
#define SET_CLR_DDR(l,s, t) SET_CLR(DDR##l, s, t)
// Set the PORT, wether it's 5V or Ground(output), enable pullup or not(input)
#define SET_CLR_PORT(l,s, t) SET_CLR(PORT##l, s, t)

// Get teh PIN, wether the pin is 5v or not
#define GET_PIN(l,s) GET(PIN##l, s)



// // For atmega328P, to be used with SET and GET functions defined here ONLY
// #define PIN0 D,0
// #define PIN1 D,1
// #define PIN2 D,2
// #define PIN3 D,3
// #define PIN4 D,4
// #define PIN5 D,5
// #define PIN6 D,6
// #define PIN7 D,7


#endif