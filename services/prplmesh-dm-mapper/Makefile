include $(TOPDIR)/rules.mk

PKG_NAME:=prplmesh-dm-mapper
PKG_VERSION:=v0.4.x
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=PPM-4234
PKG_SOURCE_URL:=https://gitlab.com/prpl-foundation/prplmesh/prplmesh-dm-mapper.git
PKG_MIRROR_HASH:=skip
PKG_BUILD_DIR:=$(BUILD_DIR)/prplmesh-dm-mapper-v0.4.x


include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk
CMAKE_INSTALL:=1

CMAKE_OPTIONS += \
        -DPRPLMESH_DM_MAPPER_START_ORDER=$(CONFIG_PRPLMESH_DM_MAPPER_START_ORDER) \
        -DPRPLMESH_DM_MAPPER_STOP_ORDER=$(CONFIG_PRPLMESH_DM_MAPPER_STOP_ORDER)

define Package/$(PKG_NAME)
	CATEGORY:=prpl Foundation
	TITLE:=prplmesh-dm-mapper
	MAINTAINER:=Inango <support@inango-systems.com>

	DEPENDS += +mod-amxb-ubus
	DEPENDS += +mod-amxb-usp
	DEPENDS += +libamxb
	DEPENDS += +libamxc
	DEPENDS += +libamxp
	DEPENDS += +libamxrt
	DEPENDS += +libamxd
	DEPENDS += +libamxo
	DEPENDS += +libsahtrace
endef

define Package/$(PKG_NAME)/description
prplmesh-dm-manager - main component for data model mapping
endef

define Package/$(PKG_NAME)/install
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	if [ -d ./files ]; then \
		$(CP) ./files/* $(1)/; \
	fi
endef

define Package/$(PKG_NAME)/config
        source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
