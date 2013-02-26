#include "../include/App.h"
#include "../include/SDL.h"
#include "../include/Lua.h"
#include "../include/SceneRender.h"
#include <iostream>
#include <ctime>
using namespace std;
using namespace vega;

/**
Default handler to lua errors.
*/
void OnLuaError(lua_State* luaState)
{
	cerr << "Lua error: " << lua_tostring(luaState, -1) << endl;
}

App* App::appInstance = NULL;

App::App()
{
	appInstance = this;
	if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
	{
		cerr << "Unable to init SDL: " << SDL_GetError() << "." << endl;
		return;
	}
	int flags = (false ? SDL_FULLSCREEN : 0) | SDL_OPENGL | SDL_DOUBLEBUF | SDL_HWSURFACE;
	SDL_SetVideoMode(800, 600, 32, flags);
	SDL_WM_GrabInput(SDL_GRAB_OFF);
	SDL_ShowCursor(true);
	SDL_WM_SetCaption("VegaEngine", NULL);
	sceneRender.Init();
	InitLua();
}

App::~App()
{
	lua_close(luaState);
	SDL_Quit();
	appInstance = NULL;
}

void App::InitLua()
{
	luaState = luaL_newstate();
	luaL_openlibs(luaState);
	lua_pushcfunction(luaState, App::CheckInputLuaFunction);
	lua_setglobal(luaState, "vegacheckinput");
	lua_pushcfunction(luaState, App::SyncEndLuaFunction);
	lua_setglobal(luaState, "vegasyncend");
	lua_pushcfunction(luaState, App::SyncBeginLuaFunction);
	lua_setglobal(luaState, "vegasyncbegin");
	lua_pushcfunction(luaState, App::RenderLuaFunction);
	lua_setglobal(luaState, "vegarender");
	lua_pushcfunction(luaState, App::ClearScreenLuaFunction);
	lua_setglobal(luaState, "vegaclearscreen");
	lua_pushcfunction(luaState, App::ScreenSizeLuaFunction);
	lua_setglobal(luaState, "vegascreensize");
}

/**
Executes the main loop.
*/
void App::ExecuteMainLoop(string startModuleScriptName)
{
	if (luaL_loadstring(luaState, "package.path = package.path..';vega_lua/?.lua;vega_lua/?'") != 0)
		OnLuaError(luaState);
	else if (lua_pcall(luaState, 0, 0, 0) != 0)
		OnLuaError(luaState);
	if (luaL_loadfile(luaState, startModuleScriptName.c_str()) != 0)
		OnLuaError(luaState);
	else if (lua_pcall(luaState, 0, 0, 0) != 0)
		OnLuaError(luaState);
	if (luaL_loadfile(luaState, "vega_lua/VegaMainLoop.lua") != 0)
		OnLuaError(luaState);
	else if (lua_pcall(luaState, 0, 0, 0) != 0)
		OnLuaError(luaState);
}

/**
Called by the main loop Lua script. Answer to the input events of the application.
On lua, call vegacheckinput(context).
*/
int App::CheckInputLuaFunction(lua_State* luaState)
{
	SDL_Event evt;
	while (SDL_PollEvent(&evt))
	{
		switch (evt.type)
		{
		case SDL_QUIT:
			lua_pushstring(luaState, "executing");
			lua_pushboolean(luaState, 0);
			lua_settable(luaState, 1); // "context" table arg
			break;
		}
	}
	return 0;
}

/**
Called by the main loop Lua script, before update the frame.
*/
int App::SyncBeginLuaFunction(lua_State* luaState)
{
	appInstance->startFrameTime = time(NULL);
	return 0;
}

/**
Called by the main loop Lua script, after update the frame. Sync to the expected frames per second.
On lua, call vegasyncend(framespersecond).
*/
int App::SyncEndLuaFunction(lua_State* luaState)
{
	lua_Number fps = luaL_checknumber(luaState, 1);
	time_t synchTime = 1000 / fps;
	long waitTime = synchTime - (time(NULL) - appInstance->startFrameTime);
	if (waitTime > 0)
		SDL_Delay(waitTime);
	return 0;
}

/**
Called by the main loop Lua script. Renders the available scene.
*/
int App::RenderLuaFunction(lua_State* luaState)
{
	appInstance->sceneRender.Render(luaState);
	return 0;
}

/**
Called by the main loop Lua script. Clear the screen.
*/
int App::ClearScreenLuaFunction(lua_State* luaState)
{
	appInstance->sceneRender.Render(NULL);
	return 0;
}

/**
Return two values to the Lua call: the width and height of the screen.
*/
int App::ScreenSizeLuaFunction(lua_State* luaState)
{
	lua_pushnumber(luaState, SDL_GetVideoSurface()->w);
	lua_pushnumber(luaState, SDL_GetVideoSurface()->h);
	return 2;
}
