LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := myglob

#LOCAL_LDLIBS    += -L$(SYSROOT)/usr/lib -ldl -llog
LOCAL_C_INCLUDES+= $(LOCAL_PATH)/include

# ajs 20091229: the line below reeks of unintended consequences
LOCAL_CFLAGS    += \
  -DANDROID \
  -D__GCC__
  
LOCAL_SRC_FILES := \
    src/glob.c

include $(BUILD_SHARED_LIBRARY)
