#include "../include/App.h"
#include "../include/Android.h"
#include "../include/Log.h"

// This cpp file contains some implementations of the App class available only for the Android platform.

#ifdef VEGA_ANDROID

using namespace std;
using namespace vega;

string scriptName = "undefined";

void android_main(struct android_app* state)
{
	app_dummy();
	if (App::_initialScriptName != NULL)
	{
		Log::Info("Starting entry point");
		App app;
		app.SetVegaApp(state);
		Log::Info("Preparing to execute script:");
		Log::Info(scriptName);
		app.Execute(scriptName);
	}
}

extern "C"
{
	JNIEXPORT void JNICALL Java_org_vega_VegaActivity_setScriptToLoadAndExecute(JNIEnv *env, jobject obj, jstring s)
	{
		scriptName = env->GetStringUTFChars(s, 0);
	}
}

#endif // VEGA_ANDROID
