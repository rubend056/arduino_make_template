
# ifeq ($(strip $(NID)),)
# NID0=FF
# NID1=FF
# $(info NID(Node ID) set to FFFF)
# $(info If you want your own, set NID to an octal, ex: 01 would be node 1)
# else
# $(info NID(Node ID) is $(NID), should be octal)
# NIDH:=$(shell echo 'obase=16;ibase=8;$(NID)'|bc)# Converts the octal to hex

# # NID0:=$(shell NIDH=$(NIDH) && echo $${NIDH: -2})# Last two characters
# NID0:=$(shell NIDH=$(NIDH) && L=$${\#NIDH} && echo $${NIDH: $$(($$L<2? -$$L: -2))})# Last two characters
# NID1:=$(shell NIDH=$(NIDH) && L=$${\#NIDH} && echo $${NIDH: $$(($$L<4? -$$L: -4)): $$(($$L-2>2? 2: $$L-2))})# The two before that

# ifeq ($(NID0),)
# NID0=00
# endif
# ifeq ($(NID1),)
# NID1=00
# endif

# endif

# FA=0x30,0x30,0x30
# NA=0x00,0x$(NID1),0x$(NID0)
# ifeq ($(PRJ), flasher)
# EEPROM = $(FA),$(NA)
# else
# EEPROM = $(NA),$(FA)
# endif