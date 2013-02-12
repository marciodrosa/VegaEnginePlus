#ifndef VEGAENGINE_FUNCTIONS_H
#define VEGAENGINE_FUNCTIONS_H

#include "Lua.h"
#include <string>

void VegaInit();
void VegaLuaInit();
void VegaLoop(std::string startModuleScriptName);
void VegaFinish();

// Functions called from Lua scripts:
static int VegaCheckInput(lua_State *luaState);
static int VegaSyncBegin(lua_State *luaState);
static int VegaSyncEnd(lua_State *luaState);
static int VegaRender(lua_State *luaState);
static int VegaClearScreen(lua_State *luaState);

#endif
