#include "../include/Functions.h"
#include "../include/SDL.h"
#include "../include/Lua.h"
#include "../include/SceneRender.h"
#include <iostream>
#include <ctime>
using namespace std;
using namespace vega;

lua_State* luaState;
time_t startFrameTime;
SceneRender sceneRender;

/**
Default handler to lua errors.
*/
void OnLuaError(lua_State* luaState)
{
	cerr << "Lua error: " << lua_tostring(luaState, -1) << endl;
}

/**
Called to initialize the engine.
*/
void VegaInit()
{
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
	VegaLuaInit();
}

/**
Called to initialize the Lua scripts of the engine.
*/
void VegaLuaInit()
{
	luaState = luaL_newstate();
	luaL_openlibs(luaState);
	lua_pushcfunction(luaState, VegaCheckInput);
	lua_setglobal(luaState, "vegacheckinput");
	lua_pushcfunction(luaState, VegaSyncEnd);
	lua_setglobal(luaState, "vegasyncend");
	lua_pushcfunction(luaState, VegaSyncBegin);
	lua_setglobal(luaState, "vegasyncbegin");
	lua_pushcfunction(luaState, VegaRender);
	lua_setglobal(luaState, "vegarender");
	lua_pushcfunction(luaState, VegaClearScreen);
	lua_setglobal(luaState, "vegaclearscreen");
	lua_pushcfunction(luaState, VegaScreenSize);
	lua_setglobal(luaState, "vegascreensize");
}

/**
Called to shut down the engine, after the finish of the main loop.
*/
void VegaFinish()
{
	lua_close(luaState);
	SDL_Quit();
}

/**
Executes the main loop.
*/
void VegaLoop(string startModuleScriptName)
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
static int VegaCheckInput(lua_State* luaState)
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
static int VegaSyncBegin(lua_State* luaState)
{
	startFrameTime = time(NULL);
	return 0;
}

/**
Called by the main loop Lua script, after update the frame. Sync to the expected frames per second.
On lua, call vegasyncend(framespersecond).
*/
static int VegaSyncEnd(lua_State* luaState)
{
	lua_Number fps = luaL_checknumber(luaState, 1);
	time_t synchTime = 1000 / fps;
	long waitTime = synchTime - (time(NULL) - startFrameTime);
	if (waitTime > 0)
		SDL_Delay(waitTime);
	return 0;
}

/**
Called by the main loop Lua script. Renders the available scene.
*/
static int VegaRender(lua_State* luaState)
{
	sceneRender.Render(luaState);
	return 0;
}

/**
Called by the main loop Lua script. Clear the screen.
*/
static int VegaClearScreen(lua_State* luaState)
{
	sceneRender.Render(NULL);
	return 0;
}

/**
Return two values to the Lua call: the width and height of the screen.
*/
static int VegaScreenSize(lua_State* luaState)
{
	lua_pushnumber(luaState, SDL_GetVideoSurface()->w);
	lua_pushnumber(luaState, SDL_GetVideoSurface()->h);
	return 2;
}