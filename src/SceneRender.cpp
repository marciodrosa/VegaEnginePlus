#include "../include/SceneRender.h"
#include "../include/OpenGL.h"
#include "../include/SDL.h"
#include "../include/Log.h"

#include <iostream>
#include <sstream>
#include <list>

using namespace vega;
using namespace std;

SceneRender::SceneRender() : isInitiated(false), screenWidth(1), screenHeight(1)
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
	Log::Info("Initializing render...");
	glEnable(GL_ALPHA_TEST);
	glEnable(GL_BLEND);
	glEnable(GL_TEXTURE_2D);

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

	isInitiated = true;
}

void SceneRender::SetScreenSize(int w, int h)
{
	screenWidth = w;
	screenHeight = h;
}

/**
Renders the current frame of the scene. Expected the Scene table in the top of the stack.
*/
void SceneRender::Render(lua_State* luaState)
{
	if (!isInitiated)
		return;
	if (luaState != NULL)
	{
		glViewport(0, 0, screenWidth, screenHeight);
		lua_getfield(luaState, 1, "backgroundcolor");
		Color backgroundColor = GetColor(luaState);
		glClearColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
		glClear(GL_COLOR_BUFFER_BIT);
		lua_pop(luaState, 1);
		lua_getfield(luaState, 1, "layers");
		RenderLayers(luaState);
		lua_pop(luaState, 1);
	}
	else
	{
		glClearColor(0.f, 0.f, 0.f, 1.f);
		glClear(GL_COLOR_BUFFER_BIT);
	}
	/*GLenum error = glGetError();
	if (error != GL_NO_ERROR)
	{
		stringstream ss;
		ss << "OpenGL Error: " << error;
		Log::Error(ss.str());
	}*/
}

/**
Renders the layers of the scene. Expected the layers list in the top of the stack.
*/
void SceneRender::RenderLayers(lua_State* luaState)
{
	lua_len(luaState, -1); // pushes the length of the list
	int layersCount = lua_tointeger(luaState, -1);
	lua_pop(luaState, 1); // pops the length of the list
	for (int i = 1; i <= layersCount; i++)
	{
		lua_pushnumber(luaState, i);
		lua_gettable(luaState, -2); // pushes the layer
		RenderLayer(luaState);
		lua_pop(luaState, 1); // pops the layer
	}
}

/**
Renders the layer. Expected the layer table in the top of the stack.
*/
void SceneRender::RenderLayer(lua_State* luaState)
{
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	SetUpCamera(luaState);
	lua_getfield(luaState, -1, "root");
	RenderDrawable(luaState, 1.f);
	lua_pop(luaState, 1);
}

/**
Renders the drawable. Expected the Drawable table in the top of the stack.
*/
void SceneRender::RenderDrawable(lua_State* luaState, lua_Number globalVisibility)
{
	BeforeRenderDrawable(luaState);
	lua_getfield(luaState, -1, "visibility");
	lua_Number visibility = lua_tonumber(luaState, -1) * globalVisibility;
	lua_pop(luaState, 1);
	glPushMatrix();
	Transform transform = GetTransform(luaState);
	ApplyTransform(transform);
	RenderBackground(luaState, visibility, transform);
	RenderDrawableRectangle(luaState, visibility);
	RenderChildren(luaState, visibility, transform);
	glPopMatrix();
	AfterRenderDrawable(luaState);
}

/**
Renders the drawable children. Expected the Drawable table in the top of the stack, where this Drawable is the parent of the children.
*/
void SceneRender::RenderChildren(lua_State* luaState, lua_Number globalVisibility, Transform &transform)
{
	glPushMatrix();
	ApplyTransformForChildren(transform);
	lua_getfield(luaState, -1, "background");
	lua_getfield(luaState, -2, "children");
	lua_len(luaState, -1);
	int childrenCount = (int) lua_tonumber(luaState, -1);
	lua_pop(luaState, 1); // pops the children length
	for (int i = 1; i <= childrenCount; i++)
	{
		lua_pushnumber(luaState, i);
		lua_gettable(luaState, -2); // pushes the child
		if (!lua_rawequal(luaState, -1, -3)) // checks if the current child is the same object of the "background" field
			RenderDrawable(luaState, globalVisibility);
		lua_pop(luaState, 1); // pops the child
	}
	lua_pop(luaState, 2); // pops "background" and "children"
	glPopMatrix();
}

/**
Renders the drawable background child, if defined. Expected the Drawable table in the top of the stack,
where this Drawable is the parent of the children.
*/
void SceneRender::RenderBackground(lua_State* luaState, lua_Number globalVisibility, Transform &transform)
{
	lua_getfield(luaState, -1, "background");
	if (!lua_isnil(luaState, -1))
	{
		glPushMatrix();
		lua_pop(luaState, 1);
		ApplyTransformForChildren(transform);
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
		Vector2 size = GetVector2FromTableField(luaState, "size");
		Vector2 topLeftUV(0.f, 0.f);
		Vector2 bottomRightUV(1.f, 1.f);
		ReadVector2FromTableField(luaState, "topleftuv", topLeftUV);
		ReadVector2FromTableField(luaState, "bottomrightuv", bottomRightUV);
		
		glBindTexture(GL_TEXTURE_2D, textureId);
		SetUpTextureMode(luaState);
		
		glColor4f(color.r, color.g, color.b, color.a * (float) visibility);

		GLfloat vertexes[] = {0.f, 0.f,  size.x, 0.f,  size.x, size.y,  0.f, size.y};
		GLfloat uvCoordinates[] = {topLeftUV.x, bottomRightUV.y,  bottomRightUV.x, bottomRightUV.y,  bottomRightUV.x, topLeftUV.y,  topLeftUV.x, topLeftUV.y};
		glVertexPointer(2, GL_FLOAT, 0, vertexes);
		glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
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
Apply the transform on current matrix.
*/
void SceneRender::ApplyTransform(Transform &transform)
{
	glTranslatef(transform.position.x, transform.position.y, 0.f);
	glRotatef(transform.rotation, 0.f, 0.f, 1.f);
	glScalef(transform.scale.x, transform.scale.y, 1.f);
	glTranslatef(-transform.origin.x, -transform.origin.y, 0.f);
}

/**
Apply the transform of the children origin on current matrix.
*/
void SceneRender::ApplyTransformForChildren(Transform &transform)
{
	glTranslatef(transform.childrenOrigin.x, transform.childrenOrigin.y, 0.f);
}

/*
Inverts the transform values, to be used in the view.
*/
void SceneRender::InvertTransformValues(Transform &transform)
{
	transform.position.x *= -1;
	transform.position.y *= -1;
	transform.scale.x = transform.scale.x > 0 ? 1 / transform.scale.x : 0;
	transform.scale.y = transform.scale.y > 0 ? 1 / transform.scale.y : 0;
	transform.origin.x *= -1;
	transform.origin.y *= -1;
	transform.childrenOrigin.x *= -1;
	transform.childrenOrigin.y *= -1;
	transform.rotation *= -1;
}

/**
Set up the camera. Expected the layer table in the top of the stack.
*/
void SceneRender::SetUpCamera(lua_State* luaState)
{
	lua_getfield(luaState, -1, "camera"); // pushes the camera table
	lua_getfield(luaState, -1, "size"); // pushes the size of the camera
	Vector2 cameraSize = GetVector2(luaState);
	lua_pop(luaState, 1); // pops size table

	Transform cameraTransform = GetTransform(luaState);
	InvertTransformValues(cameraTransform);
	glTranslatef(-cameraTransform.origin.x, -cameraTransform.origin.y, 0.f);
	glScalef(cameraTransform.scale.x, cameraTransform.scale.y, 1.f);
	glRotatef(cameraTransform.rotation, 0.f, 0.f, 1.f);
	glTranslatef(cameraTransform.position.x, cameraTransform.position.y, 0.f);

	int tablesToPop = 0;
	while(true)
	{
		tablesToPop++;
		lua_getfield(luaState, -1, "parent"); // pushes the parent
		if (lua_isnil(luaState, -1))
			break;
		else
		{
			Transform parentTransform = GetTransform(luaState);
			InvertTransformValues(parentTransform);
			glTranslatef(-parentTransform.origin.x, -parentTransform.origin.y, 0.f);
			glScalef(parentTransform.scale.x, parentTransform.scale.y, 1.f);
			glRotatef(parentTransform.rotation, 0.f, 0.f, 1.f);
			glTranslatef(parentTransform.position.x, parentTransform.position.y, 0.f);
		}
	}
	lua_pop(luaState, tablesToPop + 1); // pops the parents + the camera itself

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
#ifdef VEGA_OPENGL_ES
	glOrthof(0.0, cameraSize.x, 0.0, cameraSize.y, -1.0, 1.0);
#else
	glOrtho(0.0, cameraSize.x, 0.0, cameraSize.y, -1.0, 1.0);
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
Creates a Color struct from the given Lua state. Expected the color (table or number) in the top of the stack
(it is popped from the stack).
*/
Color SceneRender::GetColor(lua_State* luaState)
{
	lua_getglobal(luaState, "vega"); // pushes vega table
	lua_getfield(luaState, -1, "color"); // pushes vega.color table
	lua_getfield(luaState, -1, "getcomponents"); // pushes vega.color.getcomponents function
	lua_pushvalue(luaState, -4); // pushes the color in the top of the stack again
	lua_call(luaState, 1, 1); // calls the function vega.color.getcomponents and pushes the one result (a table with a, r, g and b)

	// parses the table with r, g, b and a values:
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

	lua_pop(luaState, 3); // pops vega table, vega.color table and the color
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
Reads the transform fields (position, scale, etc.) from the table in the top of the stack.
*/
Transform SceneRender::GetTransform(lua_State *luaState)
{
	Transform transform;
	transform.position = GetVector2FromTableField(luaState, "position");
	transform.scale = GetVector2FromTableField(luaState, "scale");
	transform.origin = GetVector2FromTableField(luaState, "origin");
	transform.childrenOrigin = GetVector2FromTableField(luaState, "childrenorigin");
	lua_getfield(luaState, -1, "rotation");
	transform.rotation = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	return transform;
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
