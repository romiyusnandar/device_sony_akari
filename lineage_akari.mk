#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from akari device
$(call inherit-product, device/sony/akari/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_akari
PRODUCT_DEVICE := akari
PRODUCT_MODEL := Xperia XZ2
PRODUCT_BRAND := Sony
PRODUCT_MANUFACTURER := Sony

PRODUCT_GMS_CLIENTID_BASE := android-sony-mobile
