#ifndef VEGA_APP_H
#define VEGA_APP_H

#include "VegaDefines.h"
#include "Android.h"
#include "Lua.h"
#include "SceneRender.h"
#include "Texture.h"
#include "Mouse.h"
#include <string>
#include <list>

namespace vega
{
	/**
	The entry point class. Create an instance and execute a Lua script with the Execute function.
	*/
	class App
	{
	public:
		static App* GetSingleton();
		static void ReleaseSingleton();
		virtual ~App();

		void Execute(std::string scriptName);
		lua_State* GetLuaState();
		void ProcessInput();
		void OnRenderFinished();
		void GetScreenSize(int *w, int *h);
		SceneRender& GetSceneRender();
		void AddTexture(Texture*);
		void ReleaseTextures();
		void SyncBegin();
		void SyncEnd(long expectedFps);

	private:
		App();
		static App* singleton;
		lua_State* luaState;
		vega::SceneRender sceneRender;
		std::list<Texture*> textures;
		long startFrameTime;
		Mouse currentMouseState;

		void ExecuteMainLoop();
		void SetExecutingFieldToFalse();

#ifdef VEGA_WINDOWS
		void InitSDL();
		int CheckInputOnWindows();
		static MouseButton GetMouseButtonState(int sdlMouseButtonId, Uint8 sdlMouseState, MouseButton& lastMouseButtonState);
#endif

#ifdef VEGA_ANDROID
	public:
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
		EGLSurface eglSurface;
		EGLDisplay eglDisplay;

		void InitAndroid();
		void InitLuaSearches();
		int CheckInputOnAndroid();

		// functions used on Lua code to load scripts:
		static int SearchModuleInAssetsLuaFunction(lua_State*);
		static int LoadModuleFromAssetsLuaFunction(lua_State*);

		// helper functions used by the Android Lua functions:
		static std::string SearchAssetOnDir(std::string dirName, std::string assetName);
#endif
	};
}

#ifdef VEGA_WINDOWS
#define EXECUTE_APP(scriptName) \
	int main(int argc, char** argv) \
{ \
	vega::App::GetSingleton()->Execute(scriptName); \
	vega::App::ReleaseSingleton(); \
	return 0; \
}
#endif

#endif
