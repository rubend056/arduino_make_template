
ifeq ($(PRJ),)
$(warning Using template as PRJ)
# $(error Need to define PRJ variable)
PRJ=template
endif
$(info PRJ is $(PRJ))

include boards.mk

include fusesd.mk

include eeprom.mk




ifeq ($(PORT),)
PORT=/dev/ttyACM0
$(warning PORT set to $(PORT))
else
$(info PORT is $(PORT))
endif

ifeq ($(PRG),)
PRG=usbasp
$(warning PRG set to $(PRG))
else
$(info PRG is $(PRG))
endif

AVRDUDE=avrdude -p $(MCU) -c $(PRG)

# --build-cache-path `pwd`/build/$(PRJ)
build:
	arduino-cli compile -b $(FQBN) ./src/$(PRJ)/main.cpp  --build-path `pwd`/built/$(PRJ) -o ./$(PRJ).hex

upload_p: build
	$(AVRDUDE) -U flash:w:$(PRJ).hex:i
	
upload: build
	$(AVRDUDE) -p $(PORT) -U flash:w:$(PRJ).hex:i

clean:
	rm *.hex
	rm *.elf
	rm -r ./built

new:
	@if [ "$(NAME)" != "" ]; then \
		mkdir -p src/$(NAME); \
		cp -r src/template/* src/$(NAME)/; \
	fi


test:
	$(AVRDUDE) -v


include fusest.mk

# EEPROM ****************
eeprom:
	$(AVRDUDE) -U eeprom:w:$(EEPROM):m
eeprom_read:
	$(AVRDUDE) -U eeprom:r:ee.txt:h
	cat ee.txt
# ///////////////////////
