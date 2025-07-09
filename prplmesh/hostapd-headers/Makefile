############## THIS FILE IS ONLY FOR HOSTAPD HEADER CLONNING AND IS NOT BEING COMPILED#################

#
# Copyright (c) 2015 Qualcomm Atheros, Inc.
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hostapd-headers
PKG_RELEASE:=2

PKG_SOURCE_URL:=https://w1.fi/hostap.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-03-10
PKG_SOURCE_VERSION:=95ad71157e3095c52d5212855ca232832b1b5085
PKG_MIRROR_HASH:=5d1b2299f52e30bc33cdcbbce5f55be41bb761ccb785e8dc0f47f7be9ede5053
PKG_SOURCE_SUBMODULES:=skip
PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>
PKG_LICENSE:=BSD-3-Clause
PKG_CPE_ID:=cpe:/a:w1.fi:hostapd

include $(INCLUDE_DIR)/package.mk

define Package/hostapd-headers
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Hostapd Header Files Only
URL:=http://hostap.epitest.fi/
endef

define Package/hostapd-headers/description
	Package clones hostapd and installs only the required headers.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	true
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/src/common/wpa_ctrl.c $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/common/wpa_ctrl.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/build_config.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/common.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/includes.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/os.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/os_unix.c $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/wpabuf.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/wpa_debug.h $(1)/usr/include/
endef

define Package/hostapd-headers/install
	true
endef

$(eval $(call BuildPackage,hostapd-headers))

