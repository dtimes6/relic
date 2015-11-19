#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#

.SILENT:

COMPONENT=$(shell pwd | sed 's,$(ROOT),,' | sed 's,^/,,')
APPMK=$(APPSRC)/$(basename $(APP_SRC)).mk
APPOBJ=$(APP_OBJ)/$(basename $(APP_SRC)).o
TARGET=$(APP_BIN)/$(basename $(APP_SRC)).exe

include $(APPMK)

DLIBS=$(foreach lib,$(LIBS),$(APP_DST)/$(lib)/libRelic$(if $(shell basename $(lib)) = '.',$(COMPONENT),$(shell basename $(lib))).a)

LLIBS=$(foreach lib,$(LIBS),-L $(APP_DST)/$(lib) -lRelic$(if $(shell basename $(lib)) = '.',$(COMPONENT),$(shell basename $(lib))))

$(TARGET): $(APPOBJ) $(DLIBS)
	@echo "[LN]  $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) $(CXXFLAGS) -o $@ $< $(LLIBS) $(ELIBS) $(LOCALLIBS) $(LDFLAGS)

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
