#ifndef DEBUG_C
#define DEBUG_C

#ifdef DEBUG
#define PRINT(x) Serial.print(x);
#define PRINTA(x,y) Serial.print(x,y)
#define PRINTLN(x) Serial.println(x)
#define PRINTLNA(x,y) Serial.println(x,y)
#else
#define PRINT(x) 
#define PRINTA(x,y)
#define PRINTLN(x) 
#define PRINTLNA(x,y)
#endif

#endif