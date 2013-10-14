#ifndef VEGA_CAPI_H
#define VEGA_CAPI_H

#include "VegaDefines.h"
#include "Lua.h"

#include <list>

namespace vega
{
	/**
	The bridge API between C and Lua.
	*/
	class CApi
	{
	public:
		virtual ~CApi();
		lua_State* GetLuaState();

		static void Init(lua_State *luaState);

	private:
		CApi();
		
		// functions available on Lua code:
		static int CheckInputLuaFunction(lua_State *luaState);
		static int SyncBeginLuaFunction(lua_State *luaState);
		static int SyncEndLuaFunction(lua_State *luaState);
		static int RenderLuaFunction(lua_State *luaState);
		static int ClearScreenLuaFunction(lua_State *luaState);
		static int ScreenSizeLuaFunction(lua_State *luaState);
		static int SetScreenSizeLuaFunction(lua_State *luaState);
		static int LoadTextureLuaFunction(lua_State *luaState);
		static int ReleaseTexturesLuaFunction(lua_State *luaState);
		static int LoadFontMetricsLuaFunction(lua_State *luaState);
	};
}

#endif
