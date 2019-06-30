################################################################################
#
# microork
#
################################################################################

MICROORK_VERSION = d59e0a7
MICROORK_SITE = https://github.com/tweakoz/micro_ork.git
MICROORK_SITE_METHOD = git
MICROORK_LICENSE = MIT
MICROORK_LICENSE_FILES = LICENSE.txt
MICROORK_INSTALL_STAGING = YES
MICROORK_INCLUDE_DIR = $(STAGING_DIR)/usr/include/ork

define MICROORK_BUILD_CMDS
		cd $(@D); $(@D)/ork.build/bin/ork.build.int_env.py --embedded --cxx $(TARGET_CXX) --exec "make all"
endef


define MICROORK_INSTALL_STAGING_CMDS
	mkdir -p $(MICROORK_INCLUDE_DIR)
  cp -dpfr $(@D)/stage/include/ork/* $(MICROORK_INCLUDE_DIR)/
	$(INSTALL) -D -m 0755 $(@D)/stage/lib/libork.core.IX.release.so $(STAGING_DIR)/usr/lib/libork.core.IX.release.so.$(MICROORK_VERSION)
  ln -sf libork.core.IX.release.so.$(MICROORK_VERSION) $(STAGING_DIR)/usr/lib/libork.core.IX.release.so
endef


define MICROORK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/stage/lib/libork.core.IX.release.so $(TARGET_DIR)/usr/lib/libork.core.IX.release.so.$(MICROORK_VERSION)
  ln -sf libork.core.IX.release.so.$(MICROORK_VERSION) $(TARGET_DIR)/usr/lib/libork.core.IX.release.so
endef

$(eval $(generic-package))
