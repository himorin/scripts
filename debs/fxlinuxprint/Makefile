# MAKEFILE FOR GENERAL

.SUFFIXES: 
.SUFFIXES: .o .c .cc

PACKAGE  = TEST

INSTDIR  = ./
INSTUSR  = $(INSTDIR)/usr
INSTETC  = $(INSTDIR)/etc
INSTFILT = $(INSTDIR)/usr/lib/cups/filter
INSTPPD  = $(INSTDIR)/usr/share/ppd/FujiXerox
INSTSHAR = $(INSTDIR)/usr/share/$(PACKAGE)

SOURCE   = data

CC       = gcc
AR       = ar
RM       = rm -Rf
ECHO     = /bin/echo
INSTALL  = /usr/bin/install
SLINK    = ln -s

ARFLAGS  = 
CCOMP    = -Wall -Wextra -O2 -fPIC
CINCL    = -I.
LDLIBS   = 
LDINCL   = 

CFLAGS   = $(CCOMP) $(CINCL)
LDFLAGS  = $(LDLIBS) $(LDINCL) -shared

DEPFILE  = DEPMOD
DOXYOUT  = doxyout

OBJS = \

.PHONY: clean install

#----------------------------------------------------------------------- TARGETS
all: 

install:
	$(INSTALL) -d $(INSTETC)/cups
	$(INSTALL) -d $(INSTFILT)
	$(INSTALL) -d $(INSTSHAR)
	$(INSTALL) -d $(INSTPPD)
	#
	$(INSTALL) -m 644 $(SOURCE)/mimefx.convs $(INSTETC)/cups
	$(INSTALL) -m 644 $(SOURCE)/mimefx.types $(INSTETC)/cups
	$(INSTALL) $(SOURCE)/pdftopdffx $(INSTFILT)
	$(INSTALL) $(SOURCE)/pdftopjlfx $(INSTFILT)
	$(INSTALL) $(SOURCE)/pstopdffx $(INSTFILT)
	$(INSTALL) $(SOURCE)/fxlinuxprint.ppd.gz $(INSTPPD)

clean:


#------------------------------------------------------------------ POST-INCLUDE
