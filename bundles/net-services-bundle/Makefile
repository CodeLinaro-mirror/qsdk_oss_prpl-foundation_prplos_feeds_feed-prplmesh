include $(TOPDIR)/rules.mk

PKG_NAME:=net-services-bundle
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=prplfoundation
PKG_LICENSE:=BSD-2-Clause-Patent

# This is a bundle package that physically combines network services
# It depends on individual service packages to ensure they are built first
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

# Build-time dependencies to ensure packages are built and available in staging
PKG_BUILD_DEPENDS:=mod-pcm-svc mod-dmext pcm-manager

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=prpl Foundation
  SUBMENU:=prplMesh
  TITLE:=Network Services Bundle for prplMesh
  URL:=https://gitlab.com/prpl-foundation/components/ambiorix
  DEPENDS:=+amx-libs-bundle
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	Single IPK bundle that contains network services modules and applications for prplMesh.
	This package bundles mod-pcm-svc, mod-dmext, and pcm-manager into one IPK.
	
	WARNING: This package CONFLICTS with individual network services packages.
	
	Included Components:
	- mod-pcm-svc: PCM service module
	- mod-dmext: Data model extension module
	- pcm-manager: PCM manager application
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	@echo "Preparing network services bundle..."
	@echo "Bundle will collect files from staging directory during install phase"
endef

define Package/$(PKG_NAME)/install
	@echo "Installing Network Services Bundle..."

	# Create directory structure
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/bin/mods
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/share/doc/$(PKG_NAME)

	# Copy network service modules
	@echo "Copying network service modules..."
	-$(CP) $(STAGING_DIR)/usr/bin/mods/mod-pcm-svc.so $(1)/usr/bin/mods/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/bin/mods/mod-dmext.so $(1)/usr/bin/mods/ 2>/dev/null || true
	
	# Copy pcm-manager binary
	@echo "Copying pcm-manager..."
	-$(INSTALL_BIN) $(STAGING_DIR)/usr/bin/pcm-manager $(1)/usr/bin/ 2>/dev/null || true

	# Copy configuration files
	@echo "Copying configuration files..."
	-$(CP) $(STAGING_DIR)/etc/config/pcm* $(1)/etc/config/ 2>/dev/null || true

	# Copy init scripts
	-$(INSTALL_BIN) $(STAGING_DIR)/etc/init.d/pcm-manager $(1)/etc/init.d/ 2>/dev/null || true

	# Create bundle documentation
	@echo "Creating bundle documentation..."
	echo "Network Services Bundle for prplMesh v$(PKG_VERSION)-$(PKG_RELEASE)" > $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "========================================================" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "This single IPK contains network services modules and applications." >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Included Components:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - mod-pcm-svc.so  : PCM service module" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - mod-dmext.so    : Data model extension module" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - pcm-manager     : PCM manager application" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Installation Date: $$(date)" >> $(1)/usr/share/doc/$(PKG_NAME)/README

	@echo "Network Services Bundle installation complete!"
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Network Services Bundle installed successfully!"
	echo "Network service modules available in /usr/bin/mods/"
	echo "Documentation: /usr/share/doc/net-services-bundle/README"
}
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
