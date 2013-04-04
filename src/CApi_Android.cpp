#include "../include/CApi.h"
#include "../include/Log.h"
#include "../include/App.h"

#ifdef VEGA_ANDROID

#include <sstream>

using namespace std;
using namespace vega;

void CApi::InitAndroid()
{
	Log::Info("Initializing video...");
    const EGLint attribs[] = {
            EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
            EGL_BLUE_SIZE, 8,
            EGL_GREEN_SIZE, 8,
            EGL_RED_SIZE, 8,
            EGL_NONE
    };
    EGLint format;
    EGLint numConfigs;
    EGLConfig config;
    EGLSurface surface;
    EGLContext context;

    EGLDisplay display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    eglInitialize(display, 0, 0);
    eglChooseConfig(display, attribs, &config, 1, &numConfigs);
    eglGetConfigAttrib(display, config, EGL_NATIVE_VISUAL_ID, &format);

    ANativeWindow_setBuffersGeometry(App::GetAndroidWindow(), 0, 0, format);

    surface = eglCreateWindowSurface(display, config, App::GetAndroidWindow(), NULL);
    context = eglCreateContext(display, config, NULL, NULL);

    if (eglMakeCurrent(display, surface, surface, context) == EGL_FALSE)
        Log::Error("Unable to eglMakeCurrent");

	eglSurface = surface;
	eglDisplay = display;
	sceneRender.Init();
	int w, h;
	GetScreenSize(&w, &h);
	sceneRender.SetScreenSize(w, h);
}

/**
Setup Lua to search the scripts (when the "require" function is used) in the assets folder.
It adds a new function into the package.searches function.
*/
void CApi::InitLuaSearches()
{
	Log::Info("Adding the assets search function into the package.searches function...");
	lua_getglobal(luaState, "package");
	lua_getfield(luaState, -1, "searchers");
	lua_len(luaState, -1);
	int searchesLength = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	lua_pushcfunction(luaState, SearchModuleInAssetsLuaFunction);
	lua_rawseti(luaState, -2, searchesLength + 1);
	lua_pop(luaState, 2);
}

/**
Called by the main loop Lua script. Answer to the input events of the application.
On lua, call vegacheckinput(context).
*/
int CApi::CheckInputLuaFunction(lua_State* luaState)
{
	/*
	//old code from app glue:
	int eventId;
	int events;
	struct android_poll_source* source;
	while ((eventId = ALooper_pollAll(0, NULL, &events, (void**)&source)) >= 0)
	{
		if (source != NULL)
			source->process(App::GetAndroidActivity(), source);
		if (eventId == LOOPER_ID_USER)
		{
		}
		if (Context::GetAndroidApp()->destroyRequested != 0)
		{
			Log::Info("Destroy requested");
			CApi::GetInstance()->SetExecutingFieldToFalse();
			break;
		}
	}
	*/
	return 0;
}

void CApi::GetScreenSize(int *w, int *h)
{
	eglQuerySurface(eglDisplay, eglSurface, EGL_WIDTH, w);
	eglQuerySurface(eglDisplay, eglSurface, EGL_HEIGHT, h);
}

void CApi::OnRenderFinished()
{
	eglSwapBuffers(eglDisplay, eglSurface);
}

/**
The function to be added to the package.searches on Lua. It searches the module name (the input parameter)
in the assets folder. If not found, returns 0 results. Otherwise, returns 2 results: the load function and
the full asset name (directory and file name).
*/
int CApi::SearchModuleInAssetsLuaFunction(lua_State *luaState)
{
	string moduleName = lua_tostring(luaState, -1);
	stringstream moduleNameWithLuaExtension;
	moduleNameWithLuaExtension << moduleName << ".lua";
	stringstream moduleNameWithLCExtension;
	moduleNameWithLCExtension << moduleName << ".lc";
	// todo: is looking for the file on root dir and vega_lua dir; must be changedto look into the package.searchpath Lua field.
	list<string> dirs;
	dirs.push_back("");
	dirs.push_back("vega_lua");
	list<string> assetsNames;
	assetsNames.push_back(moduleName);
	assetsNames.push_back(moduleNameWithLuaExtension.str().c_str());
	assetsNames.push_back(moduleNameWithLCExtension.str().c_str());
	for (list<string>::iterator i = dirs.begin(); i != dirs.end(); ++i)
	{
		for (list<string>::iterator j = assetsNames.begin(); j != assetsNames.end(); ++j)
		{
			string fullAssetNameFound = SearchAssetOnDir(*i, *j);
			if (fullAssetNameFound.length() > 0)
			{
				lua_pushcfunction(luaState, LoadModuleFromAssetsLuaFunction);
				lua_pushstring(luaState, fullAssetNameFound.c_str());
				return 2;
			}
		}
	}
	return 0;
}

/**
Searches for the asset in the directory. Returns the full asset name (like "dir/asset") or empty
if not found.
*/
string CApi::SearchAssetOnDir(string dirName, string assetName)
{
	string foundAssetName;
	bool found = false;
	AAssetDir* dir = AAssetManager_openDir(App::GetAndroidActivity()->assetManager, dirName.c_str());
	const char* dirAsset = NULL;
	while ((dirAsset = AAssetDir_getNextFileName(dir)) != NULL)
	{
		string s = dirAsset;
		if (s == assetName)
		{
			found = true;
			if (dirName.length() > 0)
			{
				stringstream ss;
				ss << dirName << '/' << assetName;
				foundAssetName = ss.str().c_str();
			}
			else
				foundAssetName = assetName;
			break;
		}
	}
	AAssetDir_close(dir);
	if (found)
		return foundAssetName;
	else
		return "";
}

/**
Function used by the "require" function to load a module from the assets. It expects two input parameters
(the extra value = the asset name, and the module name, used for debug and messages) and returns 1 value
for the Lua (the value returned after run the loaded asset).
*/
int CApi::LoadModuleFromAssetsLuaFunction(lua_State *luaState)
{
	string extraValue = lua_tostring(luaState, -1);
	string moduleName = lua_tostring(luaState, -2);
	AAsset* asset = AAssetManager_open(App::GetAndroidActivity()->assetManager, extraValue.c_str(), AASSET_MODE_BUFFER);
	const void *data = AAsset_getBuffer(asset);
	size_t dataSize = AAsset_getLength(asset);
	if (luaL_loadbuffer(luaState, (const char*)data, dataSize, moduleName.c_str()))
		Log::Error(lua_tostring(luaState, -1));
	else if (lua_pcall(luaState, 0, 1, 0) != 0)
		Log::Error(lua_tostring(luaState, -1));
	AAsset_close(asset);
	return 1;
}

#endif
