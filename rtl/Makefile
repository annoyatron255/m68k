.SUFFIXES:

TARGET		:= m68k
BUILD		:= build
SOURCES		:= .
DEVICE		:= 8k
DEVICETYPE	:= hx8k
FOOTPRINT	:= tq144:4k

FILES		:= $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.v)))

ROMSOURCE	:= ../src
ROMFILE		:= $(ROMSOURCE)/build/rom.hex

OUTPUT		:= $(BUILD)/$(TARGET)

.PHONY: all clean $(ROMFILE)

all:	$(BUILD) $(OUTPUT)Pad.bin

$(BUILD):
	@[ -d $@ ] || mkdir -p $@

clean:
	@rm -rf $(BUILD)
	@$(MAKE) -C $(ROMSOURCE) clean

timing:			$(BUILD)/timing.txt
	@cat $(BUILD)/timing.txt

$(BUILD)/timing.txt:	$(BUILD) $(TARGET).pcf $(OUTPUT)_rom.asc
	@icetime -tmd $(DEVICETYPE) -p $(TARGET).pcf -P $(FOOTPRINT) $(OUTPUT)_rom.asc > $@

$(OUTPUT)Pad.bin:	$(OUTPUT).bin $(BUILD)/4M0xFF.bin
	@echo padding $< to $@
	@cp $(BUILD)/4M0xFF.bin $@
	@dd if=$< of=$@ conv=notrunc status=none

$(BUILD)/4M0xFF.bin:
	@echo creating pad file $@
	@dd if=/dev/zero ibs=1M count=4 status=none | tr "\000" "\377" > $@ 

$(OUTPUT).bin:		$(OUTPUT)_rom.asc
	@echo packing $< to $@
	@icepack $< $@

$(OUTPUT)_rom.asc:	$(OUTPUT).asc $(ROMFILE)
	@echo inserting $(ROMFILE) into $@
	@icebram $(BUILD)/rand.hex $(ROMFILE) < $< > $@

$(BUILD)/rand.hex:
	@echo creating default bram file $@
	@icebram -g 16 1024 > $@

$(ROMFILE):
	@$(MAKE) -C $(ROMSOURCE) all

$(OUTPUT).asc:		$(OUTPUT).blif $(TARGET).pcf
	@echo creating $@
	@arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) $< -p $(TARGET).pcf -o $@

$(OUTPUT).blif:		$(FILES) $(BUILD)/rand.hex
	@echo creating $@
	@yosys -p "synth_ice40 -top $(TARGET) -blif $@" $(FILES)

