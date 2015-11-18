#
# Copyright(C) Relic Fragments 2015. All rights reserved !
#

.SILENT:

export CXXFLAGS=-O3 -DNDEBUG -pipe
export CFLAGS=-O3 -DNDEBUG -pipe

export ROOT=$(shell while [ ! -d make.relic ]; do cd ..; done; pwd)
export CONFIGURATION=debug

include $(ROOT)/make.relic/src/build.mk
