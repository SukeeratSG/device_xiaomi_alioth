#
# Copyright (C) 2021 The Havoc-OS
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from alioth device

$(call inherit-product, device/xiaomi/alioth/device.mk)


# Inherit some common Havoc-OS stuff.

$(call inherit-product, vendor/havoc/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.

PRODUCT_NAME := havoc_alioth
PRODUCT_DEVICE := alioth
PRODUCT_BRAND := POCO
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := POCO F3
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

# Extra Flags

TARGET_SCREEN_DENSITY := 450
TARGET_BOOT_ANIMATION_RES := 1080
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

