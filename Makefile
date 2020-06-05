THEOS_DEVICE_IP=192.168.1.4

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IconLabelColor

IconLabelColor_FILES = Tweak.xm
IconLabelColor_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
