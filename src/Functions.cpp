#include "../include/Functions.h"
#include "../include/SDL.h"
#include "../include/Lua.h"
#include <iostream>
using namespace std;

lua_State *luaState;

void OnLuaError(lua_State *luaState)
{
	cerr << "Lua error: " << lua_tostring(luaState, -1) << endl;
}

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
	VegaLuaInit();
}

void VegaLuaInit()
{
	luaState = luaL_newstate(); // todo: create a new state every time a new module is executed
	luaL_openlibs(luaState);
	lua_pushcfunction(luaState, VegaCheckInput);
	lua_setglobal(luaState, "vegacheckinput");
	lua_pushcfunction(luaState, VegaSync);
	lua_setglobal(luaState, "vegasync");
	lua_pushcfunction(luaState, VegaRender);
	lua_setglobal(luaState, "vegarender");
	lua_pushcfunction(luaState, VegaClearScreen);
	lua_setglobal(luaState, "vegaclearscreen");
}

void VegaFinish()
{
	lua_close(luaState); // todo: close the current state every time a new module is executed
	SDL_Quit();
}

void VegaLoop()
{
	if (luaL_loadfile(luaState, "vega_lua/VegaMainLoop.lua") != 0)
		OnLuaError(luaState);
	else if (lua_pcall(luaState, 0, 0, 0) != 0)
		OnLuaError(luaState);
	/*
	else
	{
		lua_getglobal(luaState, "VegaMainLoop");
		lua_getfield(luaState, -1, "start");
		if (lua_pcall(luaState, 0, 0, 0) != 0)
			OnLuaError(luaState);
	}
	*/
}

/**
Called by the main loop Lua script. Answer to the input events of the application.
*/
static int VegaCheckInput(lua_State *luaState)
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
Called by the main loop Lua script. Sync to the expected frames per second.
*/
static int VegaSync(lua_State *luaState)
{
	return 0;
}

/**
Called by the main loop Lua script. Renders the available scene.
*/
static int VegaRender(lua_State *luaState)
{
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
	return 0;
}

/**
Called by the main loop Lua script. Clear the screen.
*/
static int VegaClearScreen(lua_State *luaState)
{
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
	return 0;
}
