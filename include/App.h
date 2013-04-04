#ifndef VEGA_APP_H
#define VEGA_APP_H

#include "VegaDefines.h"
#include "Android.h"
#include <string>

namespace vega
{
	/**
	The entry point class. Create an instance and execute a Lua script with the Execute function.
	*/
	class App
	{
	public:
		App();
		virtual ~App();
		void Execute(std::string scriptName);

#ifdef VEGA_ANDROID
		static ANativeActivity* GetAndroidActivity();
		static void SetAndroidActivity(ANativeActivity*);
		
		static ANativeWindow* GetAndroidWindow();
		static void SetAndroidWindow(ANativeWindow*);

		static JNIEnv* GetScriptThreadJavaEnv();
		static void SetScriptThreadJavaEnv(JNIEnv*);

	private:
		static ANativeActivity* androidActivity;
		static ANativeWindow* androidWindow;
		static JNIEnv* scriptThreadJavaEnv;
#endif
	};
}

#ifdef VEGA_WINDOWS
#define EXECUTE_APP(scriptName) \
	int main(int argc, char** argv) \
	{ \
		vega::App app; \
		app.Execute(scriptName); \
		return 0; \
	}
#endif

#endif
