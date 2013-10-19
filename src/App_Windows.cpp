#include "../include/CApi.h"
#include "../include/App.h"
#include "../include/Log.h"
#include "../include/Mouse.h"

#include <sstream>
using namespace vega;
using namespace std;

// This cpp file contains some implementations of the App class available only for the Windows platform.

#ifdef VEGA_WINDOWS

float App::scroll = 0;

void App::InitGLFW()
{
	glfwSetErrorCallback(App::GLFWErrorCallback);
	if (!glfwInit())
	{
		Log::Error("Unable to init GLFW.");
		return;
	}
	window = glfwCreateWindow(640, 480, "Vega", NULL, NULL);
	if (window == NULL)
	{
		Log::Error("Unable to create GLFW window.");
		return;
	}
	glfwMakeContextCurrent(window);
	glfwSetScrollCallback(window, App::GLFWMouseScrollCallback);
	sceneRender.Init();
	sceneRender.SetScreenSize(640, 480);
}

void App::GLFWErrorCallback(int error, const char* description)
{
	Log::Error(description);
}

void App::GLFWMouseScrollCallback(GLFWwindow *window, double xoffset, double yoffset)
{
	scroll = yoffset;
}

/**
Processes the input events.
*/
void App::ProcessInput()
{
	glfwPollEvents();
	if (glfwWindowShouldClose(window))
		SetExecutingFieldToFalse();
	ProcessMouseEvents();
	scroll = 0;
}

/**
Processes the mouse cursor position and button states. It also updates the context.input.mouse Lua table.
*/
void App::ProcessMouseEvents()
{
	double newMouseX = 0, newMouseY = 0;
	glfwGetCursorPos(window, &newMouseX, &newMouseY);
	Mouse lastMouseState = currentMouseState;
	Mouse newMouseState;
	newMouseState.SetPosition(Vector2((float) newMouseX, (float) 480.f - newMouseY));
	newMouseState.SetMotion(Vector2(newMouseX - lastMouseState.GetPosition().x, newMouseY - lastMouseState.GetPosition().y), scroll);
	newMouseState.SetLeftMouseButton(GetMouseButtonState(GLFW_MOUSE_BUTTON_LEFT, lastMouseState.GetLeftMouseButton()));
	newMouseState.SetMiddleMouseButton(GetMouseButtonState(GLFW_MOUSE_BUTTON_MIDDLE, lastMouseState.GetMiddleMouseButton()));
	newMouseState.SetRightMouseButton(GetMouseButtonState(GLFW_MOUSE_BUTTON_RIGHT, lastMouseState.GetRightMouseButton()));
	currentMouseState = newMouseState;
	
	lua_getfield(luaState, -1, "input");
	lua_getfield(luaState, -1, "mouse");
	newMouseState.WriteOnLuaTable(luaState);
	lua_pop(luaState, 2); // pops mouse and input
}

MouseButton App::GetMouseButtonState(int mouseButtonId, MouseButton& lastMouseButtonState)
{
	MouseButton newMouseButtonState;
	int state = glfwGetMouseButton(window, mouseButtonId);
	newMouseButtonState.pressed = state == GLFW_PRESS;
	newMouseButtonState.wasClicked = newMouseButtonState.pressed && !lastMouseButtonState.pressed;
	newMouseButtonState.wasReleased = !newMouseButtonState.pressed && lastMouseButtonState.pressed;
	return newMouseButtonState;
}

void App::SetScreenSize(int w, int h, bool windowMode)
{
	/*int videoModeFlags = SDL_OPENGL | SDL_DOUBLEBUF | SDL_HWSURFACE;
	if (!windowMode)
		videoModeFlags |= SDL_FULLSCREEN;
	SDL_SetVideoMode(w, h, 32, videoModeFlags);
	sceneRender.Init();
	sceneRender.SetScreenSize(w, h);*/
}

void App::GetScreenSize(int *w, int *h)
{
	*w = 640;//SDL_GetVideoSurface()->w;
	*h = 480;//SDL_GetVideoSurface()->h;
}

bool App::IsWindowMode()
{
	return false;//(SDL_GetVideoSurface()->flags & SDL_FULLSCREEN) == 0;
}

void App::OnRenderFinished()
{
	glfwSwapBuffers(window);
}

#endif
