#ifndef VEGA_APP_H
#define VEGA_APP_H

#include "Android.h"
#include "Lua.h"
#include "SceneRender.h"
#include "Texture.h"
#include <string>
#include <list>

namespace vega
{
	/**
	The Vega app. Initializes the LUA, video, window, resources, etc., and runs the main loop.
	All the initializations occurs on constructor. The creation of an App instance is mandatory,
	because it does the bridge between the C code and the Lua code, generating the Lua C API dinamically.
	After creates an instance, call the LoadAndExecuteScript to load and execute a Lua script. The
	destructor shuts down the resources and libraries. The creation, script execution and destruction
	can be automatically called with the INITAPP macro.
	*/
	class App
	{
	public:
#ifdef VEGA_ANDROID
		App(android_app* androidApp);
#else
		App();
#endif
		virtual ~App();
		void LoadAndExecuteScript(std::string scriptName);
	
	private:
		static App* appInstance;
		lua_State* luaState;
		long startFrameTime;
		vega::SceneRender sceneRender;
		std::list<Texture*> textures;
		int mouseX, mouseY;
		bool wasMouseClicked;

		void InitLua();
		void UpdateContextWithInputState(lua_State* luaState);
		void AddTouchPointToList(lua_State* luaState, std::string listFieldName, int x, int y, int previousX, int previousY);
		void CreateTouchPointLuaObject(lua_State* luaState, int x, int y, int previousX, int previousY);
		void GetScreenSize(int *w, int *h);
		void OnRenderFinished();

		static int CheckInputLuaFunction(lua_State *luaState);
		static int SyncBeginLuaFunction(lua_State *luaState);
		static int SyncEndLuaFunction(lua_State *luaState);
		static int RenderLuaFunction(lua_State *luaState);
		static int ClearScreenLuaFunction(lua_State *luaState);
		static int ScreenSizeLuaFunction(lua_State *luaState);
		static int LoadTextureLuaFunction(lua_State *luaState);
		static int ReleaseTexturesLuaFunction(lua_State *luaState);

		static void SetExecutingFieldToFalse(lua_State* luaState);

#ifdef VEGA_WINDOWS
		void InitSDLApp();
		static void CheckInputOnSDL(lua_State* luaState);
#endif
#ifdef VEGA_ANDROID
	public:
		static std::string* _initialScriptName;
	
	private:
		android_app* androidApp;
		EGLSurface eglSurface;
		EGLDisplay eglDisplay;

		void InitAndroidApp(android_app* androidApp);
		void InitAndroidVideo();
		static void CheckInputOnAndroid(lua_State* luaState);
		static void OnAndroidCommand(struct android_app* androidApp, int32_t cmd);
#endif
	};
}

#ifdef VEGA_WINDOWS
#define INITAPP(scriptName) \
	int main(int argc, char** argv) \
	{ \
		vega::App app; \
		app.LoadAndExecuteScript(scriptName); \
		return 0; \
	}
#endif

#ifdef VEGA_ANDROID
#define INITAPP(scriptName) vega::App::_initialScriptName = new std::string(scriptName)
#endif

#endif
