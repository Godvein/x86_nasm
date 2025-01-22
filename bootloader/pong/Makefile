BUILD_DIR = build
SRC_DIR = src


$(BUILD_DIR)/pong.img : $(BUILD_DIR)/pong.bin | $(BUILD_DIR)
	cp $(BUILD_DIR)/pong.bin $(BUILD_DIR)/pong.img
	truncate -s 1440k $(BUILD_DIR)/pong.img

$(BUILD_DIR)/pong.bin : $(SRC_DIR)/pong.asm | $(BUILD_DIR)
	nasm -f bin $(SRC_DIR)/pong.asm -o $(BUILD_DIR)/pong.bin 
	
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	
clean:
	rm -rf $(BUILD_DIR)	
