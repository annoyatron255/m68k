BUILD := build

.PHONY:	all clean $(BUILD)/m68k

all:	$(BUILD) $(BUILD)/dump.vcd

clean:
	@rm -rf $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@

$(BUILD)/m68k:
	@iverilog -o $@ m68k_tb.v
	@echo built $(notdir $@)

$(BUILD)/dump.vcd:		$(BUILD)/m68k
	@$<
	@echo built $(notdir $@)
