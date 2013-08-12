#include "../include/App.h"
#include "../include/Lua.h"
#include "../include/CApi.h"
#include "../include/Log.h"

#include <sstream>

using namespace std;
using namespace vega;

App::App()
{
}

App::~App()
{
	CApi::ReleaseInstance();
}

/**
Requires the Lua script with the given name.
*/
void App::Execute(string scriptName)
{
	CApi* cApi = CApi::GetInstance();
	lua_getglobal(cApi->GetLuaState(), "require");
	lua_pushstring(cApi->GetLuaState(), scriptName.c_str());
	if (lua_pcall(cApi->GetLuaState(), 1, 1, 0) != 0)
	{
		Log::Error("Error when require script:");
		Log::Error(lua_tostring(cApi->GetLuaState(), -1));
		lua_pop(cApi->GetLuaState(), 1);
	}
}
