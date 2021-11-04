VERSION  ?= 2.1.5

CC       ?= cc
CXX      ?= c++
INSTALL  ?= install
LN       ?= ln

CFLAGS   ?= -O2 -pipe
CXXFLAGS ?= $(CFLAGS)
LDFLAGS  ?=

PREFIX   ?= /usr/local

BINDIR   ?= $(PREFIX)/bin
MANDIR   ?= $(PREFIX)/share/man

SRC      := $(wildcard *.c) $(wildcard *.cpp)
LIBS     ?= -lcrypto -lplist-2.0

all: ldid

%.c.o: %.c
	$(CC) -c $(CFLAGS) -I. $< -o $@

%.cpp.o: %.cpp
	$(CXX) -c -std=c++11 $(CXXFLAGS) -I. -DLDID_VERSION=\"$(VERSION)\" $< -o $@

ldid: $(SRC:%=%.o)
	$(CXX) $^ $(LDFLAGS) $(LIBS) -o ldid

install: all
	$(INSTALL) -D -m755 ldid $(DESTDIR)$(BINDIR)/ldid
	$(LN) -sf ldid $(DESTDIR)$(BINDIR)/ldid2
	$(INSTALL) -D -m644 docs/ldid.1 $(DESTDIR)$(MANDIR)/man1/ldid.1
	$(INSTALL) -D -m644 docs/ldid.1.zh_TW $(DESTDIR)$(MANDIR)/zh_TW/man1/ldid.1

clean:
	rm -rf ldid *.o

.PHONY: all clean install
