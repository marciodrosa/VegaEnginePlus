#ifndef VEGAENGINE_SCENERENDER_H
#define VEGAENGINE_SCENERENDER_H

#include <string>

#include "Lua.h"
#include "OpenGL.h"

namespace vega
{
	struct Color
	{
		float r, g, b, a;
	};

	struct Vector2
	{
		float x, y;
	};

	/**
	Renders a scene and the attached drawables.
	*/
	class SceneRender
	{
	public:
		SceneRender();
		virtual ~SceneRender();
		void Init();
		void Render(lua_State*);
	private:
		void RenderViewport(lua_State* luaState);
		void RenderDrawable(lua_State* luaState);
		void RenderChildren(lua_State* luaState);
		void RenderBackground(lua_State* luaState);
		void RenderDrawableRectangle(lua_State* luaState);
		void ApplyTransform(lua_State* luaState);
		void ApplyTransformForChildren(lua_State* luaState);
		void SetUpView(lua_State* luaState);
		Color GetColor(lua_State* luaState);
		Vector2 GetVector2(lua_State* luaState);
		Vector2 GetVector2FromTableField(lua_State* luaState, std::string fieldName);
		Vector2 GetVector2FromTableFunction(lua_State* luaState, std::string functionName);
		GLuint GetTextureId(lua_State* luaState);
	};
}

#endif
