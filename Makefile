#
# Copyright (C) 2007-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tinc
PKG_VERSION:=1.1pre17
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_URL:=http://tinc-vpn.org/packages
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_HASH:=61b9c9f9f396768551f39216edcc41918c65909ffd9af071feb3b5f9f9ac1c27
PKG_CONFIG_DEPENDS:=zlib lzo openssl
PKG_BUILD_DEPENDS:=zlib lzo openssl
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinc
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-tun +liblzo +libopenssl +librt +zlib
  TITLE:=VPN tunneling daemon
  URL:=http://www.tinc-vpn.org/
# MAINTAINER:=Saverio Proto <zioproto@gmail.com>
  MAINTAINER:=Anton Voyl <awiouy@gmail.com>
  SUBMENU:=VPN
endef

define Package/tinc/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--disable-curses \
	--disable-readline \
	--with-lzo-include="$(STAGING_DIR)/usr/include/lzo" \
	--with-zlib="$(STAGING_DIR)/usr"

define Package/tinc/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tinc $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tincd $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/sptps_speed $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/$(PKG_NAME).config $(1)/etc/config/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/tinc
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DATA) files/tinc.upgrade $(1)/lib/upgrade/keep.d/tinc
endef

MAKE_PATH:=src
define Build/Compile
	$(call Build/Compile/Default)
	$(call Build/Compile/Default,sptps_speed)
endef


define Package/tinc/conffiles
/etc/config/tinc
endef

$(eval $(call BuildPackage,tinc))
