#ifndef VEGA_CAPI_H
#define VEGA_CAPI_H

#include "VegaDefines.h"
#include "Android.h"
#include "Lua.h"
#include "Texture.h"
#include "SceneRender.h"

#include <list>

namespace vega
{
	/**
	The bridge API between C and Lua.
	*/
	class CApi
	{
	public:
		static CApi* GetInstance();
		static void ReleaseInstance();
		virtual ~CApi();
		void Init();
		lua_State* GetLuaState();

#ifdef VEGA_ANDROID
		void SetAndroidApp(android_app* androidApp);
#endif

	private:
		CApi();

		// functions available on Lua code:
		static int CheckInputLuaFunction(lua_State *luaState);
		static int SyncBeginLuaFunction(lua_State *luaState);
		static int SyncEndLuaFunction(lua_State *luaState);
		static int RenderLuaFunction(lua_State *luaState);
		static int ClearScreenLuaFunction(lua_State *luaState);
		static int ScreenSizeLuaFunction(lua_State *luaState);
		static int LoadTextureLuaFunction(lua_State *luaState);
		static int ReleaseTexturesLuaFunction(lua_State *luaState);

		void InitApp();
		void OnRenderFinished();
		void GetScreenSize(int *w, int *h);
		void SetExecutingFieldToFalse();
		void AddTouchPointToList(std::string listFieldName, int x, int y, int previousX, int previousY);
		void CreateTouchPointLuaObject(int x, int y, int previousX, int previousY);

		static CApi* instance;
		lua_State *luaState;
		vega::SceneRender sceneRender;
		std::list<Texture*> textures;
		long startFrameTime;
		int mouseX, mouseY;
		bool wasMouseClicked;

#ifdef VEGA_WINDOWS
		void InitSDL();
		int CheckInputOnWindows();
#endif
#ifdef VEGA_ANDROID
		void InitLuaSearches();
		void InitAndroidVideo();
		int CheckInputOnAndroid();
		static void OnAndroidCommand(struct android_app* androidApp, int32_t cmd);

		// functions used on Lua code to load scripts:
		static int SearchModuleInAssetsLuaFunction(lua_State*);
		static int LoadModuleFromAssetsLuaFunction(lua_State*);

		// helper functions used by the Android Lua functions:
		static std::string SearchAssetOnDir(std::string dirName, std::string assetName);

		android_app* androidApp;
		
		EGLSurface eglSurface;
		EGLDisplay eglDisplay;
#endif
	};
}

#endif
