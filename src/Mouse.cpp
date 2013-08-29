#include "../include/Mouse.h"

using namespace vega;

Mouse::Mouse()
{
}

Mouse::~Mouse()
{
}

Vector2 Mouse::GetPosition() const
{
	return position;
}

void Mouse::SetPosition(Vector2& p)
{
	position = p;
}

Vector2 Mouse::GetMotion() const
{
	return motion;
}

double Mouse::GetMotionZ() const
{
	return motionZ;
}

void Mouse::SetMotion(Vector2& m, double z)
{
	motion = m;
	motionZ = z;
}

MouseButton Mouse::GetLeftMouseButton() const
{
	return leftMouseButton;
}

void Mouse::SetLeftMouseButton(MouseButton& mb)
{
	leftMouseButton = mb;
}

MouseButton Mouse::GetRightMouseButton() const
{
	return rightMouseButton;
}

void Mouse::SetRightMouseButton(MouseButton& mb)
{
	rightMouseButton = mb;
}

MouseButton Mouse::GetMiddleMouseButton() const
{
	return middleMouseButton;
}

void Mouse::SetMiddleMouseButton(MouseButton& mb)
{
	middleMouseButton = mb;
}

/**
Writes the values of this Mouse object into the Lua object. Expected the mouse table in the top
of the Lua stack.
*/
void Mouse::WriteOnLuaTable(lua_State* luaState) const
{
	lua_getfield(luaState, -1, "position"); // pushes position
	lua_pushnumber(luaState, position.x);
	lua_setfield(luaState, -2, "x");
	lua_pushnumber(luaState, position.y);
	lua_setfield(luaState, -2, "y");
	lua_pop(luaState, 1); // pops position
	
	lua_getfield(luaState, -1, "motion"); // pushes motion
	lua_pushnumber(luaState, motion.x);
	lua_setfield(luaState, -2, "x");
	lua_pushnumber(luaState, motion.y);
	lua_setfield(luaState, -2, "y");
	lua_pushnumber(luaState, motionZ);
	lua_setfield(luaState, -2, "z");
	lua_pop(luaState, 1); // pops motion

	lua_getfield(luaState, -1, "buttons"); // pushes buttons
	
	WriteMouseButtonOnLuaTable(luaState, leftMouseButton, "left");
	WriteMouseButtonOnLuaTable(luaState, rightMouseButton, "right");
	WriteMouseButtonOnLuaTable(luaState, middleMouseButton, "middle");

	lua_pop(luaState, 1); // pops buttons
}

void Mouse::WriteMouseButtonOnLuaTable(lua_State* luaState, const MouseButton& mouseButton, std::string buttonName) const
{
	lua_getfield(luaState, -1, buttonName.c_str());
	lua_pushboolean(luaState, mouseButton.pressed);
	lua_setfield(luaState, -2, "pressed");
	lua_pushboolean(luaState, mouseButton.wasClicked);
	lua_setfield(luaState, -2, "wasclicked");
	lua_pushboolean(luaState, mouseButton.wasDoubleClicked);
	lua_setfield(luaState, -2, "wasdoubleclicked");
	lua_pushboolean(luaState, mouseButton.wasReleased);
	lua_setfield(luaState, -2, "wasreleased");
	lua_pop(luaState, 1);
}
