#ifndef VEGAENGINE_APP_H
#define VEGAENGINE_APP_H

#include "Lua.h"
#include "SDL.h"
#include "SceneRender.h"
#include <string>

namespace vega
{
	class App
	{
	public:
		App();
		virtual ~App();
		void ExecuteMainLoop(std::string startModuleScriptName);
	
	private:
		static App* appInstance;
		lua_State* luaState;
		time_t startFrameTime;
		vega::SceneRender sceneRender;

		void InitLua();
		static int CheckInputLuaFunction(lua_State *luaState);
		static int SyncBeginLuaFunction(lua_State *luaState);
		static int SyncEndLuaFunction(lua_State *luaState);
		static int RenderLuaFunction(lua_State *luaState);
		static int ClearScreenLuaFunction(lua_State *luaState);
		static int ScreenSizeLuaFunction(lua_State *luaState);
	};
}

#endif
