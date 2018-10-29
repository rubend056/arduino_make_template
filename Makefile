##################### FUSES ATMEGA328P ######################### 
###############  BE EXTREMELY CAREFUL WITH THIS ################
###############  0 means ON, 1 means OFF        ################
###############  Definitely use the atmega datasheet ###########
#	Bit			Description						Default
#	7			None				 			1
#	6			None							1
#	5			None							1
#	4			None					 		1
#	3			None							1
#	2			BODL2							1
#	1			BODL1							1
#	0			BODL0							1
EFU = $((2#11111111))
#	7			External Reset Disable 			1 (NEVER TURN ON)
#	6			Debug Wire Enable				1 
#	5			Serial, Data Downloading (SPI)	0
#	4			Watchdog Timer Always ON 		1
#	3			Enable EEPROM Preserve			1
#	2			BootSize1						0
#	1			BootSize0						0
#	0			Select Reset Vector				1
HFU = $((2#11011001))
#	7			Divide clock by 8	 			0
#	6			Clock Output					1
#	5			Startup Time 1					1
#	4			Startup Time 0					0
#	3			Clock Source 3					0
#	2			Clock Source 2					0
#	1			Clock Source 1					1
#	0			Clock Source 0					0
LFU = $((2#01100010))
###########################################################


PRJ = main #needs to be same name as the main cpp file


########   ARDUINO BUILDER
# The board the arduino-builder will use to compile
FQBN = arduino:avr:uno # So, vendor_name:architecture:boards.txt entry,
# this is your target board, please change it if you feel the need to
# change in arduino/hardware/arduino/avr/boards.txt

########   AVRDUDE
MCU = atmega328p # The board the avrdude will be programming
CLK = 16000000 # MCU clock frequency, for interfacing with the 
PRG = arduino # avr programmer to use


#################################################################################################
# \/ stuff nobody needs to worry about until such time that worrying about it is appropriate \/ #
#################################################################################################

# Folders
SRC_DIR = src
LIB_DIR = lib
BUILD_DIR = build

# File extensions
SRCF = $(strip $(PRJ)).cpp
SRCH = $(strip $(SRCF)).hex


# executables
AVRDUDE = ./arduino/hardware/bin/avrdude -c $(PRG) -p $(MCU)
# OBJCOPY = avr-objcopy
# OBJDUMP = avr-objdump
# SIZE    = avr-size --format=avr --mcu=$(MCU)
# CC      = avr-gcc


# user targets
# compile all files

all: $(PRJ)

# test programmer connectivity
test:
	$(AVRDUDE) -v

# flash program to mcu
flash: all
	$(AVRDUDE) -U flash:w:$(SRCH):i

# write fuses to mcu
fuse:
	$(AVRDUDE) -U lfuse:w:$(LFU):m -U hfuse:w:$(HFU):m -U efuse:w:$(EFU):m

.PHONY: $(PRJ) # Because $(PRJ) has no output filename

$(PRJ):
	if ! [ -d "./$(BUILD_DIR)" ]; then mkdir $(BUILD_DIR); fi
	./arduino-builder.sh $(FQBN) $(strip $(SRC_DIR))/$(SRCF) $(LIB_DIR) $(BUILD_DIR)
	cp -f $(strip $(BUILD_DIR))/$(SRCH) $(SRCH)

