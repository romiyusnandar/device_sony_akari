#
# Copyright (C) 2018-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from tama-common
-include device/sony/tama-common/BoardConfigCommon.mk

DEVICE_PATH := device/sony/akari

# Display
TARGET_SCREEN_DENSITY := 440

# Kernel (Sony SDM845 Linux 5.4, 4.9 source for Lineage BSP headers)
TARGET_KERNEL_SOURCE := kernel/sony/sdm845
TARGET_KERNEL_CONFIG := tama_akari_kddi_defconfig
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel-dtb
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo-akari.img

# HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Partitions
# Reserve space for data encryption (44712771584-16384)
BOARD_USERDATAIMAGE_PARTITION_SIZE := 44712755200

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Inherit from the proprietary version
-include vendor/sony/akari/BoardConfigVendor.mk
