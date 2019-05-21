TOOL_BASE=tools/linux/usr/m68k-atari-mint/bin

build/rom.bin:
	$(TOOL_BASE)/as boot.s -o build/rom.o
	$(TOOL_BASE)/objcopy -O binary build/rom.o build/rom.bin	
