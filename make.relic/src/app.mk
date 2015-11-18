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

CCAPPS=$(addprefix $(APP_BIN)/,$(addsuffix .exe,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.cc)))))
CPPAPPS=$(addprefix $(APP_BIN)/,$(addsuffix .exe,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.cpp)))))
CXXAPPS=$(addprefix $(APP_BIN)/,$(addsuffix .exe,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.cxx)))))
CAPPS=$(addprefix $(APP_BIN)/,$(addsuffix .exe,$(filter $(basename $(wildcard *.mk)), $(basename $(wildcard *.c)))))

app: subapps $(CCAPPS) $(CPPAPPS) $(CXXAPPS) $(CAPPS)

$(CCAPPS): $(APP_BIN)/%.exe: %.cc
	@echo "[BIN] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@mkdir -p $(dir $@)
	@rm -f $@
	@APP_SRC=$< ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1;

$(CPPAPPS): $(APP_BIN)/%.exe: %.cpp
	@echo "[BIN] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@mkdir -p $(dir $@)
	@rm -f $@
	@APP_SRC=$< ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1;

$(CXXAPPS): $(APP_BIN)/%.exe: %.cxx
	@echo "[BIN] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@mkdir -p $(dir $@)
	@rm -f $@
	@APP_SRC=$< ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1;

$(CAPPS): $(APP_BIN)/%.exe: %.c
	@echo "[BIN] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@mkdir -p $(dir $@)
	@rm -f $@
	@APP_SRC=$< ${MAKE} -C $(APPSRC) -f $(MK_ROOT)/exe.mk || exit 1;


subapps:
	@for item in $(shell ls $(APPSRC));                                        \
	 do                                                                        \
	     if [ -d $(APPSRC)/$$item ]; then                                      \
	         ${MAKE} -C $(APPSRC)/$$item -f $(MK_ROOT)/directory.mk app;       \
	     fi                                                                    \
	 done

.PHONY: app subapps
