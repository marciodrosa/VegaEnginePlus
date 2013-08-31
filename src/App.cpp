#include "../include/App.h"
#include "../include/Lua.h"
#include "../include/CApi.h"
#include "../include/Log.h"

#include <sstream>
#include <ctime>

using namespace std;
using namespace vega;

App* App::singleton = NULL;

App *App::GetSingleton()
{
	if (singleton == NULL)
		singleton = new App;
	return singleton;
}

void App::ReleaseSingleton()
{
	if (singleton != NULL)
	{
		delete singleton;
		singleton = NULL;
	}
}

App::App() : luaState(NULL)
{
}

App::~App()
{
#ifdef VEGA_WINDOWS
	IMG_Quit();
	SDL_Quit();
#endif
}

/**
Executes the application, requiring the Lua script with the given name.
*/
void App::Execute(string scriptName)
{
	Log::Info("Initializing app...");
	
#ifdef VEGA_WINDOWS
	InitSDL();
#endif

#ifdef VEGA_ANDROID
	InitAndroid();
#endif

	Log::Info("Creating a new Lua state...");
	luaState = luaL_newstate();
	Log::Info("Opening Lua libraries...");
	luaL_openlibs(luaState);
	Log::Info("Configuring Lua package path...");
	luaL_loadstring(luaState, "package.path = package.path..';vega/?.lua;vega/?;script/vega/?.lua;script/vega/?'");
	lua_pcall(luaState, 0, 0, 0);
	
#ifdef VEGA_ANDROID
	Log::Info("Configuring Android Lua searches...");
	InitLuaSearches();
#endif

	Log::Info("Requiring 'vega' Lua script...");
	lua_getglobal(luaState, "require");
	lua_pushstring(luaState, "vega");
	if (lua_pcall(luaState, 1, 1, 0) != 0)
	{
		Log::Error("Error when require 'vega':");
		Log::Error(lua_tostring(luaState, -1));
		lua_pop(luaState, 1);
	}
	else
	{
		CApi::Init(luaState);
		lua_getglobal(luaState, "require");
		lua_pushstring(luaState, scriptName.c_str());
		if (lua_pcall(luaState, 1, 1, 0) != 0)
		{
			Log::Error("Error when require script:");
			Log::Error(lua_tostring(luaState, -1));
			lua_pop(luaState, 1);
		}
	}
}

/**
Returns the Lua state of the application.
*/
lua_State* App::GetLuaState()
{
	return luaState;
}

/**
Sets the "executing" field of the Context table to false. Expected the Context table in the top of the stack.
*/
void App::SetExecutingFieldToFalse()
{
	lua_pushstring(luaState, "executing");
	lua_pushboolean(luaState, 0);
	lua_settable(luaState, 1);
}

/**
Returns the render.
*/
SceneRender& App::GetSceneRender()
{
	return sceneRender;
}

/**
Adds a texture object into the textures list.
*/
void App::AddTexture(Texture* texture)
{
	textures.push_back(texture);
}

/**
Releases all textures previous added to the textures list.
*/
void App::ReleaseTextures()
{
	for (list<Texture*>::iterator i = App::GetSingleton()->textures.begin(); i != App::GetSingleton()->textures.end(); ++i)
		delete *i;
	App::GetSingleton()->textures.clear();
}

/**
Initiates the sync of the frame. May be called in the beginning of the main loop iteration.
*/
void App::SyncBegin()
{
	startFrameTime = (long) time(NULL);
}

/**
Finishes the sync of the frame. May be called in the end of the main loop iteration.
*/
void App::SyncEnd(long expectedFps)
{
	long synchTime = 1000 / expectedFps;
	long waitTime = synchTime - (((long) time(NULL)) - App::GetSingleton()->startFrameTime);
	if (waitTime > 0)
	{
#ifdef VEGA_WINDOWS
		SDL_Delay(waitTime);
#endif
	}
}
