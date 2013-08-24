#ifndef VEGA_SCENERENDER_H
#define VEGA_SCENERENDER_H

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

	struct Transform
	{
		Vector2 position, origin, childrenOrigin, scale;
		float rotation;
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
		void SetScreenSize(int w, int h);
		void Render(lua_State*);
	private:
		void RenderLayers(lua_State* luaState);
		void RenderLayer(lua_State* luaState);
		void RenderDrawable(lua_State* luaState, lua_Number globalVisibility);
		void RenderChildren(lua_State* luaState, lua_Number globalVisibility, Transform &transform);
		void RenderBackground(lua_State* luaState, lua_Number globalVisibility, Transform &transform);
		void RenderDrawableRectangle(lua_State* luaState, lua_Number visibility);
		void BeforeRenderDrawable(lua_State* luaState);
		void AfterRenderDrawable(lua_State* luaState);
		void ApplyTransform(Transform &transform);
		void ApplyTransformForChildren(Transform &transform);
		void InvertTransformValues(Transform &transform);
		void SetUpCamera(lua_State* luaState);
		void SetUpTextureMode(lua_State* luaState);
		Color GetColor(lua_State* luaState);
		Vector2 GetVector2(lua_State* luaState);
		void ReadVector2(lua_State* luaState, Vector2&);
		Vector2 GetVector2FromTableField(lua_State* luaState, std::string fieldName);
		Vector2 GetVector2FromTableFunction(lua_State* luaState, std::string functionName);
		void ReadVector2FromTableField(lua_State* luaState, std::string fieldName, Vector2&);
		Transform GetTransform(lua_State *luaState);
		GLuint GetTextureId(lua_State* luaState);
		GLint GetTextureMode(lua_State* luaState, std::string fieldName);

		bool isInitiated;
		int screenWidth, screenHeight;
	};
}

#endif
