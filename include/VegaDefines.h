#ifndef VEGAENGINE_VEGADEFINES_H
#define VEGAENGINE_VEGADEFINES_H

#include <iostream>
#include "SDL.h"
#include "App.h"

#define INITAPP(startComponentScriptName) \
	int main(int argc, char** argv) \
	{ \
		vega::App app; \
		app.ExecuteMainLoop(startComponentScriptName); \
		return 0; \
	}

#endif
