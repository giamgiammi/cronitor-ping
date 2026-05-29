PACKAGE := cronitor-ping

PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin
SYSTEMD_UNIT_DIR ?= /lib/systemd/system

SRC_SCRIPT := src/bash/cronitor-ping.sh
SRC_SERVICE := src/systemd/cronitor-ping.service
SRC_TIMER := src/systemd/cronitor-ping.timer

INSTALL ?= install
SED ?= sed

.PHONY: all install uninstall clean

all:
	@echo "Nothing to build. Run 'make install' to install $(PACKAGE)."

install:
	$(INSTALL) -D -m 0555 "$(SRC_SCRIPT)" "$(DESTDIR)$(BINDIR)/cronitor-ping.sh"

	$(INSTALL) -d "$(DESTDIR)$(SYSTEMD_UNIT_DIR)"
	$(SED) "s|%PREFIX|$(PREFIX)|g" "$(SRC_SERVICE)" > "$(DESTDIR)$(SYSTEMD_UNIT_DIR)/cronitor-ping.service"
	chmod 0644 "$(DESTDIR)$(SYSTEMD_UNIT_DIR)/cronitor-ping.service"
	$(INSTALL) -D -m 0644 "$(SRC_TIMER)" "$(DESTDIR)$(SYSTEMD_UNIT_DIR)/cronitor-ping.timer"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/cronitor-ping.sh"
	rm -f "$(DESTDIR)$(SYSTEMD_UNIT_DIR)/cronitor-ping.service"
	rm -f "$(DESTDIR)$(SYSTEMD_UNIT_DIR)/cronitor-ping.timer"

clean:
	@echo "Nothing to clean."