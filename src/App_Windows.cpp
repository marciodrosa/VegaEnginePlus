#include "../include/App.h"

// This cpp file contains some implementations of the App class available only for the Windows platform.

#ifdef VEGA_WINDOWS

using namespace std;
using namespace vega;

void App::InitSDLApp()
{
	if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
	{
		cerr << "Unable to init SDL: " << SDL_GetError() << "." << endl;
		return;
	}
	int imageFlags = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF;
	if (IMG_Init(imageFlags) && imageFlags != imageFlags)
		cerr << "Warning: failed to init image libraries: " << IMG_GetError() << endl;
	int videoModeFlags = SDL_OPENGL | SDL_DOUBLEBUF | SDL_HWSURFACE;
	SDL_SetVideoMode(800, 600, 32, videoModeFlags);
	SDL_WM_GrabInput(SDL_GRAB_OFF);
	SDL_ShowCursor(true);
	SDL_WM_SetCaption("Vega", NULL);
	sceneRender.Init();
}

void App::CheckInputOnSDL(lua_State* luaState)
{
	SDL_Event evt;
	while (SDL_PollEvent(&evt))
	{
		switch (evt.type)
		{
		case SDL_QUIT:
			SetExecutingFieldToFalse(luaState);
			break;
		}
	}
}

void App::GetScreenSize(int *w, int *h)
{
	w = &SDL_GetVideoSurface()->w;
	h = &SDL_GetVideoSurface()->h;
}

void App::OnRenderFinished()
{
	SDL_GL_SwapBuffers();
	SDL_Flip(SDL_GetVideoSurface());
}

#endif
