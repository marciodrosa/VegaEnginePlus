#ifndef VEGAENGINE_FUNCTIONS_H
#define VEGAENGINE_FUNCTIONS_H

#include "Lua.h"

void VegaInit();
void VegaLuaInit();
void VegaLoop();
void VegaFinish();

// Functions called from Lua scripts:
static int VegaCheckInput(lua_State *luaState);
static int VegaSyncBegin(lua_State *luaState);
static int VegaSyncEnd(lua_State *luaState);
static int VegaRender(lua_State *luaState);
static int VegaClearScreen(lua_State *luaState);

#endif
