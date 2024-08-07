ASM=nasm
CC=gcc

BUILD=build
SRC=src

all: floppy

tools: clean_tools initmbr

floppy: clean bootloader initmbr $(BUILD)/floppy.img

$(BUILD)/floppy.img:
	dd if=/dev/zero of=$(BUILD)/floppy.img bs=512 count=2880
	mkfs.fat -F12 -n "BASIC-OS" $(BUILD)/floppy.img
	./$(BUILD)/tools/init-mbr $(BUILD)/floppy.img $(BUILD)/bootloader/mbr.img

bootloader:
	$(MAKE) -f $(SRC)/bootloader/Makefile


initmbr: $(BUILD)/tools/init-mbr

$(BUILD)/tools/init-mbr:
	$(CC) -o $(BUILD)/tools/init-mbr $(SRC)/tools/init_mbr.c


clean: clean_build clean_tools clean_boot


clean_tools:
	mkdir -p $(BUILD)/tools
	rm -rf $(BUILD)/tools/*


clean_boot:
	mkdir -p $(BUILD)/bootloader
	rm -rf $(BUILD)/bootloader/*


clean_build:
	mkdir -p $(BUILD)
	rm -rf $(BUILD)/*


clear:
	rm -rf $(BUILD)



