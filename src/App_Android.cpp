#include "../include/App.h"
#include "../include/Android.h"
#include "../include/Log.h"
#include "../include/CApi.h"

// This cpp file contains some implementations of the App class available only for the Android platform.

#ifdef VEGA_ANDROID

using namespace std;
using namespace vega;

string scriptName = "undefined";

void android_main(struct android_app* state)
{
	Log::Info("Starting entry point...");
	app_dummy();
	CApi::GetInstance()->SetAndroidApp(state);
	Log::Info("Creating App instance...");
	App app;
	Log::Info("Preparing to execute script:");
	Log::Info(scriptName);
	app.Execute(scriptName);
}

extern "C"
{
	JNIEXPORT void JNICALL Java_org_vega_VegaActivity_setScriptToLoadAndExecute(JNIEnv *env, jobject obj, jstring s)
	{
		scriptName = env->GetStringUTFChars(s, 0);
	}
}

#endif // VEGA_ANDROID
