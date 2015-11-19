#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#

.SILENT:

export APPSRC = $(shell pwd)

COMPONENT=$(shell pwd | sed 's,$(ROOT),,' | sed 's,^/,,')
UNIT=$(notdir $(COMPONENT))

export APP_OBJ=$(OBJ)/$(COMPONENT)
export APP_DST=$(DST)/$(COMPONENT)
export APP_BIN=$(BIN)/$(COMPONENT)

APPSCC=$(addsuffix .cc,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.cc))))
APPSCPP=$(addsuffix .cpp,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.cpp))))
APPSCXX=$(addsuffix .cxx,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.cxx))))
APPSC=$(addsuffix .c,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.c))))

app: subapps
	@for cc in $(APPSCC);                                                 \
	 do                                                                   \
	 	mkdir -p $(APP_BIN);											  \
	 	APP_SRC=$$cc ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1; \
	 done
	@for cc in $(APPSCPP);                                                \
	 do                                                                   \
	 	mkdir -p $(APP_BIN);											  \
	 	APP_SRC=$$cc ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1; \
	 done
	 @for cc in $(APPSCXX);                                               \
	 do                                                                   \
	 	mkdir -p $(APP_BIN);											  \
	 	APP_SRC=$$cc ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1; \
	 done
	 @for cc in $(APPSC);                                                 \
	 do                                                                   \
	 	mkdir -p $(APP_BIN);											  \
	 	APP_SRC=$$cc ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1; \
	 done
	 
subapps:
	@for item in $(shell ls $(APPSRC));                                        \
	 do                                                                        \
	     if [ -d $(APPSRC)/$$item ]; then                                      \
	         ${MAKE} -C $(APPSRC)/$$item -f $(MK_ROOT)/directory.mk app;       \
	     fi                                                                    \
	 done

.PHONY: app subapps
