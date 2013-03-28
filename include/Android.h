#ifndef VEGA_ANDROID_H
#define VEGA_ANDROID_H

// This header just includes the Android headers.

#include "VegaDefines.h"

#ifdef VEGA_ANDROID
extern "C"
{
	#include <jni.h>
	#include <errno.h>
	#include <android/log.h>
	#include <android/asset_manager.h>
	#include <android_native_app_glue.h>
	#include <EGL/egl.h>
}
#endif

#endif
