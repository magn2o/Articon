TARGET := iphone:7.0:2.0
ARCHS := armv6 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Articon
Articon_FILES = Tweak.xm
Articon_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = ArticonSettings
ArticonSettings_FILES = Preferences.m
ArticonSettings_INSTALL_PATH = /Library/PreferenceBundles
ArticonSettings_FRAMEWORKS = UIKit
ArticonSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Articon.plist$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
