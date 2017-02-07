DESTDIR ?= /

all:

install:
	mkdir -p $(DESTDIR)/bin
	mkdir -p $(DESTDIR)/lib/systemd/system
	install ddns $(DESTDIR)/bin
	cp systemd/ddns.* $(DESTDIR)/lib/systemd/system
