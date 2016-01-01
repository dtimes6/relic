#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#

.SILENT:

COMPONENT=$(shell pwd | sed 's,$(ROOT),,' | sed 's,^/,,')
APPMK=$(APPSRC)/$(basename $(APP_SRC)).mk
APPOBJ=$(APP_OBJ)/$(basename $(APP_SRC)).o
TARGET=$(APP_BIN)/$(basename $(APP_SRC)).exe
UNIT=$(notdir $(COMPONENT))
DEPENDENCIES=$(APP_OBJ)/$(UNIT).d

eq = $(and $(findstring $(1),$(2)),$(findstring $(2),$(1)))

include $(APPMK)

DLIBS=$(foreach lib,$(LIBS),$(APP_DST)/$(lib)/libRelic$(if $(call eq, $(shell basename $(lib)), .),$(UNIT),$(shell basename $(lib))).a)

LLIBS=$(foreach lib,$(LIBS),-L $(APP_DST)/$(lib) -lRelic$(if $(call eq, $(shell basename $(lib)), .),$(UNIT),$(shell basename $(lib))))

all: $(TARGET)

$(TARGET): $(APPOBJ) $(DLIBS)
	@echo "[LN]  $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) $(CXXFLAGS) -o $@ $< $(LLIBS) $(ELIBS) $(LOCALLIBS) $(LDFLAGS)

-include $(DEPENDENCIES)

-include include.make
CXXFLAGS+= $(INC)
CFLAGS+= $(INC)

ifneq "$(wildcard $(basename $(APP_SRC)).cc)" ""
$(APPOBJ): $(APP_SRC)
	@echo "[CXX] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) $(CXXFLAGS) -c -o $@ $(APP_SRC)
endif

ifneq "$(wildcard $(basename $(APP_SRC)).cxx)" ""
$(APPOBJ): $(APP_SRC)
	@echo "[CXX] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) $(CXXFLAGS) -c -o $@ $(APP_SRC)
endif

ifneq "$(wildcard $(basename $(APP_SRC)).cpp)" ""
$(APPOBJ): $(APP_SRC)
	@echo "[CXX] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) $(CXXFLAGS) -c -o $@ $(APP_SRC)
endif

ifneq "$(wildcard $(basename $(APP_SRC)).c)" ""
$(APPOBJ): $(APP_SRC)
	@echo "[CC] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) $(CXXFLAGS) -c -o $@ $(APP_SRC)
endif

.PHONY: all
