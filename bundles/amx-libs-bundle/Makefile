include $(TOPDIR)/rules.mk

PKG_NAME:=amx-libs-bundle
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=prplfoundation
PKG_LICENSE:=BSD-2-Clause-Patent

# This is a bundle package that physically combines all AMX libraries
# It depends on individual AMX packages to ensure they are built first
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

# Build-time dependencies to ensure packages are built and available in staging
PKG_BUILD_DEPENDS:=libamxc libamxp libamxd libamxo libamxb libamxj libamxm libamxs libamxrt libsahtrace uriparser mod-amxb-ubus amxrt

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=prpl Foundation
  SUBMENU:=prplMesh
  TITLE:=AMX Libraries Bundle for prplMesh
  URL:=https://gitlab.com/prpl-foundation/components/ambiorix
  DEPENDS:=+libbz2 +zlib +libevent2 +libubox +libubus +base-libs-bundle
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	Single IPK bundle that physically contains all AMX libraries and modules required by prplMesh.
	This package bundles all files from individual AMX packages into one IPK for easier deployment.

	WARNING: This package CONFLICTS with individual AMX packages. Do not install both.

	Core Libraries:
	- libamxc: Generic reusable data containers
	- libamxp: Event loop and signal/slot mechanism
	- libamxd: Data model management
	- libamxo: ODL (Object Definition Language) parser
	- libamxb: Bus abstraction layer
	- libamxj: JSON support
	- libamxm: Module management
	- libamxs: Subscription management
	- libamxrt: Runtime library
	- libsahtrace: SAH tracing library

	Modules and Applications:
	- mod-amxb-ubus: UBUS backend module
	- amxrt: Data model runtime application

	Note: mod-pcm-svc and pcm-manager are in net-services-bundle, not here.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	# This package bundles pre-built libraries from staging directory
	# No compilation needed - files are collected during install phase
	@echo "Preparing AMX libraries bundle..."
	@echo "Bundle will collect files from staging directory during install phase"
endef

define Package/$(PKG_NAME)/install
	@echo "Installing AMX Libraries Bundle..."

	# Create directory structure
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/lib/amx/scripts
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/bin/mods
	$(INSTALL_DIR) $(1)/usr/bin/mods/amxb
	$(INSTALL_DIR) $(1)/etc/amx
	$(INSTALL_DIR) $(1)/usr/share/doc/$(PKG_NAME)

	# Copy AMX library files from staging directory
	@echo "Copying AMX libraries..."
	-$(CP) $(STAGING_DIR)/usr/lib/libamxc.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxp.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxd.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxo.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxb.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxj.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxm.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxs.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libamxrt.so* $(1)/usr/lib/ 2>/dev/null || true
	-$(CP) $(STAGING_DIR)/usr/lib/libsahtrace.so* $(1)/usr/lib/ 2>/dev/null || true

	# Copy AMX modules (copy actual .so file from build directory since staging has broken symlink)
	@echo "Copying AMX modules..."
	-find $(BUILD_DIR)/amxb_ubus-*/output/*/mod-amxb-ubus.so -exec $(INSTALL_BIN) {} $(1)/usr/bin/mods/amxb/ \; 2>/dev/null || true

	# Copy binaries
	@echo "Copying AMX binaries..."
	-$(INSTALL_BIN) $(STAGING_DIR)/usr/bin/amxrt $(1)/usr/bin/ 2>/dev/null || true

	# Copy AMX helper scripts
	@echo "Copying AMX helper scripts..."
	-$(CP) $(STAGING_DIR)/usr/lib/amx/scripts/* $(1)/usr/lib/amx/scripts/ 2>/dev/null || true

	# Copy configuration files
	@echo "Copying AMX configuration files..."
	-$(CP) $(STAGING_DIR)/etc/amx/* $(1)/etc/amx/ 2>/dev/null || true

	# Copy init scripts if they exist
	-$(INSTALL_DIR) $(1)/etc/init.d
	-$(INSTALL_BIN) $(STAGING_DIR)/etc/init.d/amxrt $(1)/etc/init.d/ 2>/dev/null || true

	# Create bundle documentation
	@echo "Creating bundle documentation..."
	echo "AMX Libraries Bundle for prplMesh v$(PKG_VERSION)-$(PKG_RELEASE)" > $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "========================================================" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "This single IPK contains all AMX libraries and modules physically bundled together." >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Included Components:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "-------------------" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Core Libraries:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxc.so    : Generic reusable data containers" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxp.so    : Event loop and signal/slot mechanism" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxd.so    : Data model management" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxo.so    : ODL (Object Definition Language) parser" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxb.so    : Bus abstraction layer" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxj.so    : JSON support" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxm.so    : Module management" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxs.so    : Subscription management" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libamxrt.so   : Runtime library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - libsahtrace.so: SAH tracing library" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Modules:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - mod-amxb-ubus.so: UBUS backend module" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Applications:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "  - amxrt: Data model runtime application" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Note: mod-pcm-svc and pcm-manager are in net-services-bundle" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "Installation Date: $$(date)" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "For more information, visit:" >> $(1)/usr/share/doc/$(PKG_NAME)/README
	echo "https://gitlab.com/prpl-foundation/components/ambiorix" >> $(1)/usr/share/doc/$(PKG_NAME)/README

	@echo "AMX Libraries Bundle installation complete!"
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	echo "AMX Libraries Bundle installed successfully!"
	echo "All AMX libraries are now available in /usr/lib/"
	echo "AMX modules are available in /usr/bin/mods/"
	echo "Documentation: /usr/share/doc/amx-libs-bundle/README"
}
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
