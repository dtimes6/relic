#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#

.SILENT:

export LIBSRC = $(shell pwd)

COMPONENT=$(shell pwd | sed 's,$(ROOT),,' | sed 's,^/,,')
UNIT=$(notdir $(COMPONENT))

LIB_OBJ=$(OBJ)/$(COMPONENT)
LIB_DST=$(DST)/$(COMPONENT)

CCOBJS=$(addprefix $(LIB_OBJ)/,$(addsuffix .o,$(filter-out $(basename $(wildcard *.mk)), $(basename $(wildcard *.cc)))))
CPPOBJS=$(addprefix $(LIB_OBJ)/,$(addsuffix .o,$(filter-out $(basename $(wildcard *.mk)), $(basename $(wildcard *.cpp)))))
CXXOBJS=$(addprefix $(LIB_OBJ)/,$(addsuffix .o,$(filter-out $(basename $(wildcard *.mk)), $(basename $(wildcard *.cxx)))))
COBJS=$(addprefix $(LIB_OBJ)/,$(addsuffix .o,$(filter-out $(basename $(wildcard *.mk)), $(basename $(wildcard *.c)))))
ARCHIVE=$(if $(CCOBJS)$(CPPOBJS)$(CXXOBJS)$(COBJS), $(LIB_DST)/libRelic$(UNIT).a, )
DEPENDENCIES=$(LIB_OBJ)/$(UNIT).d

lib: sublibs $(ARCHIVE)

-include $(DEPENDENCIES)

$(DEPENDENCIES): $(wildcard *.cpp *hpp *.cxx *.hxx *.cc *.hh *.c *.h)
	@echo "[LIB] $(COMPONENT)/$(notdir $@)"
	@rm -f $(DEPENDENCIES)
	@mkdir -p $(dir $(DEPENDENCIES))
	@$(CXX) $(CXXFLAGS) -MM *.cpp *.cxx *.cc 2>/dev/null | \
	sed 's,^\<,$(DEPENDENCIES) $(DST),' >> $(DEPENDENCIES)
	@$(CC) $(CFLAGS) -MM *.c 2>/dev/null | \
	sed 's,^\<,$(DEPENDENCIES) $(DST),' >> $(DEPENDENCIES)

$(ARCHIVE): $(CCOBJS) $(CPPOBJS) $(CXXOBJS) $(COBJS)
	@echo "[AR]  $(COMPONENT)/$(notdir $@)"
	@mkdir -p $(dir $@)
	@rm -f $@
	@if [ ! X$(CCOBJS) = "X" ]; then ar -r -c $@ $(CCOBJS) 1>/dev/null 2>&1; fi
	@if [ ! X$(CPPOBJS) = "X" ]; then ar -r -c $@ $(CPPOBJS) 1>/dev/null 2>&1; fi
	@if [ ! X$(CXXOBJS) = "X" ]; then ar -r -c $@ $(CXXOBJS) 1>/dev/null 2>&1; fi
	@if [ ! X$(COBJS) = "X" ]; then ar -r -c $@ $(COBJS) 1>/dev/null 2>&1; fi
	@ranlib $@ 1>/dev/null 2>&1

sublibs:
	@for item in $(shell ls $(LIBSRC));                                        \
	 do                                                                        \
	     if [ -d $(LIBSRC)/$$item ]; then                                      \
	         ${MAKE} -C $(LIBSRC)/$$item -f $(MK_ROOT)/directory.mk lib;       \
	     fi                                                                    \
	 done

-include include.make
CXXFLAGS+= $(INC)
CFLAGS+= $(INC)

$(CCOBJS): $(LIB_OBJ)/%.o: %.cc
	@echo "[CXX] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) -c $(CXXFLAGS) -o $@ $<

$(CPPOBJS): $(LIB_OBJ)/%.o: %.cpp
	@echo "[CXX] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) -c $(CXXFLAGS) -o $@ $<
	
$(CXXOBJS): $(LIB_OBJ)/%.o: %.cxx
	@echo "[CXX] $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CXX) -c $(CXXFLAGS) -o $@ $<	
	
$(COBJS): $(LIB_OBJ)/%.o: %.c $(LIBDEP)
	@echo "[CC]  $(COMPONENT)/$(CONFIGURATION)/$(notdir $@)"
	@rm -f $@
	@$(CC) -c $(CFLAGS) -o $@ $<
	
.PHONY: lib sublibs
