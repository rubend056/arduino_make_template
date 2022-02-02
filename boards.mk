
# In case you want to use different boards for different projects :), default is samn
ifeq ($(BOARD),)
# ifeq ($(PRJ),$(filter flasher hq,$(PRJ)))
# BOARD=uno
# else 
# BOARD=samn
# endif
BOARD=solar
endif
$(info BOARD is $(BOARD))


ifeq ($(BOARD),$(filter solar,$(BOARD)))
MCU=attiny13
FQBN=MicroCore:avr:attiny13:clock=4M8
# FQBN=MicroCore:avr:attiny13
endif

$(info MCU is $(MCU))
$(info FQBN is $(FQBN))

# ifeq ($(BOARD_TYPE),)
# ifeq ($(BOARD),$(filter uno,$(BOARD)))
# BOARD_TYPE=1
# $(info BOARD_TYPE set to 1(UNO))
# # else ifeq ($(BOARD),$(filter samn,$(BOARD)))
# # BOARD_TYPE=0
# # $(info BOARD_TYPE set to 0(SAMN))
# else
# BOARD_TYPE=1
# $(info BOARD_TYPE set to 1(UNO))
# # BOARD_TYPE=0
# # $(info BOARD_TYPE set to 0(SAMN))
# endif

# else
# $(info BOARD_TYPE set to $(BOARD_TYPE))
# endif


ifeq ($(BOARD_V),)
BOARD_V=0
endif
$(info BOARD_V set to $(BOARD_V))