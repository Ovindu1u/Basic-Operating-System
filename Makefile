ASM=nasm

BUILD=build
SRC=src

all: clean $(BUILD)/boot

$(BUILD)/boot:
	$(ASM) -o $(BUILD)/boot $(SRC)/bootloader/main.asm


clean:
	mkdir -p $(BUILD)
	rm -rf $(BUILD)/*


