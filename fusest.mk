
ifeq ($(FUSENUM),2)
fuse_write:
	$(AVRDUDE) -U lfuse:w:0x$(V_LFU):m -U hfuse:w:0x$(V_HFU):m
fuse_read:
	$(AVRDUDE) -U lfuse:r:lfuse.bin:r -U hfuse:r:hfuse.bin:r
	xxd -b lfuse.bin
	xxd -b hfuse.bin
	rm *fuse.bin
else ifeq ($(FUSENUM),3)
fuse_write:
	$(AVRDUDE) -U lfuse:w:0x$(V_LFU):m -U hfuse:w:0x$(V_HFU):m -U efuse:w:0x$(V_EFU):m
fuse_read:
	$(AVRDUDE) -U lfuse:r:lfuse.bin:r -U hfuse:r:hfuse.bin:r -U efuse:r:efuse.bin:r
	xxd -b lfuse.bin
	xxd -b hfuse.bin
	xxd -b efuse.bin
	rm *fuse.bin
else
$(error No FUSENUM set)
endif
	