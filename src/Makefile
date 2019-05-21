UNAME := $(shell uname)
BUILD := build

ifeq ($(UNAME), Linux)
TOOL_BASE=tools/linux/usr/m68k-atari-mint/bin
endif
ifeq ($(UNAME), Darwin)
TOOL_BASE=tools/darwin/opt/cross-mint/m68k-atari-mint/bin
endif

.PHONY:	all clean

all:	$(BUILD) $(BUILD)/init.bin

clean:
	@rm -rf $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@

$(BUILD)/init.bin:		init.s
	$(TOOL_BASE)/as $< -o $(BUILD)/init.o
	$(TOOL_BASE)/objcopy -O binary $(BUILD)/init.o $@
