#
# Copyright (C) 2018-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from akari device
$(call inherit-product, device/sony/akari/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Setup keystore
-include vendor/lineage-priv/keys/keys.mk

PRODUCT_NAME := lineage_akari
PRODUCT_DEVICE := akari
PRODUCT_MANUFACTURER := Sony
PRODUCT_BRAND := Sony
PRODUCT_MODEL := Xperia XZ2

PRODUCT_NO_CAMERA := false

AXION_CAMERA_REAR_INFO := 19
AXION_CAMERA_FRONT_INFO := 5
AXION_MAINTAINER := Asteriskxx
AXION_PROCESSOR := Snapdragon_845

TARGET_INCLUDES_LOS_PREBUILTS := true
TARGET_INCLUDE_AXFX := true
TARGET_EXCLUDES_AUDIOFX := true

TARGET_BOOT_ANIMATION_RES := 1080
TARGET_ENABLE_BLUR := true
TARGET_DISABLE_EPPE := true

PRODUCT_GMS_CLIENTID_BASE := android-sony-mobile

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="H8296-user 10 52.1.A.3.49 052001A003004902006556692 release-keys" \
    BuildFingerprint=Sony/H8296/H8296:10/52.1.A.3.49/052001A003004902006556692:user/release-keys
