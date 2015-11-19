#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#
#  make directory
# 
# if configure file exist do ./configure first
# if Makefile exist do this makefile else call make lib
#

export DIRSRC = $(shell pwd)

app: lib
	@if [ ! -f Makefile  ]; then                       \
	    ${MAKE} -C $(DIRSRC) -f $(MK_ROOT)/app.mk app; \
	 fi

lib: external
	@if [ -f configure ]; then                         \
		./configure;                                   \
	 fi
	@if [ -f Makefile  ]; then                         \
		${MAKE} -f Makefile;                           \
	 else                                              \
	    ${MAKE} -C $(DIRSRC) -f $(MK_ROOT)/lib.mk lib; \
	 fi

-include include.make

external:
	@for item in $(EXTERNAL);                          \
	do                                                 \
	  if [ -d $$item ]; then                           \
		${MAKE} -C $$item -f $(MK_ROOT)/lib.mk lib;    \
	  fi                                               \
	done

COMPONENT=$(shell pwd | sed 's,$(ROOT),,' | sed 's,^/,,')
APP_OBJ=$(OBJ)/$(COMPONENT)
APP_DST=$(DST)/$(COMPONENT)
APP_BIN=$(BIN)/$(COMPONENT)

clean:
	@if [ -f Makefile  ]; then                         \
		${MAKE} -f Makefile clean;                     \
	 else                                              \
	    rm -rf $(APP_OBJ);                             \
	    rm -rf $(APP_DST);                             \
	    rm -rf $(APP_BIN);                             \
	 fi 

.PHONY: directory external