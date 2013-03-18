#include "../include/SceneRender.h"
#include "../include/OpenGL.h"
#include "../include/SDL.h"

#include <iostream>

using namespace vega;
using namespace std;

SceneRender::SceneRender()
{
}

SceneRender::~SceneRender()
{
}

/**
Initializes the render engine. Call it after the video initialization and before SceneRender::Render.
*/
void SceneRender::Init()
{
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_BLEND);
	glEnable(GL_TEXTURE_2D);

	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);

	glAlphaFunc(GL_LEQUAL, 1);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

#ifndef VEGA_OPENGL_ES
	glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
#endif
}

/**
Renders the current frame of the scene. Expected the Scene table in the top of the stack.
*/
void SceneRender::Render(lua_State* luaState)
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
}

/**
Renders the viewport. Expected the Viewport table in the top of the stack.
*/
void SceneRender::RenderViewport(lua_State* luaState)
{
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	SetUpView(luaState);
	lua_getfield(luaState, -1, "rootdrawable");
	RenderDrawable(luaState, 1.f);
	lua_pop(luaState, 1);
}

/**
Renders the drawable. Expected the Drawable table in the top of the stack.
*/
void SceneRender::RenderDrawable(lua_State* luaState, lua_Number globalVisibility)
{
	BeforeRenderDrawable(luaState);
	Vector2 position = GetVector2FromTableField(luaState, "position");
	Vector2 scale = GetVector2FromTableField(luaState, "scale");
	Vector2 origin = GetVector2FromTableField(luaState, "origin");
	Vector2 childrenOrigin = GetVector2FromTableField(luaState, "childrenorigin");
	lua_getfield(luaState, -1, "rotation");
	lua_Number rotation = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "visibility");
	lua_Number visibility = lua_tonumber(luaState, -1) * globalVisibility;
	lua_pop(luaState, 1);
	glPushMatrix();
	ApplyTransform(luaState);
	RenderBackground(luaState, visibility);
	RenderDrawableRectangle(luaState, visibility);
	RenderChildren(luaState, visibility);
	glPopMatrix();
	AfterRenderDrawable(luaState);
}

/**
Renders the drawable children. Expected the Drawable table in the top of the stack, where this Drawable is the parent of the children.
*/
void SceneRender::RenderChildren(lua_State* luaState, lua_Number globalVisibility)
{
	glPushMatrix();
	ApplyTransformForChildren(luaState);
	lua_getfield(luaState, -1, "background");
	lua_getfield(luaState, -2, "children");
	lua_len(luaState, -1);
	int childrenCount = (int) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1); // pops the children length
	for (int i = 1; i <= childrenCount; i++)
	{
		lua_rawgeti(luaState, -1, i);
		if (!lua_rawequal(luaState, -1, -3)) // checks if the current child is the same object of the "background" field
			RenderDrawable(luaState, globalVisibility);
		lua_pop(luaState, 1);
	}
	lua_pop(luaState, 2); // pops "background" and "children"
	glPopMatrix();
}

/**
Renders the drawable background child, if defined. Expected the Drawable table in the top of the stack,
where this Drawable is the parent of the children.
*/
void SceneRender::RenderBackground(lua_State* luaState, lua_Number globalVisibility)
{
	lua_getfield(luaState, -1, "background");
	if (!lua_isnil(luaState, -1))
	{
		glPushMatrix();
		lua_pop(luaState, 1);
		ApplyTransformForChildren(luaState);
		lua_getfield(luaState, -1, "background");
		RenderDrawable(luaState, globalVisibility);
		lua_pop(luaState, 1);
		glPopMatrix();
	}
	else
		lua_pop(luaState, 1);
}

/**
Renders the drawable rectangle. Expected the Drawable table in the top of the stack, but the rectangle is only drawn
if it contains the color or texture fields.
*/
void SceneRender::RenderDrawableRectangle(lua_State* luaState, lua_Number visibility)
{
	Color color = { 1.f, 1.f, 1.f, 1.f };
	bool isColorDefined = false;
	lua_getfield(luaState, -1, "color");
	if (!lua_isnil(luaState, -1))
	{
		color = GetColor(luaState);
		isColorDefined = true;
	}
	lua_pop(luaState, 1);
	GLuint textureId = GetTextureId(luaState);
	if (isColorDefined || textureId != 0)
	{
		Vector2 size = GetVector2FromTableFunction(luaState, "getabsolutesize");
		Vector2 topLeftUV = { 0.f, 0.f };
		Vector2 bottomRightUV = { 1.f, 1.f };
		ReadVector2FromTableField(luaState, "topleftuv", topLeftUV);
		ReadVector2FromTableField(luaState, "bottomrightuv", bottomRightUV);
		
		glBindTexture(GL_TEXTURE_2D, textureId);
		SetUpTextureMode(luaState);
		
		glColor4f(color.r, color.g, color.b, color.a * (float) visibility);
		
#ifdef VEGA_OPENGL_ES
#else
		glBegin(GL_QUADS);
		// left bottom:
		glTexCoord2f(topLeftUV.x, bottomRightUV.y);
		glVertex2f(0.f, 0.f);
		// right bottom:
		glTexCoord2f(bottomRightUV.x, bottomRightUV.y);
		glVertex2f(size.x, 0.f);
		// right top:
		glTexCoord2f(bottomRightUV.x, topLeftUV.y);
		glVertex2f(size.x, size.y);
		// left top:
		glTexCoord2f(topLeftUV.x, topLeftUV.y);
		glVertex2f(0.f, size.y);
		glEnd();
#endif
	}
}

/**
Calls the callback method of the drawable before the rendering. Expected the Drawable table in the top of the stack.
*/
void SceneRender::BeforeRenderDrawable(lua_State* luaState)
{
	lua_getfield(luaState, -1, "beforedraw");
	if (lua_isnil(luaState, -1))
		lua_pop(luaState, 1);
	else
	{
		lua_pushvalue(luaState, -2); // push "self"
		lua_call(luaState, 1, 0);
	}
}

/**
Calls the callback method of the drawable after the rendering. Expected the Drawable table in the top of the stack.
*/
void SceneRender::AfterRenderDrawable(lua_State* luaState)
{
	lua_getfield(luaState, -1, "afterdraw");
	if (lua_isnil(luaState, -1))
		lua_pop(luaState, 1);
	else
	{
		lua_pushvalue(luaState, -2); // push "self"
		lua_call(luaState, 1, 0);
	}
}

/**
Apply the transform on current matrix. Expected the Drawable table in the top of the stack.
*/
void SceneRender::ApplyTransform(lua_State* luaState)
{
	Vector2 origin = GetVector2FromTableFunction(luaState, "getabsoluteorigin");
	Vector2 position = GetVector2FromTableFunction(luaState, "getabsoluteposition");
	Vector2 scale = GetVector2FromTableField(luaState, "scale");
	lua_getfield(luaState, -1, "rotation");
	GLfloat rotation = (GLfloat) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);

	glTranslatef(position.x, position.y, 0.f);
	glRotatef(rotation, 0.f, 0.f, 1.f);
	glScalef(scale.x, scale.y, 1.f);
	glTranslatef(-origin.x, -origin.y, 0.f);
}

/**
Apply the transform of the children origin on current matrix. Expected the parent Drawable table in the top of the stack.
*/
void SceneRender::ApplyTransformForChildren(lua_State* luaState)
{
	Vector2 childrenorigin = GetVector2FromTableField(luaState, "childrenorigin");
	glTranslatef(childrenorigin.x, childrenorigin.y, 0.f);
}

/**
Set up the view. Expected the Viewport table in the top of the stack.
*/
void SceneRender::SetUpView(lua_State* luaState)
{
	lua_getfield(luaState, -1, "sceneviewheight");
	GLfloat sceneViewHeight = (GLfloat) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	
	GLfloat  viewport[4];
	glGetFloatv(GL_VIEWPORT, &viewport[0]);
	GLfloat sceneViewWidth = sceneViewHeight * viewport[2] / viewport[3];

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
#ifdef VEGA_OPENGL_ES
	glOrthof(0.0, sceneViewWidth, 0.0, sceneViewHeight, -1.0, 1.0);
#else
	glOrtho(0.0, sceneViewWidth, 0.0, sceneViewHeight, -1.0, 1.0);
#endif
	glMatrixMode(GL_MODELVIEW);
}

/**
Set up the texture mode of the drawable. Expected a drawable table in the top of the stack.
*/
void SceneRender::SetUpTextureMode(lua_State* luaState)
{
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GetTextureMode(luaState, "texturemodeu"));
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GetTextureMode(luaState, "texturemodev"));
}

/**
Creates a Color struct from the given Lua state. Expected the Color table in the top of the stack.
*/
Color SceneRender::GetColor(lua_State* luaState)
{
	Color color;
	lua_getfield(luaState, -1, "r");
	color.r = (float) lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "g");
	color.g = (float) lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "b");
	color.b = (float) lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "a");
	color.a = (float) lua_tonumber(luaState, -1) / 255.f;
	lua_pop(luaState, 1);
	return color;
}

/**
Creates a Vector2 struct from the given Lua state. Expected the Vector2 table in the top of the stack.
*/
Vector2 SceneRender::GetVector2(lua_State* luaState)
{
	Vector2 vector2;
	ReadVector2(luaState, vector2);
	return vector2;
}

/**
Reads the Vector2 data from the given Lua state. Expected the Vector2 table in the top of the stack.
*/
void SceneRender::ReadVector2(lua_State* luaState, Vector2& vector2)
{
	lua_getfield(luaState, -1, "x");
	vector2.x = (float) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	lua_getfield(luaState, -1, "y");
	vector2.y = (float) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
}

/**
Creates a Vector2 struct from the given Lua state. Expected the table owner of the Vector2 in the top of the stack.
*/
Vector2 SceneRender::GetVector2FromTableField(lua_State* luaState, std::string fieldName)
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
Vector2 SceneRender::GetVector2FromTableFunction(lua_State* luaState, std::string functionName)
{
	lua_getfield(luaState, -1, functionName.c_str());
	lua_pushvalue(luaState, -2);
	lua_call(luaState, 1, 1);
	Vector2 vector2 = GetVector2(luaState);
	lua_pop(luaState, 1);
	return vector2;
}

/**
Reads the Vector2 data from the table in the top of the stack of the luaState. If nil, then it does nothing.
*/
void SceneRender::ReadVector2FromTableField(lua_State* luaState, std::string fieldName, Vector2& vector2)
{
	lua_getfield(luaState, -1, fieldName.c_str());
	if (!lua_isnil(luaState, -1))
		ReadVector2(luaState, vector2);
	lua_pop(luaState, 1);
}

/**
Returns the OpenGL texture ID from the drawable table in the top of the stack. If the texture is not
defined, returns 0.
*/
GLuint SceneRender::GetTextureId(lua_State* luaState)
{
	GLuint id = 0;
	lua_getfield(luaState, -1, "texture");
	if (!lua_isnil(luaState, -1))
	{
		lua_getfield(luaState, -1, "id");
		id = (GLuint) lua_tonumber(luaState, -1);
		lua_pop(luaState, 1);
	}
	lua_pop(luaState, 1);
	return id;
}

/**
Returns the OpenGL value to be used to wrap the texture, according the field of the table
in the top of the stack.
*/
GLint SceneRender::GetTextureMode(lua_State* luaState, std::string fieldName)
{
	GLint textureMode = GL_REPEAT;
	lua_getfield(luaState, -1, fieldName.c_str());
	if (!lua_isnil(luaState, -1))
	{
		string textureModeStr = lua_tostring(luaState, -1);
		if (textureModeStr == "clamp")
		{
#ifdef VEGA_OPENGL_ES
			textureMode = GL_CLAMP_TO_EDGE;
#else
			textureMode = GL_CLAMP;
#endif
		}
	}
	lua_pop(luaState, 1);
	return textureMode;
}
