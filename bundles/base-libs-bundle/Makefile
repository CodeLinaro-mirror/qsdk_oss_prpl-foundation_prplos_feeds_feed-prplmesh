include $(TOPDIR)/rules.mk

PKG_NAME:=base-libs-bundle
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=prplfoundation
PKG_LICENSE:=BSD-2-Clause-Patent

# This is a bundle package that physically combines base utility libraries
# It depends on individual library packages to ensure they are built first
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

# Build-time dependencies to ensure packages are built and available in staging
PKG_BUILD_DEPENDS:=uriparser yajl libxml2 libexpat libarchive

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=prpl Foundation
  SUBMENU:=prplMesh
  TITLE:=Base Utility Libraries Bundle for prplMesh
  URL:=https://gitlab.com/prpl-foundation/components/ambiorix
  DEPENDS:=+libbz2 +zlib +liblzma +libcap-ng
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	Single IPK bundle that contains base utility libraries required by prplMesh.
	This package bundles utility libraries into one IPK for easier deployment.

	WARNING: This package CONFLICTS with individual utility library packages.

	Included Libraries:
	- uriparser: URI parsing library
	- yajl: JSON parsing library
	- libxml2: XML parsing library
	- libexpat: XML parsing library
	- libarchive: Archive handling library

	Note: liblzma and libcap-ng are NOT included as they are already available in the OS.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	@echo "Preparing base utility libraries bundle..."
	@echo "Bundle will collect files from staging directory during install phase"
endef

define Package/$(PKG_NAME)/install
	@echo "Installing Base Utility Libraries Bundle..."

	# Create directory structure
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/share/doc/$(PKG_NAME)

	# Copy utility libraries (excluding liblzma and libcap-ng which are already in OS)
	@echo "Copying utility libraries..."
	-$(CP) $(STAGING_DIR)/usr/lib/liburiparser.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libyajl.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libxml2.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libexpat.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libarchive.so* $(1)/usr/lib/ 2>/dev/null || true

	# Create bundle documentation
	@echo "Creating bundle documentation..."
	echo "Base Utility Libraries Bundle for prplMesh v$(PKG_VERSION)-$(PKG_RELEASE)" > $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "========================================================" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "This single IPK contains base utility libraries." >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Included Libraries:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - liburiparser.so : URI parsing library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libyajl.so      : JSON parsing library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libxml2.so      : XML parsing library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libexpat.so     : XML parsing library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libarchive.so   : Archive handling library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Installation Date: $$(date)" >> $(1)/usr/share/doc/$(PKG_NAME)/README

	@echo "Base Utility Libraries Bundle installation complete!"
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "Base Utility Libraries Bundle installed successfully!"
	echo "All utility libraries are now available in /usr/lib/"
	echo "Documentation: /usr/share/doc/base-libs-bundle/README"
}
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
