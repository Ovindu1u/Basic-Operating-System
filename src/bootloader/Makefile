ASM=nasm

BUILD=build/bootloader
SRC=src/bootloader
INC=include/bootloader


all: clean bootloader

bootloader: $(BUILD)/mbr.img

$(BUILD)/mbr.img:
	$(ASM) -i $(INC) -o $(BUILD)/mbr.img $(SRC)/mbr.S


clean:
	mkdir -p $(BUILD)
	rm -rf $(BUILD)/*

