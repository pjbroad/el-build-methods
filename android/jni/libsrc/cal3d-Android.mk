LOCAL_PATH := $(call my-dir)

###################################################
#                      cal3d                      #
###################################################
include $(CLEAR_VARS)

LOCAL_MODULE := cal3d

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src

LOCAL_CFLAGS := -Os -fexceptions -fsigned-char
LOCAL_SRC_FILES = \
	$(subst $(LOCAL_PATH)/,, \
	$(wildcard $(LOCAL_PATH)/src/cal3d/*.cpp))

include $(BUILD_SHARED_LIBRARY)

LOCAL_EXPORT_C_INCLUDES := cal3d
