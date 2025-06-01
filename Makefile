# variables
PROJ_DIR := $(shell pwd)
SCRIPT_PATH := $(PROJ_DIR)/script/neobat.sh
BIN_DIR := /usr/local/bin
SYMLINK_NAME := neobat

# installation as a global command
install:
	@echo "Installing neobat.."
	@chmod +x $(SCRIPT_PATH)
	@sudo ln -sf $(SCRIPT_PATH) $(BIN_DIR)/$(SYMLINK_NAME)
	@echo "Installation is done! Run 'neobat' now!"
	
# uninstall command
uninstall:
	@echo "Uninstalling neobat.."
	@sudo rm -f $(BIN_DIR)/$(SYMLINK_NAME)
	@echo "Uninstallation is done!"

# help message
help:
	@echo "Available targets:"
	@echo "	make install	- Install the script as a global command"
	@echo "	make uninstall	- Remove the command"
	@echo "	make help		- Show this help message"

# default
default: help
