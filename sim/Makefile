BUILD = obj_dir
TARGET = m68k_tb

.PHONY:	all clean $(BUILD)

all:	$(BUILD)/$(TARGET)
clean:
	@rm -rf $(BUILD)

$(BUILD):		main.cpp $(TARGET).v
	@verilator --trace --cc $(TARGET).v --Mdir $(BUILD) --exe $<
	@echo built $@

$(BUILD)/$(TARGET):	$(BUILD)
	@make -j -C $(BUILD) -f V$(TARGET).mk V$(TARGET)
	@echo built V$(TARGET)
