VERSION  ?= 2.1.5

CC       ?= cc
CXX      ?= c++
INSTALL  ?= install
LN       ?= ln

CXXFLAGS ?= -std=c++11 -O2 -pipe
LDFLAGS  ?=

PREFIX   ?= /usr/local

BINDIR   ?= $(PREFIX)/bin
MANDIR   ?= $(PREFIX)/share/man

SRC      := ldid.cpp
LIBS     ?= -lcrypto -lplist-2.0

MANPAGE_LANGS := zh_TW zh_CN

all: ldid

%.cpp.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -I. -DLDID_VERSION=\"$(VERSION)\" $< -o $@

ldid: $(SRC:%=%.o)
	$(CXX) $(CXXFLAGS) -o ldid $^ $(LDFLAGS) $(LIBS)

install: all
	$(INSTALL) -d $(DESTDIR)$(BINDIR)/
	$(INSTALL) -m755 ldid $(DESTDIR)$(BINDIR)/ldid
	$(LN) -sf ldid $(DESTDIR)$(BINDIR)/ldid2
	$(INSTALL) -d $(DESTDIR)$(MANDIR)/man1/
	$(INSTALL) -m644 docs/ldid.1 $(DESTDIR)$(MANDIR)/man1/ldid.1
	for lang in $(MANPAGE_LANGS); do \
		$(INSTALL) -d $(DESTDIR)$(MANDIR)/$$lang/man1/; \
		$(INSTALL) -m644 docs/ldid.$$lang.1 $(DESTDIR)$(MANDIR)/$$lang/man1/ldid.1; \
	done

clean:
	rm -rf ldid *.o

.PHONY: all clean install
