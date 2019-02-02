#ifndef B_OPP
#define B_OPP

// Bit macros
#define SET(d,b) (d |= (1 << b))
#define CLR(d,b) (d &= ~(1 << b))
#define TOG(d,b) (d ^= (1 << b))

#define SET2(d,b,b2) (d |=   (1 << b)  | (1 << b2)  )
#define CLR2(d,b,b2) (d &= ~((1 << b)  | (1 << b2)) )
#define TOG2(d,b,b2) (d ^=   (1 << b)  | (1 << b2)  )

#define SETI(d,b) ((d) | (1 << b))
#define CLRI(d,b) ((d) & ~(1 << b))
#define TOGI(d,b) ((d) ^ (1 << b))
#define GETI(d,b) ((d >> b) & 1)

#define SET2I(d,b,b2) (d |   ((1 << b)  | (1 << b2))  )
#define CLR2I(d,b,b2) (d & (~((1 << b)  | (1 << b2))) )
#define TOG2I(d,b,b2) (d ^   ((1 << b)  | (1 << b2))  )
////////


#define SET_OR_CLR(d,b,s) {s ? SET(d,b) : CLR(d,b);}

#define SET_CLR(d,s,c) (d = (d | (1<<s)) & ~(1<<c))
#define SET_CLRI(d,s,c) ((d | (1<<s)) & ~(1<<c))
#define SET_CLR_VALUEI(d,s,c) ((d | (s)) & ~(c))

#define SET_VALUEI(d,v) ((d) | (v))
#define CLR_VALUEI(d,v) ((d) & ~(v))
#define TGL_VALUEI(d,v) ((d) ^ (v))

#endif