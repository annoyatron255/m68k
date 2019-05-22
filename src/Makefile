UNAME := $(shell uname)
BUILD := build

ifeq ($(UNAME), Linux)
TOOL_BASE=tools/linux/usr/m68k-atari-mint/bin
endif
ifeq ($(UNAME), Darwin)
TOOL_BASE=tools/darwin/opt/cross-mint/m68k-atari-mint/bin
endif

AS := $(TOOL_BASE)/as
OBJCOPY := $(TOOL_BASE)/objcopy

.PHONY:	all clean

all:	$(BUILD) $(BUILD)/init.hex

clean:
	@rm -rf $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@

$(BUILD)/init.bin:		init.s
	@$(AS) $< -o $(BUILD)/init.o
	@$(OBJCOPY) -O binary $(BUILD)/init.o $@
	@echo built $(notdir $@)

$(BUILD)/init.hex:		$(BUILD)/init.bin
	@xxd -c 2 -ps $< $@
	@echo built $(notdir $@)
