
include config.mk

.PHONY: all lib4 love linux windows mac push clean

default: love

all: lib4 love linux windows mac

lib4:
	@lib4/build.sh --bare lib4

love: lib4
	@lib4/build.sh $(GAME) release/$(GAME).love

linux:
	@echo "Building for linux..."
	cp release/$(GAME).love $(LINUX_NAME)
	@echo "Done."

windows:
	@echo "Building for Windows..."
	cat release/windows/love.exe release/$(GAME).love > $(WINDOWS_NAME)
	@echo "Done."

mac:
	@echo "Building for macOS..."
	cp release/$(GAME).love $(MAC_NAME)/Contents/Resources/
	@echo "Done."

push:
	@lib4/butler.sh $(GAME) $(VERSION) $(ITCH) $(LINUX_PATH) $(WINDOWS_PATH) $(MAC_PATH)

clean: 
	rm -f release/$(GAME).love
	rm -f $(LINUX_NAME)
	rm -f $(WINDOWS_NAME)
	rm -f $(MAC_NAME)/Contents/Resources/$(GAME).love
