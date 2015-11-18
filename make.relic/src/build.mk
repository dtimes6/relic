#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#

.SILENT:

export MK_ROOT=$(ROOT)/make.relic/src

ROOT_COMPONENT_=$(shell pwd | sed "s,$(ROOT),," | sed "s,^/,,")
export ROOT_COMPONENT=$(if $(ROOT_COMPONENT_),$(ROOT_COMPONENT_),.)

export SRC=$(shell pwd)
export OBJ=$(ROOT)/build/obj/$(CONFIGURATION)
export DST=$(ROOT)/build/lib/$(CONFIGURATION)
export BIN=$(ROOT)/build/bin/$(CONFIGURATION)

all: overview apps

overview:
	@echo "[TOP] $(ROOT_COMPONENT) {"
	@echo "  ROOT=$(ROOT)"
	@echo "  CONFIGURATION=$(CONFIGURATION)"
	@echo "  SRC=$(SRC)"
	@echo "  OBJ=$(OBJ)"
	@echo "  DST=$(DST)"
	@echo "  BIN=$(BIN)"
	@echo "}"

apps: libs
	@if [ ! $(ROOT_COMPONENT) = '.' ]; then                                                      \
		${MAKE} -C $(SRC) -f $(MK_ROOT)/directory.mk app;                                        \
	else                                                                                         \
		for dir in $(shell ls $(SRC)); do                                                        \
			[ $$dir = "make.relic" ] && continue;                                                \
			[ $$dir = "build" ] && continue;                                                     \
		    [ -d $(SRC)/$$dir ] && ${MAKE} -C $(SRC)/$$dir -f $(MK_ROOT)/directory.mk app;       \
		done                                                                                     \
	fi
	
libs:
	@if [ ! $(ROOT_COMPONENT) = '.' ]; then                                                      \
		${MAKE} -C $(SRC) -f $(MK_ROOT)/directory.mk lib;                                        \
	else                                                                                         \
		for dir in $(shell ls $(SRC)); do                                                        \
			[ $$dir = "make.relic" ] && continue;                                                \
			[ $$dir = "build" ] && continue;                                                     \
		    [ -d $(SRC)/$$dir ] && ${MAKE} -C $(SRC)/$$dir -f $(MK_ROOT)/directory.mk lib;       \
		done                                                                                     \
	fi

clean:
	@if [ ! $(ROOT_COMPONENT) = '.' ]; then                                                      \
		${MAKE} -C $(SRC) -f $(MK_ROOT)/directory.mk clean;                                      \
	else                                                                                         \
		for dir in $(shell ls $(SRC)); do                                                        \
			[ $$dir = "make.relic" ] && continue;                                                \
			[ $$dir = "build" ] && continue;                                                     \
		    [ -d $(SRC)/$$dir ] && ${MAKE} -C $(SRC)/$$dir -f $(MK_ROOT)/directory.mk clean;     \
		done                                                                                     \
	fi
	
.PHONY: all overview apps libs
