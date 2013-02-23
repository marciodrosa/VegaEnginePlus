#include "../include/SceneRender.h"
#include "../include/SDL.h"

#include <iostream>

#include <windows.h>
#include <GL/GL.h>
#include <GL/glu.h>

using namespace vega;
using namespace std;

vega::SceneRender::SceneRender()
{
}

vega::SceneRender::~SceneRender()
{
}

/**
Initializes the render engine. Call it after the video initialization and before SceneRender::Render.
*/
void vega::SceneRender::Init()
{
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_BLEND);

	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);

	glAlphaFunc(GL_LEQUAL, 1);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
}

/**
Renders the current frame of the scene. Expected the Scene table in the top of the stack.
*/
void vega::SceneRender::Render(lua_State* luaState)
{
	if (luaState != NULL)
	{
		lua_getfield(luaState, 1, "backgroundcolor");
		Color backgroundColor = GetColor(luaState);
		glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		glClear(GL_COLOR_BUFFER_BIT);
		lua_pop(luaState, 1);
		lua_getfield(luaState, 1, "viewport");
		RenderViewport(luaState);
		lua_pop(luaState, 1);
	}
	else
	{
		glClearColor(0.f, 0.f, 0.f, 1.f);
		glClear(GL_COLOR_BUFFER_BIT);
	}
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
}

/**
Renders the viewport. Expected the Viewport table in the top of the stack.
*/
void vega::SceneRender::RenderViewport(lua_State* luaState)
{
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	SetUpView(luaState);
	lua_getfield(luaState, -1, "rootdrawable");
	RenderDrawable(luaState);
	lua_pop(luaState, 1);
}

/**
Renders the drawable. Expected the Drawable table in the top of the stack.
*/
void vega::SceneRender::RenderDrawable(lua_State* luaState)
{
	Vector2 position = GetVector2FromTableField(luaState, "position");
	Vector2 scale = GetVector2FromTableField(luaState, "scale");
	Vector2 origin = GetVector2FromTableField(luaState, "origin");
	Vector2 childrenOrigin = GetVector2FromTableField(luaState, "childrenorigin");
	lua_getfield(luaState, -1, "rotation");
	lua_Number rotation = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	glPushMatrix();
	ApplyTransform(luaState);
	RenderRectangle(luaState);
	RenderChildren(luaState);
	glPopMatrix();
}

/**
Renders the drawable. Expected the Drawable table in the top of the stack, where this Drawable is the parent of the children.
*/
void vega::SceneRender::RenderChildren(lua_State* luaState)
{
	glPushMatrix();
	ApplyTransformForChildren(luaState);
	lua_getfield(luaState, -1, "children");
	lua_len(luaState, -1);
	int childrenCount = (int) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	for (int i = 1; i <= childrenCount; i++)
	{
		lua_rawgeti(luaState, -1, i);
		RenderDrawable(luaState);
		lua_pop(luaState, 1);
	}
	glPopMatrix();
}

/**
Renders the drawable rectangle. Expected the Drawable table in the top of the stack, but the rectangle is only drawn
if it contains the RectangleDrawable table fields.
*/
void vega::SceneRender::RenderRectangle(lua_State* luaState)
{
	lua_getfield(luaState, -1, "color");
	if (!lua_isnil(luaState, -1))
	{
		Color color = GetColor(luaState);
		lua_pop(luaState, 1);
		Vector2 size = GetVector2FromTableFunction(luaState, "getabsolutesize");
		glColor4f(color.r, color.g, color.b, color.a);
		glBegin(GL_QUADS);
		glVertex2f(0.f, 0.f);
		glVertex2f(size.x, 0.f);
		glVertex2f(size.x, size.y);
		glVertex2f(0.f, size.y);
		glEnd();
	}
	else
		lua_pop(luaState, 1);
}

/**
Apply the transform on current matrix. Expected the Drawable table in the top of the stack.
*/
void vega::SceneRender::ApplyTransform(lua_State* luaState)
{
	Vector2 origin = GetVector2FromTableFunction(luaState, "getabsoluteorigin");
	Vector2 position = GetVector2FromTableFunction(luaState, "getabsoluteposition");
	Vector2 scale = GetVector2FromTableField(luaState, "scale");
	lua_getfield(luaState, -1, "rotation");
	GLfloat rotation = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);

	glTranslatef(position.x, position.y, 0.f);
	glRotatef(rotation, 0.f, 0.f, 1.f);
	glScalef(scale.x, scale.y, 1.f);
	glTranslatef(-origin.x, -origin.y, 0.f);
}

/**
Apply the transform of the children origin on current matrix. Expected the parent Drawable table in the top of the stack.
*/
void vega::SceneRender::ApplyTransformForChildren(lua_State* luaState)
{
	Vector2 childrenorigin = GetVector2FromTableField(luaState, "childrenorigin");
	glTranslatef(childrenorigin.x, childrenorigin.y, 0.f);
}

/**
Set up the view. Expected the Viewport table in the top of the stack.
*/
void vega::SceneRender::SetUpView(lua_State* luaState)
{
	lua_getfield(luaState, -1, "sceneviewheight");
	GLfloat sceneViewHeight = (GLfloat) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	
	GLfloat  viewport[4];
	glGetFloatv(GL_VIEWPORT, &viewport[0]);
	GLfloat sceneViewWidth = sceneViewHeight * viewport[2] / viewport[3];

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0.0, sceneViewWidth, 0.0, sceneViewHeight, -1.0, 1.0);
	glMatrixMode(GL_MODELVIEW);
}

/**
Creates a Color struct from the given Lua state. Expected the Color table in the top of the stack.
*/
Color vega::SceneRender::GetColor(lua_State* luaState)
{
	Color color;
	lua_getfield(luaState, -1, "r");
	color.r = lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "g");
	color.g = lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "b");
	color.b = lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "a");
	color.a = lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	return color;
}

/**
Creates a Vector2 struct from the given Lua state. Expected the Vector2 table in the top of the stack.
*/
Vector2 vega::SceneRender::GetVector2(lua_State* luaState)
{
	Vector2 vector2;
	lua_getfield(luaState, -1, "x");
	vector2.x = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "y");
	vector2.y = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	return vector2;
}

/**
Creates a Vector2 struct from the given Lua state. Expected the table owner of the Vector2 in the top of the stack.
*/
Vector2 vega::SceneRender::GetVector2FromTableField(lua_State* luaState, std::string fieldName)
{
	lua_getfield(luaState, -1, fieldName.c_str());
	Vector2 vector2 = GetVector2(luaState);
	lua_pop(luaState, 1);
	return vector2;
}

/**
Creates a Vector2 struct from the given Lua state. Expected the table owner of the Vector2 in the top of the stack. The only
arg sent to the function is the "self" table.
*/
Vector2 vega::SceneRender::GetVector2FromTableFunction(lua_State* luaState, std::string functionName)
{
	lua_getfield(luaState, -1, functionName.c_str());
	lua_pushvalue(luaState, -2);
	lua_call(luaState, 1, 1);
	Vector2 vector2 = GetVector2(luaState);
	lua_pop(luaState, 1);
	return vector2;
}