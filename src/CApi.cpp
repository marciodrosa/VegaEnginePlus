#include "../include/CApi.h"
#include "../include/Log.h"
#include "../include/App.h"

#include <ctime>
#include <fstream>

using namespace std;
using namespace vega;

CApi::CApi()
{
}

CApi::~CApi()
{
	Log::Info("CApi released.");
}

void CApi::Init(lua_State *luaState)
{
	Log::Info("Creating the C api instance...");
	Log::Info("Creating the capi Lua table...");
	lua_getglobal(luaState, "vega");
	lua_getfield(luaState, -1, "capi");
	
	Log::Info("Creating the Lua functions into the capi table...");
	lua_pushstring(luaState, "checkinput");
	lua_pushcfunction(luaState, CheckInputLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "syncend");
	lua_pushcfunction(luaState, SyncEndLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "syncbegin");
	lua_pushcfunction(luaState, SyncBeginLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "render");
	lua_pushcfunction(luaState, RenderLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "clearscreen");
	lua_pushcfunction(luaState, ClearScreenLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "screensize");
	lua_pushcfunction(luaState, ScreenSizeLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "setscreensize");
	lua_pushcfunction(luaState, SetScreenSizeLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "loadtexture");
	lua_pushcfunction(luaState, LoadTextureLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "releasetextures");
	lua_pushcfunction(luaState, ReleaseTexturesLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "loadfontmetrics");
	lua_pushcfunction(luaState, LoadFontMetricsLuaFunction);
	lua_settable(luaState, -3);

	lua_pop(luaState, 2);
	Log::Info("capi Lua table created.");
}

/**
Called by the main loop Lua script to process the input events.
*/
int CApi::CheckInputLuaFunction(lua_State *luaState)
{
	App::GetSingleton()->ProcessInput();
	return 0;
}

/**
Called by the main loop Lua script, before update the frame.
*/
int CApi::SyncBeginLuaFunction(lua_State *luaState)
{
	App::GetSingleton()->SyncBegin();
	return 0;
}

/**
Called by the main loop Lua script, after update the frame. Sync to the expected frames per second.
On lua, call vegasyncend(framespersecond).
*/
int CApi::SyncEndLuaFunction(lua_State *luaState)
{
	lua_Number fps = luaL_checknumber(luaState, 1);
	App::GetSingleton()->SyncEnd((long)fps);
	return 0;
}

/**
Called by the main loop Lua script. Renders the available scene.
*/
int CApi::RenderLuaFunction(lua_State *luaState)
{
	App::GetSingleton()->GetSceneRender().Render(luaState);
	App::GetSingleton()->OnRenderFinished();
	return 0;
}

/**
Called by the main loop Lua script. Clear the screen.
*/
int CApi::ClearScreenLuaFunction(lua_State *luaState)
{
	App::GetSingleton()->GetSceneRender().Render(NULL);
	App::GetSingleton()->OnRenderFinished();
	return 0;
}

/**
Updates the screen size. The args of the function are: width, heigth and a boolean to indicates
the window mode (true = window, false = fullscreen).
*/
int CApi::SetScreenSizeLuaFunction(lua_State *luaState)
{
	App::GetSingleton()->SetScreenSize(lua_tonumber(luaState, -3), lua_tonumber(luaState, -2), lua_toboolean(luaState, -1));
	return 0;
}

/**
Return three values to the Lua call: the width and height of the screen and a boolean indicating if
it is in window mode.
*/
int CApi::ScreenSizeLuaFunction(lua_State *luaState)
{
	int w, h;
	App::GetSingleton()->GetScreenSize(&w, &h);
	lua_pushnumber(luaState, w);
	lua_pushnumber(luaState, h);
	lua_pushboolean(luaState, App::GetSingleton()->IsWindowMode());
	return 3;
}

/**
Create a texture from an image file and returns a Texture object. Expected a string with the filename as input.
*/
int CApi::LoadTextureLuaFunction(lua_State *luaState)
{
	Texture* texture = Texture::Load(lua_tostring(luaState, -1));
	if (texture == NULL)
		return 0;
	else
	{
		App::GetSingleton()->AddTexture(texture);
		lua_newtable(luaState);
		lua_pushstring(luaState, "id");
		lua_pushnumber(luaState, (lua_Number) texture->GetOpenGLTextureName());
		lua_settable(luaState, -3);
		lua_pushstring(luaState, "width");
		lua_pushnumber(luaState, (lua_Number) texture->GetWidth());
		lua_settable(luaState, -3);
		lua_pushstring(luaState, "height");
		lua_pushnumber(luaState, (lua_Number) texture->GetHeight());
		lua_settable(luaState, -3);
		return 1;
	}
}

/**
Releases all textures previous loaded with the LoadTextureLuaFunction.
*/
int CApi::ReleaseTexturesLuaFunction(lua_State *luaState)
{
	App::GetSingleton()->ReleaseTextures();
	return 0;
}


/**
Loads and returns a table with font metrics. Expected a string with the filename as input.
*/
int CApi::LoadFontMetricsLuaFunction(lua_State *luaState)
{
	string filename = lua_tostring(luaState, -1);
	ifstream file(filename, ios::binary);
	if (!file)
	{
		return 0;
	}
	else
	{
		lua_newtable(luaState); // creates the metrics table
		int byte;
		int index = 0;
		while ((byte = file.get()) != EOF)
		{
			lua_pushnumber(luaState, (lua_Number)index);
			lua_pushnumber(luaState, (lua_Number)byte);
			lua_settable(luaState, -3); // sets table[index] = byte
			index++;
		}
		file.close();
		return 1;
	}
}
