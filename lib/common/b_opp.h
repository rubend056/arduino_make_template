#ifndef B_OPP
#define B_OPP


#define SET(data,shift) (data |= (1 << shift))
#define CLR(data,shift) (data &= ~(1 << shift))
#define SET_CLR(data,shift,set_bool) {set_bool ? SET(data,shift) : CLR(data,shift);}
#define GET(data,shift) (data & (1 << shift) > 0)

#endif