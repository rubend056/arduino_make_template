##################### FUSES ATMEGA328P ######################### 
###############  BE EXTREMELY CAREFUL WITH THIS ################
###############  0 means ON, 1 means OFF        ################
###############  Definitely use the atmega datasheet ###########
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



# The default project to use
ifeq ($(PRJ),)
$(warning Using template as PRJ)
# $(error Need to define PRJ variable)
PRJ=template
endif

# In case you want to use different boards for different projects :), default is samn
ifeq ($(BOARD),)
ifeq ($(PRJ),$(filter flasher hq,$(PRJ)))
BOARD=uno
else 
BOARD=samn
endif
endif

# The MCU to pass on to avrdude
ifeq ($(MCU),)
ifeq ($(BOARD),$(filter samn uno factory328,$(BOARD)))
# The board the avrdude will be programming
	MCU=m328p
	ARCH=avr
	PROGRAMMER_SERIAL=arduino
else ifeq ($(BOARD),$(filter samnhq mega,$(BOARD)))
# The board the avrdude will be programming	
	MCU=m2560
	ARCH=avr
	PROGRAMMER_SERIAL=wiring
else
$(error We need a valid BOARD variable)
endif
endif


ifeq ($(FQBN),)
ifeq ($(strip $(ARCH)),)
$(error ARCH not set)
endif
FQBN = arduino:$(ARCH):$(BOARD) # So, vendor_name:architecture:boards.txt entry,
endif
$(info FQBN is $(FQBN))


export PWD = $(shell pwd)
AVRDUDE = ./arduino/hardware/tools/avr/bin/avrdude -v -v -p $(MCU) -C ./arduino/hardware/tools/avr/etc/avrdude.conf



ifeq ($(BOARD_TYPE),)

ifeq ($(BOARD),$(filter uno,$(BOARD)))
BOARD_TYPE=1
$(info BOARD_TYPE set to 1(UNO))
# else ifeq ($(BOARD),$(filter samn,$(BOARD)))
# BOARD_TYPE=0
# $(info BOARD_TYPE set to 0(SAMN))
else
BOARD_TYPE=0
$(info BOARD_TYPE set to 0(SAMN))
endif

else
$(info BOARD_TYPE set to $(BOARD_TYPE))
endif

ifeq ($(BOARD_VERSION),)
BOARD_VERSION=7
endif
$(info BOARD_VERSION set to $(BOARD_VERSION))


ifeq ($(PORT),)
PORT = /dev/ttyUSB0
endif
PRG = usbasp # avr programmer to use




SRC_DIR = src/$(PRJ)
BUILD_DIR = build/$(PRJ)
SRCF = main.cpp
SRCH = $(PRJ).hex


# *************************** FUSES 
ifeq ($(BOARD), factory328)
#  ATMEGA328P Factory
LFU := 01100010
HFU := 11011001
EFU := 11111111
else ifeq ($(BOARD), uno)
#  ArduinoUno
LFU := 11111111
HFU := 11011110
EFU := 00000101
else ifeq ($(BOARD), mega)
# Arduino MEGA 2560
LFU := 11111111
HFU := 11011000
EFU := 11111101

else ifeq ($(BOARD), samn)
# SAMN
LFU := 10111111 #Don't divide clock | Enable clock output | Use Low power Crystal oscillator
HFU := 11010000 #Preserve EEPROM, call bootloader on start
EFU := 11111101 #Enable BOD, V min 1.7, typ 1.8, max 2.0
else ifeq ($(BOARD), samnhq)
# SAMN HQ
LFU := 11111111 
HFU := 11011000 
EFU := 11111101 

else
$(error No board selected)
endif
# Converts it to hex for avrdude
V_LFU := $(shell echo 'obase=16;ibase=2;$(LFU)'|bc)
V_HFU := $(shell echo 'obase=16;ibase=2;$(HFU)'|bc)
V_EFU := $(shell echo 'obase=16;ibase=2;$(EFU)'|bc)
# ///////////////////////////
#///////////////////////////////////

# EEPROM Address ***************
ifeq ($(strip $(NID)),)
NID0=FF
NID1=FF
$(info NID(Node ID) set to FFFF)
$(info If you want your own, set NID to an octal, ex: 01 would be node 1)
else
$(info NID(Node ID) is $(NID), should be octal)
NIDH:=$(shell echo 'obase=16;ibase=8;$(NID)'|bc)# Converts the octal to hex

# NID0:=$(shell NIDH=$(NIDH) && echo $${NIDH: -2})# Last two characters
NID0:=$(shell NIDH=$(NIDH) && L=$${\#NIDH} && echo $${NIDH: $$(($$L<2? -$$L: -2))})# Last two characters
NID1:=$(shell NIDH=$(NIDH) && L=$${\#NIDH} && echo $${NIDH: $$(($$L<4? -$$L: -4)): $$(($$L-2>2? 2: $$L-2))})# The two before that

ifeq ($(NID0),)
NID0=00
endif
ifeq ($(NID1),)
NID1=00
endif

endif



FA=0x30,0x30,0x30
NA=0x00,0x$(NID1),0x$(NID0)
ifeq ($(PRJ), flasher)
EEPROM = $(FA),$(NA)
else
EEPROM = $(NA),$(FA)
endif
# ///////////////////////////////





all: build


# FLASHING
flash: flash_programmer
flash_programmer: build
	$(AVRDUDE) -c $(PRG) -U flash:w:$(SRCH):i
flash_arduino: build
	$(AVRDUDE) -c $(PRG_SKETCH) -P $(PORT) -b 115200 -D -U flash:w:$(SRCH):i
flash_remote: build
	$(AVRDUDE) -b 115200 -B 3 -V -c $(PRG_SKETCH) -P $(PORT) -U flash:w:$(SRCH):i
#///////////////////////////////

# BUILD TARGETS **********************
mkbdir:
	@mkdir -p $(BUILD_DIR)
build: mkbdir
ifeq ($(PRJ),optiboot)
	@cd $(SRC_DIR) && make samn LED_START_FLASHES=0 RADIO_UART=1 FORCE_WATCHDOG=1 SUPPORT_EEPROM=1 LED=D5
	@cp -f $(strip $(SRC_DIR))/optiboot_samn.hex $(SRCH)
else
	@./arduino-builder.sh $(FQBN) $(strip $(SRC_DIR))/$(SRCF) $(BUILD_DIR) $(BOARD_TYPE) $(BOARD_VERSION)
	@cp -f $(strip $(BUILD_DIR))/$(SRCF).hex $(SRCH)
endif

#////////////////////////////////////

# samn:
# 	make -f samn.Makefile $(TAR)
# rf24boot:
# 	make -f rf24boot.Makefile $(TAR)
# flasher:
# 	make -f flasher.Makefile $(TAR)
# mesh:
# 	make -f mesh.Makefile $(TAR)

# TEST=$@
# ifeq ($(TEST),new)
# # ifeq ($(NAME),)
# $(error You must name your project, NAME must be set, use NAME=name_of_project)
# # endif
# endif

new:
	@if [ "$(NAME)" != "" ]; then \
		mkdir -p src/$(NAME); \
		cp -r src/template/* src/$(NAME)/; \
	fi

# test programmer connectivity
test:
	$(AVRDUDE) -c $(PRG) -v
# FUSES ****************
fuse:
	$(AVRDUDE) -c $(PRG) -U lfuse:w:0x$(V_LFU):m -U hfuse:w:0x$(V_HFU):m -U efuse:w:0x$(V_EFU):m
# ///////////////////////
# EEPROM ****************
eeprom:
	$(AVRDUDE) -c $(PRG) -U eeprom:w:$(EEPROM):m
eeprom_read:
	$(AVRDUDE) -c usbasp -U eeprom:r:ee.txt:h
	cat ee.txt
# ///////////////////////



init_sensor:
	make PRJ=samn fuse
	make PRJ=optiboot flash_programmer
	make PRJ=samn eeprom

init_flasher:
	make BOARD=uno PRJ=flasher fuse
	# make BOARD=uno PRJ=flasher flash_programmer
	make BOARD=uno PRJ=flasher eeprom
