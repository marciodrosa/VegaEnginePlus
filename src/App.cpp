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
	stringstream ss;
	ss << "require '" << scriptName << "'";
	if (luaL_loadstring(cApi->GetLuaState(), ss.str().c_str()) != 0)
		Log::Error(lua_tostring(cApi->GetLuaState(), -1));
	else if (lua_pcall(cApi->GetLuaState(), 0, 0, 0) != 0)
		Log::Error(lua_tostring(cApi->GetLuaState(), -1));
}
