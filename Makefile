#
# Copyright (c) 1999-2008 Apple Inc.  All Rights Reserved.
# 
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apple Public Source License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://www.opensource.apple.com/apsl/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#

-include /AppleInternal/ServerTools/ServerBuildVariables.xcconfig

MODULE_NAME = mod_bonjour
MODULE_SRC2 = $(MODULE_NAME)2.c
MODULE = $(MODULE_NAME).so
OTHER_SRC = 
HEADERS =
export LTFLAGS = --tag=CC
APXS2=/usr/sbin/apxs
SRCFILES = Makefile $(MODULE_SRC) $(MODULE_SRC2) $(OTHER_SRC) $(HEADERS)
INSTALLDIR = $(SERVER_INSTALL_PATH_PREFIX)/$(shell $(APXS2) -q LIBEXECDIR)

MORE_FLAGS += -Wc,"$(RC_CFLAGS) -Wmost -W -g"
MORE_FLAGS += -Wl,"$(RC_CFLAGS) -framework SystemConfiguration -framework CoreFoundation"

MAKEFILEDIR = $(MAKEFILEPATH)/pb_makefiles
include $(MAKEFILEDIR)/platform.make
include $(MAKEFILEDIR)/commands-$(OS).make

all build $(MODULE): $(MODULE_SRC) $(OTHER_SRC)
	$(APXS2) -c $(MORE_FLAGS) -o $(MODULE) $(MODULE_SRC2) $(OTHER_SRC)
 
installsrc:
	@echo "Installing source files..."
	-$(RM) -rf $(SRCROOT)$(SRCPATH)
	$(MKDIRS) $(SRCROOT)$(SRCPATH)
	$(TAR) cf - $(SRCFILES) | (cd $(SRCROOT)$(SRCPATH) && $(TAR) xf -)

installhdrs:
	@echo "Installing header files..."

install: $(MODULE)
	@echo "Installing Apache 2.2 module..."
	$(MKDIRS) $(SYMROOT)$(INSTALLDIR)
	$(CP) .libs/$(MODULE) $(SYMROOT)$(INSTALLDIR)
	$(CHMOD) 755 $(SYMROOT)$(INSTALLDIR)/$(MODULE)
	$(MKDIRS) $(DSTROOT)$(INSTALLDIR)
	$(STRIP) -x $(SYMROOT)$(INSTALLDIR)/$(MODULE) -o $(DSTROOT)$(INSTALLDIR)/$(MODULE)

clean:
	@echo "== Cleaning $(MODULE_NAME) =="
	-$(RM) -r -f .libs *.la *.lo *.slo *.o
