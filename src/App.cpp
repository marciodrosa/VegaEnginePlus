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

App::App() : mouseX(0), mouseY(0), wasMouseClicked(false)
{
	appInstance = this;
	if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
	{
		cerr << "Unable to init SDL: " << SDL_GetError() << "." << endl;
		return;
	}
	int imageFlags = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF;
	if (IMG_Init(imageFlags) && imageFlags != imageFlags)
		cerr << "Warning: failed to init image libraries: " << IMG_GetError() << endl;
	int videoModeFlags = SDL_OPENGL | SDL_DOUBLEBUF | SDL_HWSURFACE;
	SDL_SetVideoMode(800, 600, 32, videoModeFlags);
	SDL_WM_GrabInput(SDL_GRAB_OFF);
	SDL_ShowCursor(true);
	SDL_WM_SetCaption("Vega", NULL);
	sceneRender.Init();
	InitLua();
}

App::~App()
{
	lua_close(luaState);
	IMG_Quit();
	SDL_Quit();
	appInstance = NULL;
}

void App::InitLua()
{
	luaState = luaL_newstate();
	luaL_openlibs(luaState);
	luaL_loadstring(luaState, "package.path = package.path..';vega_lua/?.lua;vega_lua/?'");
	lua_pcall(luaState, 0, 0, 0);
	luaL_loadstring(luaState, "require 'vega'");
	lua_pcall(luaState, 0, 0, 0);

	lua_getglobal(luaState, "vega");
	lua_getfield(luaState, -1, "capi");
	
	lua_pushstring(luaState, "checkinput");
	lua_pushcfunction(luaState, App::CheckInputLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "syncend");
	lua_pushcfunction(luaState, App::SyncEndLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "syncbegin");
	lua_pushcfunction(luaState, App::SyncBeginLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "render");
	lua_pushcfunction(luaState, App::RenderLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "clearscreen");
	lua_pushcfunction(luaState, App::ClearScreenLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "screensize");
	lua_pushcfunction(luaState, App::ScreenSizeLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "loadtexture");
	lua_pushcfunction(luaState, App::LoadTextureLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "releasetextures");
	lua_pushcfunction(luaState, App::ReleaseTexturesLuaFunction);
	lua_settable(luaState, -3);

	lua_pop(luaState, 2);
}

/**
Executes the main loop.
*/
void App::ExecuteMainLoop(string startModuleScriptName)
{
	if (luaL_loadfile(luaState, startModuleScriptName.c_str()) != 0)
		OnLuaError(luaState);
	else if (lua_pcall(luaState, 0, 0, 0) != 0)
		OnLuaError(luaState);
	if (luaL_loadfile(luaState, "vega_lua/mainloop.lua") != 0)
		OnLuaError(luaState);
	else if (lua_pcall(luaState, 0, 0, 0) != 0)
		OnLuaError(luaState);
}

/**
Updates the "input" field of the "context" table (context must be on top of the stack).
*/
void App::UpdateContextWithInputState(lua_State* luaState)
{
	// creates a new Input object and set it into the context
	lua_getglobal(luaState, "vega");
	lua_getfield(luaState, -1, "Input");
	lua_getfield(luaState, -1, "new");
	lua_call(luaState, 0, 1); // pushes the new input instance in the top of the stack
	lua_remove(luaState, -2); // removes the "Input"
	lua_remove(luaState, -2); // removes "vega"
	lua_pushstring(luaState, "input"); // stack now: context, the input instance, "input"
	lua_pushvalue(luaState, -2);  // stack now: context, the input instance, "input", the input instance again
	lua_settable(luaState, -4); // set context["input"] = the input instance; the stack now is context, then the input instance

	int newMouseX, newMouseY;
	Uint8 mouseState = SDL_GetMouseState(&newMouseX, &newMouseY);
	newMouseY = SDL_GetVideoSurface()->h - newMouseY; // to invert the Y coordinate; for vega, 0 is the bottom of the screen.

	bool isClicked = mouseState & SDL_BUTTON(1);
	bool isNewClick = isClicked && !wasMouseClicked;
	bool wasReleasedNow = !isClicked && wasMouseClicked;

	if (!wasMouseClicked)
	{
		mouseX = newMouseX;
		mouseY = newMouseY;
	}
	if (isClicked)
		AddTouchPointToList(luaState, "touchpoints", newMouseX, newMouseY, mouseX, mouseY);
	if (isNewClick)
		AddTouchPointToList(luaState, "newtouchpoints", newMouseX, newMouseY, mouseX, mouseY);
	if (wasReleasedNow)
		AddTouchPointToList(luaState, "releasedtouchpoints", newMouseX, newMouseY, mouseX, mouseY);

	mouseX = newMouseX;
	mouseY = newMouseY;
	wasMouseClicked = isClicked;

	lua_pop(luaState, 1); // pops the input instance
}

/**
Creates a TouchPoint Lua object with the given data and set it into the list with the given name.
*/
void App::AddTouchPointToList(lua_State* luaState, string listFieldName, int x, int y, int previousX, int previousY)
{
	lua_getfield(luaState, -1, listFieldName.c_str());
	CreateTouchPointLuaObject(luaState, x, y, previousX, previousY);
	lua_rawseti(luaState, -2, 1);
	lua_pop(luaState, 1);
}

/**
Calls vega.TouchPoint.new and push the result into the stack.
*/
void App::CreateTouchPointLuaObject(lua_State* luaState, int x, int y, int previousX, int previousY)
{
	lua_getglobal(luaState, "vega");
	lua_getfield(luaState, -1, "TouchPoint");
	lua_getfield(luaState, -1, "new");
	lua_pushnumber(luaState, 1); // id, always 1 for the mouse
	lua_pushnumber(luaState, x);
	lua_pushnumber(luaState, y);
	lua_pushnumber(luaState, previousX);
	lua_pushnumber(luaState, previousY);
	lua_pushnumber(luaState, SDL_GetVideoSurface()->w);
	lua_pushnumber(luaState, SDL_GetVideoSurface()->h);
	lua_call(luaState, 7, 1);
	lua_remove(luaState, -2); // remove TouchPoint from the stack
	lua_remove(luaState, -2); // remove vega from stack, noew the stack is back to initial state + the result of the function at top
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
		case SDL_MOUSEBUTTONDOWN:
			break;
		case SDL_MOUSEBUTTONUP:
			break;
		}
	}
	appInstance->UpdateContextWithInputState(luaState);
	return 0;
}

/**
Called by the main loop Lua script, before update the frame.
*/
int App::SyncBeginLuaFunction(lua_State* luaState)
{
	appInstance->startFrameTime = (long) time(NULL);
	return 0;
}

/**
Called by the main loop Lua script, after update the frame. Sync to the expected frames per second.
On lua, call vegasyncend(framespersecond).
*/
int App::SyncEndLuaFunction(lua_State* luaState)
{
	lua_Number fps = luaL_checknumber(luaState, 1);
	long synchTime = 1000 / (long) fps;
	long waitTime = synchTime - (((long) time(NULL)) - appInstance->startFrameTime);
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

/**
Create a texture from an image file and returns a Texture object. Expected a string with the filename as input.
*/
int App::LoadTextureLuaFunction(lua_State *luaState)
{
	Texture* texture = Texture::Load(lua_tostring(luaState, -1));
	if (texture == NULL)
		return 0;
	else
	{
		appInstance->textures.push_back(texture);
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
int App::ReleaseTexturesLuaFunction(lua_State *luaState)
{
	for (list<Texture*>::iterator i = appInstance->textures.begin(); i != appInstance->textures.end(); ++i)
		delete *i;
	appInstance->textures.clear();
	return 0;
}

