#include "../include/VegaFunctions.h"
#include "../include/SDL.h"
#include <iostream>
using namespace std;

void VegaInit()
{
	if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
	{
		cerr << "Unable to init SDL: " << SDL_GetError() << "." << endl;
		return;
	}
	freopen("CON", "wt", stdout);
	freopen("CON", "wt", stderr);
	int flags = (false ? SDL_FULLSCREEN : 0) | SDL_OPENGL | SDL_DOUBLEBUF | SDL_HWSURFACE;
	SDL_SetVideoMode(800, 600, 32, flags);
	SDL_WM_GrabInput(SDL_GRAB_OFF);
	SDL_ShowCursor(true);
	SDL_WM_SetCaption("VegaEngine", NULL);
}

void VegaFinish()
{
	SDL_Quit();
}

void VegaLoop()
{
	bool end = false;
	while (!end)
	{
		SDL_Event evt;
		while (SDL_PollEvent(&evt))
		{
			switch (evt.type)
			{
			case SDL_QUIT:
				end = true;
				break;
			}
			SDL_GL_SwapBuffers();
			SDL_Flip(SDL_GetVideoSurface());
		}
	}
}