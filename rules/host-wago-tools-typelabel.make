# -*-makefile-*-
# $Id: template-make 8509 2008-06-12 12:45:40Z mkl $
#
# Copyright (C) 2010 by WAGO
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_TYPELABEL) += host-typelabel

#
# Paths and names
#
HOST_TYPELABEL_VERSION		:= 1.0.0
HOST_TYPELABEL			:= typelabel
HOST_TYPELABEL_URL		:= file://$(PTXDIST_WORKSPACE)/wago_intern/$(HOST_TYPELABEL)
HOST_TYPELABEL_SRC		:= $(PTXDIST_WORKSPACE)/wago_intern/$(HOST_TYPELABEL)
HOST_TYPELABEL_DIR		:= $(HOST_BUILDDIR)/$(HOST_TYPELABEL)

HOST_TYPELABEL_PACKAGE_NAME := $(HOST_TYPELABEL)_$(HOST_TYPELABEL_VERSION)_$(PTXDIST_IPKG_ARCH_STRING)
HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR := $(PTXDIST_PLATFORMCONFIGDIR)/packages

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------
$(STATEDIR)/host-typelabel.extract: $(STATEDIR)/autogen-tools
	@$(call targetinfo)
	@$(call clean, $(HOST_TYPELABEL_DIR))
	@mkdir -p $(HOST_TYPELABEL_DIR)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
 	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE
	@rsync -a --exclude=".project" --exclude=".cproject"  $(HOST_TYPELABEL_SRC) $(HOST_BUILDDIR)
	@$(call patchin, HOST_TYPELABEL)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_TYPELABEL_PATH	:= PATH=$(HOST_PATH)
HOST_TYPELABEL_ENV 	:= $(HOST_ENV)
HOST_TYPELABEL_AUTOCONF := --prefix=/usr

$(STATEDIR)/host-typelabel.prepare: 
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
 	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE
	cd $(HOST_TYPELABEL_DIR) && sh autogen.sh
	@$(call world/prepare, HOST_TYPELABEL)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/host-typelabel.compile:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
 	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE
	@rsync -a --exclude=".project" --exclude=".cproject"  $(HOST_TYPELABEL_SRC) $(HOST_BUILDDIR)
	@$(call world/compile, HOST_TYPELABEL)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-typelabel.install:
	@$(call targetinfo)
ifndef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE
	@$(call world/install, HOST_TYPELABEL)
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_RELEASE
	# Backup headers for later use in configs/@platform@/packages
	cd $(PKGDIR)/$(HOST_TYPELABEL)/ && \
	tar -czvf $(HOST_TYPELABEL).tgz * && \
	mv $(HOST_TYPELABEL).tgz $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/
endif
endif
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	# Recover header from archive in configs/@platform@/packages
	mkdir -p $(PKGDIR)/$(HOST_TYPELABEL)
	tar -xzvf $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/$(HOST_TYPELABEL).tgz -C $(PKGDIR)/$(HOST_TYPELABEL)
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-typelabel.targetinstall:
	@$(call targetinfo)
	@$(call install_init, host-typelabel)
	@$(call install_fixup, host-typelabel,PRIORITY,optional)
	@$(call install_fixup, host-typelabel,SECTION,base)
	@$(call install_fixup, host-typelabel,AUTHOR,"WAGO <www.WAGO.com>")
	@$(call install_fixup, host-typelabel,DESCRIPTION,missing)
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_BINARIES
	# Extract precompiled binaries from archive
	rm -rf $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/tmp/*
	cd $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/tmp && \
	ar -xov $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/$(HOST_TYPELABEL_PACKAGE_NAME).ipk
	@$(call install_archive, typelabel, 0, 0, $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/tmp/data.tar.gz, /)
else
	# WAGO_TOOLS_BUILD_VERSION_TRUNK | WAGO_TOOLS_BUILD_VERSION_RELEASE
	@$(call install_copy, typelabel, 0, 0, 0755, -, /usr/lib/libtypelabel.so)
endif
	@$(call install_finish, host-typelabel)
ifdef PTXCONF_WAGO_TOOLS_BUILD_VERSION_RELEASE
	# Backup binaries in configs/@platform@/packages/
	cp $(PKGDIR)/$(HOST_TYPELABEL_PACKAGE_NAME).ipk $(HOST_TYPELABEL_PLATFORMCONFIGPACKAGEDIR)/
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/host-typelabel.clean:
	@$(call targetinfo)
	@$(call clean_pkg, HOST_TYPELABEL)
	@-rm -rf $(HOST_TYPELABEL_DIR)

# vim: syntax=make
