#include "../include/App.h"
#include "../include/Android.h"
#include "../include/Log.h"
#include "../include/CApi.h"

// This cpp file contains some implementations of the App class available only for the Android platform.

#ifdef VEGA_ANDROID

using namespace std;
using namespace vega;

ANativeActivity* App::androidActivity = NULL;

ANativeWindow* App::androidWindow = NULL;

JNIEnv* App::scriptThreadJavaEnv = NULL;

/**
Returns the Android activity instance.
*/
ANativeActivity* App::GetAndroidActivity()
{
	return androidActivity;
}

/**
Sets the Android activity instance.
*/
void App::SetAndroidActivity(ANativeActivity* activity)
{
	androidActivity = activity;
}

/**
Returns the window instance related to the Android activity.
*/
ANativeWindow* App::GetAndroidWindow()
{
	return androidWindow;
}

/**
Sets the window instance related to the Android activity.
*/
void App::SetAndroidWindow(ANativeWindow* window)
{
	androidWindow = window;
}

/**
Returns the JNIEnv of the thread that is running the Lua scripts.
*/
JNIEnv* App::GetScriptThreadJavaEnv()
{
	return scriptThreadJavaEnv;
}

/**
Sets the JNIEnv of the thread that is running the Lua scripts.
*/
void App::SetScriptThreadJavaEnv(JNIEnv* env)
{
	scriptThreadJavaEnv = env;
}

extern "C"
{
	void onAndroidNativeWindowCreated(ANativeActivity* activity, ANativeWindow* window)
	{
		App::SetAndroidWindow(window);
		Log::Info("Native window created. Starting the script thread...");

		jobject javaActivityObject = activity->clazz;
		jmethodID executeScriptThreadMethodId = activity->env->GetMethodID(activity->env->GetObjectClass(javaActivityObject), "executeScriptThread", "()V");
		activity->env->CallVoidMethod(javaActivityObject, executeScriptThreadMethodId);
	}

	void ANativeActivity_onCreate(ANativeActivity* activity, void* savedState, size_t savedStateSize)
	{
		Log::Info("Native activity created.");
		App::SetAndroidActivity(activity);
		activity->callbacks->onNativeWindowCreated = onAndroidNativeWindowCreated;
	}

	JNIEXPORT void JNICALL Java_org_vega_VegaActivity_executeAppScript(JNIEnv *env, jobject obj, jstring s)
	{
		Log::Info("Executing entry point script...");
		App::SetScriptThreadJavaEnv(env);
		Log::Info("Creating App instance...");
		App app;
		string scriptName = env->GetStringUTFChars(s, 0);
		Log::Info("Preparing to execute script:");
		Log::Info(scriptName);
		app.Execute(scriptName);
	}
}

#endif // VEGA_ANDROID
