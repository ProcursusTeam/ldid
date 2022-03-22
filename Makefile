VERSION  ?= 2.1.5

CC       ?= cc
CXX      ?= c++
INSTALL  ?= install
LN       ?= ln

CFLAGS   ?= -O2 -pipe
CXXFLAGS ?= $(CFLAGS) -std=c++11
LDFLAGS  ?=

PREFIX   ?= /usr/local

BINDIR   ?= $(PREFIX)/bin
MANDIR   ?= $(PREFIX)/share/man

SRC      := $(wildcard *.c) $(wildcard *.cpp)
LIBS     ?= -lcrypto -lplist-2.0

MANPAGE_LANGS := zh_TW zh_CN

all: ldid

%.c.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -I. $< -o $@

%.cpp.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -I. -DLDID_VERSION=\"$(VERSION)\" $< -o $@

ldid: $(SRC:%=%.o)
	$(CXX) $(CXXFLAGS) -o ldid $^ $(LDFLAGS) $(LIBS)

install: all
	$(INSTALL) -D -m755 ldid $(DESTDIR)$(BINDIR)/ldid
	$(LN) -sf ldid $(DESTDIR)$(BINDIR)/ldid2
	$(INSTALL) -D -m644 docs/ldid.1 $(DESTDIR)$(MANDIR)/man1/ldid.1
	for lang in $(MANPAGE_LANGS); do \
		$(INSTALL) -D -m644 docs/ldid.$$lang.1 $(DESTDIR)$(MANDIR)/$$lang/man1/ldid.1; \
	done

clean:
	rm -rf ldid *.o

.PHONY: all clean install
