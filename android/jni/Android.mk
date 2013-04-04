LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := lua-prebuilt
LOCAL_SRC_FILES := liblua.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := vega
LOCAL_CPP_FEATURES += exceptions
LOCAL_CPP_FEATURES += rtti
LOCAL_LDLIBS += -llog -landroid -ljnigraphics -lEGL -lGLESv1_CM
LOCAL_SRC_FILES := /../../src/App.cpp /../../src/App_Android.cpp /../../src/CApi.cpp /../../src/CApi_Android.cpp /../../src/Log_Android.cpp /../../src/SceneRender.cpp /../../src/Texture.cpp /../../src/Texture_Android.cpp
LOCAL_SHARED_LIBRARIES := lua-prebuilt
include $(BUILD_SHARED_LIBRARY)
