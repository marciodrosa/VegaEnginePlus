#include "../include/CApi.h"
#include "../include/Log.h"

#include <ctime>

using namespace std;
using namespace vega;

CApi* CApi::instance = NULL;

CApi* CApi::GetInstance()
{
	if (instance == NULL)
		instance = new CApi;
	return instance;
}

void CApi::ReleaseInstance()
{
	if (instance != NULL)
		delete instance;
}

CApi::CApi()
{
	Log::Info("Creating the C api instance...");
	mouseX = 0;
	mouseY = 0;
	wasMouseClicked = false;
	
#ifdef VEGA_WINDOWS
	InitSDL();
#endif
	Log::Info("Creating a new Lua state...");
	luaState = luaL_newstate();
	Log::Info("Opening Lua libraries...");
	luaL_openlibs(luaState);
	Log::Info("Configuring Lua package path...");
	luaL_loadstring(luaState, "package.path = package.path..';vega_lua/?.lua;vega_lua/?'");
	lua_pcall(luaState, 0, 0, 0);
}

CApi::~CApi()
{
	Log::Info("CApi released.");
#ifdef VEGA_WINDOWS
	IMG_Quit();
	SDL_Quit();
#endif
#ifdef VEGA_ANDROID
	androidApp->onAppCmd = NULL;
#endif
}

void CApi::Init()
{
	Log::Info("Initializing the C api instance...");
	
#ifdef VEGA_ANDROID
	Log::Info("Configuring Android Lua searches...");
	InitLuaSearches();
#endif

	Log::Info("Requiring 'vega' Lua script...");
	luaL_loadstring(luaState, "require 'vega'");
	lua_pcall(luaState, 0, 0, 0);

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
	
	lua_pushstring(luaState, "loadtexture");
	lua_pushcfunction(luaState, LoadTextureLuaFunction);
	lua_settable(luaState, -3);
	
	lua_pushstring(luaState, "releasetextures");
	lua_pushcfunction(luaState, ReleaseTexturesLuaFunction);
	lua_settable(luaState, -3);

	lua_pop(luaState, 2);
	Log::Info("capi Lua table created.");
}

/**
Returns the Lua state object used by this class.
*/
lua_State* CApi::GetLuaState()
{
	return luaState;
}

/**
Called by the main loop Lua script, before update the frame.
*/
int CApi::SyncBeginLuaFunction(lua_State *luaState)
{
	CApi::GetInstance()->startFrameTime = (long) time(NULL);
	return 0;
}

/**
Called by the main loop Lua script, after update the frame. Sync to the expected frames per second.
On lua, call vegasyncend(framespersecond).
*/
int CApi::SyncEndLuaFunction(lua_State *luaState)
{
	lua_Number fps = luaL_checknumber(luaState, 1);
	long synchTime = 1000 / (long) fps;
	long waitTime = synchTime - (((long) time(NULL)) - CApi::GetInstance()->startFrameTime);
	if (waitTime > 0)
	{
#ifdef VEGA_WINDOWS
		SDL_Delay(waitTime);
#endif
	}
	return 0;
}

/**
Called by the main loop Lua script. Renders the available scene.
*/
int CApi::RenderLuaFunction(lua_State *luaState)
{
	CApi::GetInstance()->sceneRender.Render(luaState);
	CApi::GetInstance()->OnRenderFinished();
	return 0;
}

/**
Called by the main loop Lua script. Clear the screen.
*/
int CApi::ClearScreenLuaFunction(lua_State *luaState)
{
	CApi::GetInstance()->sceneRender.Render(NULL);
	CApi::GetInstance()->OnRenderFinished();
	return 0;
}

/**
Return two values to the Lua call: the width and height of the screen.
*/
int CApi::ScreenSizeLuaFunction(lua_State *luaState)
{
	int w, h;
	CApi::GetInstance()->GetScreenSize(&w, &h);
	lua_pushnumber(luaState, w);
	lua_pushnumber(luaState, h);
	return 2;
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
		CApi::GetInstance()->textures.push_back(texture);
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
	for (list<Texture*>::iterator i = CApi::GetInstance()->textures.begin(); i != CApi::GetInstance()->textures.end(); ++i)
		delete *i;
	CApi::GetInstance()->textures.clear();
	return 0;
}

/**
Sets the "executing" field of the Context table to false. Expected the Context table in the top of the stack.
*/
void CApi::SetExecutingFieldToFalse()
{
	lua_pushstring(luaState, "executing");
	lua_pushboolean(luaState, 0);
	lua_settable(luaState, 1);
}

/**
Creates a TouchPoint Lua object with the given data and set it into the list with the given name.
*/
void CApi::AddTouchPointToList(string listFieldName, int x, int y, int previousX, int previousY)
{
	lua_getfield(luaState, -1, listFieldName.c_str());
	CreateTouchPointLuaObject(x, y, previousX, previousY);
	lua_rawseti(luaState, -2, 1);
	lua_pop(luaState, 1);
}

/**
Calls vega.TouchPoint.new and push the result into the stack.
*/
void CApi::CreateTouchPointLuaObject(int x, int y, int previousX, int previousY)
{
	int screenWidth, screenHeight;
	GetScreenSize(&screenWidth, &screenHeight);
	lua_getglobal(luaState, "vega");
	lua_getfield(luaState, -1, "TouchPoint");
	lua_getfield(luaState, -1, "new");
	lua_pushnumber(luaState, 1); // id, always 1 for the mouse
	lua_pushnumber(luaState, x);
	lua_pushnumber(luaState, y);
	lua_pushnumber(luaState, previousX);
	lua_pushnumber(luaState, previousY);
	lua_pushnumber(luaState, screenWidth);
	lua_pushnumber(luaState, screenHeight);
	lua_call(luaState, 7, 1);
	lua_remove(luaState, -2); // remove TouchPoint from the stack
	lua_remove(luaState, -2); // remove vega from stack, noew the stack is back to initial state + the result of the function at top
}
