###############  BE EXTREMELY CAREFUL WITH THIS ################
###############  0 means ON, 1 means OFF        ################
###############  Definitely use the atmega datasheet ###########

##################### ATMEGA328P ######################### 
######## LOW
#	Bit			Description						Default
#	7			Divide clock by 8	 			0
#	6			Clock Output					1
#	5			Startup Time 1					1
#	4			Startup Time 0					0
#	3			Clock Source 3					0
#	2			Clock Source 2					0
#	1			Clock Source 1					1
#	0			Clock Source 0					0
######## HIGH
#	7			External Reset Disable 			1 (NEVER TURN ON)
#	6			Debug Wire Enable				1 
#	5			Serial, Data Downloading (SPI)	0
#	4			Watchdog Timer Always ON 		1
#	3			Enable EEPROM Preserve			1
#	2			BootSize1						0
#	1			BootSize0						0
#	0			Select Reset Vector				1
######## EXTENDED
#	7			None				 			1
#	6			None							1
#	5			None							1
#	4			None					 		1
#	3			None							1
#	2			BODL2							1
#	1			BODL1							1
#	0			BODL0							1

##################### ATTINY13 ######################### 
######## LOW
#	Bit			Description						Default
#	7			SPIEN(Enable Serial) 			0
#	6			Enable EEPROM Preserve			1
#	5			Watchdog Timer Always ON		1
#	4			Divide clock by 8				0
#	3			Startup time 1					1
#	2			Startup time 0					0
#	1			Clock Source 1					1
#	0			Clock Source 0					0
######## HIGH
#	7			None 							1
#	6			None							1
#	5			None							1
#	4			Self Programming Enable 		1
#	3			debugWire Enable				1
#	2			BODL1							1
#	1			BODL0							1
#	0			External Reset Disable			1 (NEVER TURN ON)
#
######## Clock
# 00 External -- 01,10 4.8/9.6 MHz Internal -- 11 128kHz Internal
ifeq ($(MCU),$(filter attiny13 t13,$(MCU)))
FUSENUM=2
else ifeq ($(MCU),$(filter atmega328 atmega328p atmega328pu m328 m328p m328pu,$(MCU)))
FUSENUM=3
endif

ifeq ($(BOARD), factory328)
LFU := 01100010
HFU := 11011001
EFU := 11111111
else ifeq ($(BOARD), uno)
LFU := 11111111
HFU := 11011110
EFU := 00000101
else ifeq ($(BOARD), mega)
LFU := 11111111
HFU := 11011000
EFU := 11111101
else ifeq ($(BOARD), solar)
LFU := 01111001 # Internal 4.8k clock
HFU := 11111101


else
$(error No board selected or board fuse not set)
endif
# Converts it to hex for avrdude
V_LFU := $(shell echo 'obase=16;ibase=2;$(LFU)'|bc)
V_HFU := $(shell echo 'obase=16;ibase=2;$(HFU)'|bc)
V_EFU := $(shell echo 'obase=16;ibase=2;$(EFU)'|bc)
