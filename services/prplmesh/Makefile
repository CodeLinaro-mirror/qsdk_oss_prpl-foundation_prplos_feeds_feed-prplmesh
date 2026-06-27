include $(TOPDIR)/rules.mk

PKG_NAME:=prplmesh
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=6.0.0
PKG_SOURCE_URL:=https://gitlab.com/prpl-foundation/prplmesh/prplMesh.git
PKG_MIRROR_HASH:=c5745a3b37e7f0d341b2bfbb5bea8850a73d0e257d74a9bf2709ee380a2383b8
PKG_SOURCE_DATE:=2026-06-04
PKG_MAINTAINER:=Cihangir Odabas <cihangir.odabas@prplfoundation.org>
PKG_LICENSE:=BSD-2-Clause-Patent
PKG_LICENSE_FILES:=LICENSE
PKG_SOURCE_SUBMODULES:=skip

PRPLMESH_VERSION:=$(subst -,.,$(PKG_SOURCE_DATE))
PRPLMESH_REVISION:=$(PKG_SOURCE_VERSION)

PKG_BUILD_PARALLEL:=1
PKG_CONFIG_DEPENDS:= \
	CONFIG_WIRELESS_STA \
	CONFIG_TARGET_intel_x86 \
	CONFIG_TARGET_intel_mips \
	CONFIG_TARGET_brcmbca \
	CONFIG_USE_PRPLMESH_WHM \
	CONFIG_PRPLMESH_ENABLE_UNIT_TESTS \
	CONFIG_PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND \
	CONFIG_PRPLMESH_ENABLE_MQTT

CMAKE_BINARY_SUBDIR:=build

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/prplmesh/default
	SECTION:=net
	CATEGORY:=prpl Foundation
	SUBMENU:=prplMesh
	TITLE:=prplmesh
	URL:=https://gitlab.com/prpl-foundation/prplmesh/prplMesh/-/blob/master/README.md
	MAINTAINER:=prplfoundation
endef

define Package/prplmesh
	$(Package/prplmesh/default)
	DEPENDS:= \
		+libstdcpp \
		+libpthread \
		+librt \
		+libjson-c \
		+libopenssl \
		+libnl \
		+uci \
		+ubus \
		+ubox \
		+ebtables \
        +libpcap
#	MQTT dependency
	DEPENDS+= \
		+PRPLMESH_ENABLE_MQTT:libmosquitto \
		+PRPLMESH_ENABLE_MQTT:mosquitto
#	intel_mips and intel_x86 specific dependencies:
	DEPENDS+= \
		+TARGET_intel_mips:dwpal_6x-uci \
		+TARGET_intel_mips:iwlwav-hostap-uci \
		+TARGET_intel_mips:libsafec3 \
		+TARGET_intel_mips:bridge-ugw \
		+(TARGET_intel_x86&&PACKAGE_mod-whm):dwpal_6x-uci-osp \
		+(TARGET_intel_x86&&PACKAGE_mod-whm):iwlwav-hostap-ng-uci \
		+(TARGET_intel_x86&&PACKAGE_mod-whm-debug):dwpal_6x-uci-osp-debug \
		+(TARGET_intel_x86&&PACKAGE_mod-whm-debug):iwlwav-hostap-ng-uci-debug \
		+TARGET_intel_x86:libsafec3 \
		+TARGET_intel_x86:bridge
#	non-intel_x86 and non-intel_mips:
	DEPENDS+= \
		+!(TARGET_intel_x86||TARGET_intel_mips):kmod-sched-act-vlan \
		+!(TARGET_intel_x86||TARGET_intel_mips):kmod-sched-core \
		+!(TARGET_intel_x86||TARGET_intel_mips):kmod-sched-flower \
		+!(TARGET_intel_x86||TARGET_intel_mips):kmod-sched-prio 
#	non-intel_x86 neither non-intel_mips neither broadcom dependencies:
	DEPENDS+= \
		+!(TARGET_intel_x86||TARGET_intel_mips||TARGET_brcmbca||TARGET_ipq95xx||TARGET_ipq53xx||TARGET_ipq54xx||TARGET_ipq96xx||TARGET_ipq52xx):hostapd-openssl \
		+!(TARGET_intel_x86||TARGET_intel_mips||TARGET_brcmbca||TARGET_ipq95xx||TARGET_ipq53xx||TARGET_ipq54xx||TARGET_ipq96xx||TARGET_ipq52xx):wpa-supplicant-openssl
	DEPENDS+= \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&USE_PRPLMESH_NLHAL):amx-libs-bundle \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&USE_PRPLMESH_NLHAL):net-services-bundle \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&!USE_PRPLMESH_NLHAL):libamxb \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&!USE_PRPLMESH_NLHAL):libamxrt \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&!USE_PRPLMESH_NLHAL):mod-pcm-svc \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&!USE_PRPLMESH_NLHAL):pcm-manager \
		+(PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND&&!USE_PRPLMESH_NLHAL):mod-amxb-ubus
#	pwhm dependency:
	DEPENDS+= +USE_PRPLMESH_WHM:pwhm
endef

define Package/prplmesh-unit-tests
	$(Package/prplmesh/default)
	TITLE+= - unit tests
	DEPENDS:=+prplmesh +@PRPLMESH_ENABLE_UNIT_TESTS
endef

define Package/prplmesh/config
	source "$(SOURCE)/Config.in"
endef

CMAKE_OPTIONS+= \
	-DTARGET_PLATFORM=openwrt \
	-DCMAKE_INSTALL_PREFIX=/opt/prplmesh \
	-DPLATFORM_BUILD_DIR=$(BUILD_DIR) \
	-DPLATFORM_STAGING_DIR=$(STAGING_DIR) \
	-DPLATFORM_INCLUDE_DIR=$(STAGING_DIR)/usr/include

CMAKE_OPTIONS += --log-level=STATUS

#debug symbols enabled
CMAKE_OPTIONS+= \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_C_FLAGS="-g3" \
	-DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations -g3"

ifeq ($(wildcard $(PKG_BUILD_DIR)/.source_dir),)
	CMAKE_OPTIONS += -DPRPLMESH_REVISION=$(PRPLMESH_REVISION)
	CMAKE_OPTIONS += -DPRPLMESH_VERSION=$(PRPLMESH_VERSION)
endif

CMAKE_OPTIONS+=-DPython3_EXECUTABLE=$(STAGING_DIR_HOST)/bin/python3
$(eval $(call TestHostCommand,python3-yaml, \
	Please install the Python3 YAML module, \
	$(STAGING_DIR_HOST)/bin/python3 -c 'import yaml'))

DATAELEMENTS_ROOT_DM:=$(CONFIG_PRPL_CONTROLLER_ROOT_PATH)

ifeq ($(CONFIG_PRPLMESH_ENABLE_AMBIORIX_UBUS_BACKEND),y)
	CMAKE_OPTIONS += -DENABLE_NBAPI=ON
	CMAKE_OPTIONS += -DDATAELEMENTS_ROOT_DM="$(DATAELEMENTS_ROOT_DM)"
	CMAKE_OPTIONS += -DUBUS_SOCK="-DAMBIORIX_BACKEND_PATH=\\\"/usr/bin/mods/amxb/mod-amxb-ubus.so\\\" -DAMBIORIX_BUS_URI=\\\"ubus:/var/run/ubus/ubus.sock\\\""
ifeq ($(CONFIG_USE_PRPLMESH_WHM),y)
	CMAKE_OPTIONS += -DUSE_PRPLMESH_WHM=ON
	CMAKE_OPTIONS += -DWBAPI_SOCK="-DAMBIORIX_WBAPI_BACKEND_PATH=\\\"/usr/bin/mods/amxb/mod-amxb-ubus.so\\\" -DAMBIORIX_WBAPI_BUS_URI=\\\"ubus:/var/run/ubus/ubus.sock\\\""
	CMAKE_OPTIONS += -DUSE_PRPLMESH_NLHAL=OFF
endif
endif

# if NLHAL is enabled, WHM is not enabled
ifeq ($(CONFIG_USE_PRPLMESH_NLHAL),y)
	CMAKE_OPTIONS += -DUSE_PRPLMESH_NLHAL=ON
	CMAKE_OPTIONS += -DENABLE_NBAPI=ON
	# disabling WHM
	CMAKE_OPTIONS += -DUSE_PRPLMESH_WHM=OFF
endif

ifeq ($(CONFIG_TARGET_intel_mips),y)
	CMAKE_OPTIONS+= -DBWL_TYPE=DWPAL \
		-DTARGET_PLATFORM_TYPE=ugw \
		-DCMAKE_FIND_ROOT_PATH="${STAGING_DIR}/opt/intel;${CMAKE_FIND_ROOT_PATH}"
else ifeq ($(CONFIG_TARGET_intel_x86),y)
	CMAKE_OPTIONS+= -DBWL_TYPE=WHM \
		-DTARGET_PLATFORM_TYPE=ugw \
		-DCMAKE_FIND_ROOT_PATH="${STAGING_DIR}/opt/intel;${CMAKE_FIND_ROOT_PATH}"
else ifeq ($(CONFIG_TARGET_ipq95xx),y)
		CMAKE_OPTIONS+= -DTARGET_PLATFORM_TYPE=freedom
else ifeq ($(CONFIG_TARGET_ipq807x),y)
		CMAKE_OPTIONS+= -DTARGET_PLATFORM_TYPE=haze
else ifeq ($(CONFIG_TARGET_mvebu),y)
		CMAKE_OPTIONS+= -DTARGET_PLATFORM_TYPE=turris-omnia
else
	CMAKE_OPTIONS+= -DBWL_TYPE=NL80211 \
		-DTARGET_PLATFORM_TYPE=turris-omnia
endif

ifeq ($(CONFIG_PRPLMESH_ENABLE_UNIT_TESTS),y)
	CMAKE_OPTIONS += -DBUILD_TESTS=ON
endif

ifeq ($(CONFIG_PRPLMESH_ENABLE_MQTT),y)
    CMAKE_OPTIONS += -DENABLE_MQTT=ON
else
    CMAKE_OPTIONS += -DENABLE_MQTT=OFF
endif

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(CURDIR)/files/hostapd_dep/include $(PKG_BUILD_DIR)/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/lib/libbml* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/include/beerocks/bml $(1)/usr/include/
endef

define Package/prplmesh/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/opt/prplmesh
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/etc/acl/admin
	$(INSTALL_DIR) $(1)/etc/amx/tr181-device/extensions
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d/
ifeq ($(CONFIG_USE_PRPLMESH_WHM),y)
	echo 'enable() { return 0; }' >>$(1)/etc/init.d/prplmesh
	echo 'enable() { return 0; }' >>$(1)/etc/init.d/prplmesh-agent
endif
	$(INSTALL_BIN) ./files/etc/uci-defaults/* $(1)/etc/uci-defaults/
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/bin $(1)/opt/prplmesh/
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/scripts $(1)/opt/prplmesh/
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/lib/*.so* $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/share $(1)/opt/prplmesh/
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/config $(1)/opt/prplmesh/
	if [ -f $(PKG_INSTALL_DIR)/etc/acl/admin/prplmesh.json ]; then \
		$(CP) $(PKG_INSTALL_DIR)/etc/acl/admin/prplmesh.json $(1)/etc/acl/admin/; \
	fi
	if [ -f $(PKG_INSTALL_DIR)/opt/prplmesh/config/controller/odl/01_device-wifi_prplmesh_mapping.odl ]; then \
		$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/config/controller/odl/01_device-wifi_prplmesh_mapping.odl $(1)/etc/amx/tr181-device/extensions/; \
	fi
endef

define Package/prplmesh-unit-tests/install
	$(INSTALL_DIR) $(1)/opt/prplmesh/tests
	$(CP) $(PKG_INSTALL_DIR)/opt/prplmesh/tests $(1)/opt/prplmesh/
endef

$(eval $(call BuildPackage,prplmesh))
$(eval $(call BuildPackage,prplmesh-unit-tests))
