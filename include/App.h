#ifndef VEGAENGINE_APP_H
#define VEGAENGINE_APP_H

#include "Lua.h"
#include "SDL.h"
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
	The ExecuteMainLoop method calls the MainLoop script. The destructor shuts down the resources
	and libraries. The creation, main loop execution and destruction can be automatically called
	with the INITAPP macro.
	*/
	class App
	{
	public:
		App();
		virtual ~App();
		void ExecuteMainLoop(std::string startModuleScriptName);
	
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
		static int CheckInputLuaFunction(lua_State *luaState);
		static int SyncBeginLuaFunction(lua_State *luaState);
		static int SyncEndLuaFunction(lua_State *luaState);
		static int RenderLuaFunction(lua_State *luaState);
		static int ClearScreenLuaFunction(lua_State *luaState);
		static int ScreenSizeLuaFunction(lua_State *luaState);
		static int LoadTextureLuaFunction(lua_State *luaState);
		static int ReleaseTexturesLuaFunction(lua_State *luaState);
	};
}

#endif
